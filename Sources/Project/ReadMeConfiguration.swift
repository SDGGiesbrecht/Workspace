import SDGCollections
import GeneralImports

extension ReadMeConfiguration {

    internal var normalizedShortProjectDescription: [LocalizationIdentifier: StrictString] {
        return shortProjectDescription.mapKeyValuePairs { localization, text in
            return (DocumentationConfiguration.normalize(localizationIdentifier: localization), StrictString(text))
        }
    }

    internal func resolvedContents(for package: PackageRepository) throws -> [LocalizationIdentifier: StrictString] {
        var templates = contents.resolve(try package.cachedConfiguration()).mapKeyValuePairs { localization, text in
            return (DocumentationConfiguration.normalize(localizationIdentifier: localization), StrictString(text))
        }
        let installation = try resolvedInstallationInstructions(for: package)
        templates = try templates.mapKeyValuePairs { (language, template) in
            var result = Template(source: template)

            result.insert(try localizationLinksMarkup(for: package), for: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "localizationLinks"
                }
            }))

            let apis: StrictString
            if let modules = try apiLinksMarkup(for: package, localization: language) {
                apis = modules
            } else {
                apis = ""
            }
            result.insert(apis, for: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "apiLinks"
                }
            }))

            let localizedInstallation: StrictString
            if let specified = installation[language] {
                localizedInstallation = specified
            } else {
                localizedInstallation = ""
            }
            result.insert(localizedInstallation, for: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "installationInstructions"
                }
            }))

            return (language, result.text)
        }
        return templates
    }

    // MARK: - Localization Links

    private static let documentationDirectoryName = "Documentation"
    public static func documentationDirectory(for project: PackageRepository) -> URL {
        return project.location.appendingPathComponent(ReadMeConfiguration.documentationDirectoryName)
    }

    public static func locationOfDocumentationFile(named name: StrictString, for localization: String, in project: PackageRepository) -> URL {
        let icon = ContentLocalization.icon(for: localization) ?? StrictString("[" + localization + "]")
        let fileName: StrictString = icon + " " + name + ".md"
        return documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    public static func readMeLocation(for project: PackageRepository, localization: String) -> URL {
        return ReadMeConfiguration.locationOfDocumentationFile(named: UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Read Me"
            }
        }).resolved(for: ContentLocalization(reasonableMatchFor: localization) ?? ContentLocalization.fallbackLocalization), for: localization, in: project)
    }

    public static let skipInJazzy: StrictString = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    private func localizationLinksMarkup(for project: PackageRepository) throws -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in try project.localizations() {
            let linkText = ContentLocalization.icon(for: targetLocalization) ?? StrictString("[" + targetLocalization + "]")
            let absoluteURL = ReadMeConfiguration.readMeLocation(for: project, localization: targetLocalization)
            var relativeURL = StrictString(absoluteURL.path(relativeTo: project.location))
            relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

            var link: StrictString = "[" + linkText + "]"
            link += "(" + relativeURL + ")"
            links.append(link)
        }
        return StrictString(links.joined(separator: " • ".scalars)) + " " + ReadMeConfiguration.skipInJazzy
    }

    // MARK: - API Links

    private func apiLinksMarkup(for project: PackageRepository, localization: String) throws -> StrictString? {

        guard let baseURL = try project.cachedConfiguration().documentation.documentationURL else {
            return nil
        }

        let label = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "APIs:"
            }
        }).resolved(for: ContentLocalization(reasonableMatchFor: localization) ?? ContentLocalization.fallbackLocalization)

        let links: [StrictString] = try project.productModules().map { module in
            var link: StrictString = "[" + StrictString(module.name) + "]"
            link += "(" + StrictString(baseURL.appendingPathComponent(module.name).absoluteString) + ")"
            return link
        }

        return label + " " + StrictString(links.joined(separator: " • ".scalars))
    }

    // MARK: - Installation Instructions

    private func resolvedInstallationInstructions(for project: PackageRepository) throws -> [LocalizationIdentifier: StrictString] {

        guard let repository = try project.cachedConfiguration().documentation.repositoryURL,
            let versionString = try project.cachedConfiguration().documentation.currentVersion,
            let version = Version(versionString) else {
                return [:]
        }

        var tools = try project.cachedPackage().products.filter { $0.type == .executable }
        if ¬tools.isEmpty {
            // Filter out tools which have not been declared as products.
            switch try project.cachedManifest().package {
            case .v3:
                // [_Exempt from Test Coverage_] Not officially supported anyway.
                tools = [] // No concept of products.
            case .v4(let manifest):
                let publicProducts = Set(manifest.products.map({ $0.name }))
                tools = tools.filter { $0.name ∈ publicProducts }
            }
        }

        let libraries = try project.cachedPackage().products.filter { $0.type.isLibrary }

        guard ¬(tools + libraries).isEmpty else {
            return [:]
        }

        return try assembleInstallationInstructions(project: project, tools: tools, libraries: libraries, repository: repository, version: version)
    }

    private func assembleInstallationInstructions(project: PackageRepository, tools: [Product], libraries: [Product], repository: URL, version: Version) throws -> [LocalizationIdentifier: StrictString] {

        var result: [LocalizationIdentifier: StrictString] = [:]
        for localization in ContentLocalization.cases {
            var contents: StrictString = ""
            var includedToolInstallationSection = false
            if let toolInstallation = try localizedToolInstallationInstructions(project: project, tools: tools, repository: repository, version: version, localization: localization) {
                contents += toolInstallation
                includedToolInstallationSection = true
            }
            if let libraryLinking = try localizedLibraryImportingInstructions(project: project, libraries: libraries, repository: repository, version: version, localization: localization) {
                if includedToolInstallationSection {
                    contents += "\n"
                }
                contents += libraryLinking
            }
            result[DocumentationConfiguration.normalize(localizationIdentifier: localization.code)] = contents
        }
        return result
    }

    private func localizedToolInstallationInstructions(project: PackageRepository, tools: [Product], repository: URL, version: Version, localization: ContentLocalization) throws -> StrictString? {
        guard ¬tools.isEmpty else {
            return nil
        }

        let projectName = try project.projectName()
        let toolNames = tools.map { $0.name }

        return [
            "## " + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Installation"
                }
            }).resolved(for: localization),
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result = StrictString("\(projectName) provides ")
                    if tools.count == 1 {
                        result += "a command line tool"
                    } else {
                        result += "command line tools"
                    }
                    result += "."
                    return result
                }
            }).resolved(for: localization),
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result = StrictString("Paste the following into a terminal to install or update")
                    if tools.count == 1 {
                        result += "it"
                    } else {
                        result += "them"
                    }
                    result += ":"
                    return result
                }
            }).resolved(for: localization),
            "",
            "```shell",
            StrictString("curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s \(projectName) \u{22}\(repository.absoluteString)\u{22} \(version.string()) \u{22}\(tools.first!) help\u{22} " + toolNames.joined(separator: " ")),
            "```"
        ].joined(separator: "\n")
    }

    private func localizedLibraryImportingInstructions(project: PackageRepository, libraries: [Product], repository: URL, version: Version, localization: ContentLocalization) throws -> StrictString? {
        guard ¬libraries.isEmpty else {
            return nil
        }

        let projectName = try project.projectName()
        var versionSpecification: StrictString
        if version.major == 0 {
            versionSpecification = StrictString(".upToNextMinor(from: Version(\(version.major), \(version.minor), \(version.patch)))")
        } else {
            versionSpecification = StrictString("from: Version(\(version.major), \(version.minor), \(version.patch))")
        }

        var result = [
            "## " + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Importing"
                }
            }).resolved(for: localization),
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result = StrictString("\(projectName) provides ")
                    if libraries.count == 1 {
                        result += "a library"
                    } else {
                        result += "libraries"
                    }
                    result += " for use with the [Swift Package Manager](https://swift.org/package-manager/)."
                    return result
                }
            }).resolved(for: localization),
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result = StrictString("Simply add \(projectName) as a dependency in `Package.swift`")
                    if libraries.count == 1 {
                        result += ":"
                    } else {
                        result += " and specify which of the libraries to use:"
                    }
                    return result
                }
            }).resolved(for: localization),
            "",
            "```swift",
            StrictString("let ") + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "package"
                }
            }).resolved(for: localization) + " = Package(",
            (StrictString("    name: \u{22}") + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "MyPackage"
                }
            }).resolved(for: localization) + StrictString("\u{22},")) as StrictString,
            "    dependencies: [",
            StrictString("        .package(url: \u{22}\(repository.absoluteString)\u{22}, \(versionSpecification)),"),
            "    ],",
            "    targets: [",
            (StrictString("        .target(name: \u{22}") + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "MyTarget"
                }
            }).resolved(for: localization) + StrictString("\u{22}, dependencies: [")) as StrictString
        ]

        for library in libraries {
            result += [StrictString("            .productItem(name: \u{22}\(library.name)\u{22}, package: \u{22}\(try project.cachedManifest().name)\u{22}),")]
        }

        result += [
            "        ])",
            "    ]",
            ")",
            "```",
            "",
            UserFacingDynamic<StrictString, ContentLocalization, StrictString>({ localization, package in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result = StrictString("The ")
                    if libraries.count == 1 {
                        result += "library’s "
                        if libraries.first!.targets.count == 1 {
                            result += "module"
                        } else {
                            result += "modules"
                        }
                    } else {
                        result += "libraries’ modules"
                    }
                    result += " can then be imported in source files:"
                    return result
                }
            }).resolved(using: StrictString(try project.cachedManifest().name)),
            "",
            "```swift"
        ]

        for module in try project.productModules() {
            result += [StrictString("import \(module.name)")]
        }

        result += [
            "```"
        ]

        return result.joined(separator: "\n")
    }
}
