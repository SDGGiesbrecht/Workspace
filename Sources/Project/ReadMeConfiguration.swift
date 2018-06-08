import SDGCollections
import GeneralImports

extension ReadMeConfiguration {

    public var normalizedShortProjectDescription: [LocalizationIdentifier: StrictString] {
        return shortProjectDescription.mapKeyValuePairs { localization, text in
            return (DocumentationConfiguration.normalize(localizationIdentifier: localization), StrictString(text))
        }
    }

    // MARK: - Installation Instructions

    public func resolvedInstallationInstructions(for project: PackageRepository) throws -> [LocalizationIdentifier: StrictString] {

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

        var listedModules: Set<String> = []
        for library in libraries {
            for module in library.targets where module.name ∉ listedModules {
                listedModules.insert(module.name)
                result += [StrictString("import \(module.name)")]
            }
        }

        result += [
            "```"
        ]

        return result.joined(separator: "\n")
    }
}
