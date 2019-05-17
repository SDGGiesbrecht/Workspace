/*
 ReadMeConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import WSLocalizations

/// Options related to the project read‐me.
///
/// ```shell
/// $ workspace refresh read‐me
/// ```
///
/// A read‐me is a `README.md` file that GitHub and documentation generation use as the project’s main page.
public struct ReadMeConfiguration : Codable {

    // MARK: - Options

    /// Whether or not to manage the project read‐me.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// Installation instructions.
    ///
    /// Default instructions exist for executable and library products if `repositoryURL` and `currentVersion` are defined.
    public var installationInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        guard let packageURL = configuration.documentation.repositoryURL,
            let version = configuration.documentation.currentVersion else {
                return [:]
        }

        var result: [LocalizationIdentifier: StrictString] = [:]
        for localization in configuration.documentation.localizations {
            if let provided = localization._reasonableMatch {

                var instructions: [StrictString] = []
                var precedingSection = false

                if let toolInstallation = localizedToolInstallationInstructions(packageURL: packageURL, version: version, localization: provided) {
                    precedingSection = true

                    instructions += [toolInstallation]
                }

                if let libraryLinking = localizedLibraryImportingInstructions(packageURL: packageURL, version: version, localization: provided) {
                    if precedingSection {
                        instructions += [""]
                    }
                    precedingSection = true

                    instructions += [libraryLinking]
                }

                if ¬instructions.isEmpty {
                    result[localization] = instructions.joinedAsLines()
                }
            }
        }
        return result
    })

    /// Example usage.
    ///
    /// There are no examples by default.
    ///
    /// Arbitrary examples can be parsed from the project source by including placeholders of the form “&#x23;example(someExampleIdentifier)” in the markdown.
    public var exampleUsage: [LocalizationIdentifier: Markdown] = [:]

    /// The about section.
    public var about: [LocalizationIdentifier: Markdown] = [:]

    /// The entire contents of the read‐me.
    ///
    /// By default, this is assembled from the other documentation and read‐me options.
    ///
    /// Workspace will replace the dynamic element `#packageDocumentation` with the documentation comment parsed from the package manifest.
    public var contents: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        var result: [LocalizationIdentifier: Markdown] = [:]
        for localization in configuration.documentation.localizations {

            var readMe: [StrictString] = [
                localizationLinks(configuration.documentation.localizations),
                ""
            ]

            if let provided = localization._reasonableMatch {
                readMe += [
                    OperatingSystem.allCases.filter({ configuration.supportedOperatingSystems.contains($0) }).map({ $0.isolatedName(for: provided) }).joined(separator: " • "),
                    ""
                ]
            }

            if let api = apiLink(for: configuration, in: localization) {
                readMe += [
                    api,
                    ""
                ]
            }

            readMe += ["# " + WorkspaceContext.current.manifest.packageName.scalars]

            readMe += [
                "",
                "#packageDocumentation"
            ]

            if let related = relatedProjectsLink(for: configuration, in: localization) {
                readMe += [
                    "",
                    related
                ]
            }

            if let instructions = configuration.documentation.readMe.installationInstructions.resolve(configuration)[localization] {
                readMe += [
                    "",
                    instructions
                ]
            }

            if let examples = configuration.documentation.readMe.exampleUsage[localization] {
                let header: StrictString
                switch localization._bestMatch {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    header = "Example Usage"
                }
                readMe += [
                    "",
                    "## " + header,
                    "",
                    examples
                ]
            }

            if let about = configuration.documentation.readMe.about[localization] {
                let header: StrictString
                switch localization._bestMatch {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    header = "About"
                }
                readMe += [
                    "",
                    "## " + header,
                    "",
                    about
                ]
            }

            result[localization] = readMe.joinedAsLines()
        }
        return result
    })

    // MARK: - Useful components.

    private static let documentationDirectoryName = "Documentation"
    public static func _documentationDirectory(for project: URL) -> URL {
        return project.appendingPathComponent(documentationDirectoryName)
    }

    private static func _locationOfDocumentationFile(named name: StrictString, for localization: LocalizationIdentifier, in project: URL) -> URL {
        let icon = ContentLocalization.icon(for: localization.code) ?? "[\(localization.code)]"
        let fileName: StrictString = icon + " " + name + ".md"
        return _documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    public static func _readMeLocation(for project: URL, localization: LocalizationIdentifier) -> URL {
        let name: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            name = "Read Me"
        }
        return _locationOfDocumentationFile(named: name, for: localization, in: project)
    }

    /// Constructs links to the read‐me in its other languages.
    ///
    /// - Parameters:
    ///     - localizations: An array of localizations to include.
    public static func localizationLinks(_ localizations: [LocalizationIdentifier]) -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in localizations {
            let linkText = ContentLocalization.icon(for: targetLocalization.code) ?? "[\(targetLocalization.code)]"
            let absoluteURL = _readMeLocation(for: WorkspaceContext.current.location, localization: targetLocalization)
            var relativeURL = StrictString(absoluteURL.path(relativeTo: WorkspaceContext.current.location))
            relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

            var link: StrictString = "[" + linkText + "]"
            link += "(" + relativeURL + ")"
            links.append(link)
        }
        return StrictString(links.joined(separator: " • ".scalars))
    }

    /// Attempts to construct API links based on the specified configuration.
    ///
    /// The result will be `nil` if `documentationURL` is not specified or if the requested localization is not supported.
    ///
    /// - Parameters:
    ///     - configuration: The configuration based on which the links should be constructed.
    ///     - localization: The localization to use.
    public static func apiLink(for configuration: WorkspaceConfiguration, in localization: LocalizationIdentifier) -> StrictString? {

        guard let baseURL = configuration.documentation.documentationURL,
            let provided = localization._reasonableMatch else {
            return nil
        }

        let label: StrictString
        switch provided {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            label = "Documentation"
        }

        var link: StrictString = "[" + label + "]("
        link += StrictString(baseURL.appendingPathComponent(String(localization._directoryName)).absoluteString) + ")"
        return link
    }

    // MARK: - Related Projects

    public static func _relatedProjectsLocation(for project: URL, localization: LocalizationIdentifier) -> URL {
        let name: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            name = "Related Projects"
        }
        return _locationOfDocumentationFile(named: name, for: localization, in: project)
    }

    /// Attempts to construct a link to the related projects page.
    ///
    /// The result will be `nil` if there are no related projects or if the localization is not supported.
    ///
    /// - Parameters:
    ///     - configuration: The configuration on which to base the links.
    ///     - localization: The localization to use.
    public static func relatedProjectsLink(for configuration: WorkspaceConfiguration, in localization: LocalizationIdentifier) -> StrictString? {

        guard ¬configuration.documentation.relatedProjects.isEmpty,
            let provided = localization._reasonableMatch else {
            return nil
        }

        let absoluteURL = _relatedProjectsLocation(for: WorkspaceContext.current.location, localization: localization)
        var relativeURL = StrictString(absoluteURL.path(relativeTo: WorkspaceContext.current.location))
        relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

        let link: StrictString
        switch provided {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            link = "(For a list of related projects, see [here](\(relativeURL)).)"
        }
        return link
    }

    // MARK: - Installation Instructions

    private static func localizedToolInstallationInstructions(packageURL: URL, version: Version, localization: ContentLocalization) -> StrictString? {

        let tools = WorkspaceContext.current.manifest.products.filter { $0.type == .executable }

        guard ¬tools.isEmpty else {
            return nil
        }

        let projectName = WorkspaceContext.current.manifest.packageName
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
                    var result: StrictString = "\(projectName) provides "
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
                    var result: StrictString = "Paste the following into a terminal to install or update "
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
            "curl \u{2D}sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash \u{2D}s \(projectName) \u{22}\(packageURL.absoluteString)\u{22} \(version.string()) \u{22}\(toolNames.first!) help\u{22} \(toolNames.joined(separator: " "))",
            "```"
            ].joinedAsLines()
    }

    private static func localizedLibraryImportingInstructions(packageURL: URL, version: Version, localization: ContentLocalization) -> StrictString? {

        let libraries = WorkspaceContext.current.manifest.products.filter { $0.type == .library }

        guard ¬libraries.isEmpty else {
            return nil
        }

        let projectName = WorkspaceContext.current.manifest.packageName

        var versionSpecification: StrictString
        if version.major == 0 {
            versionSpecification = ".upToNextMinor(from: Version(\(version.major.inDigits()), \(version.minor.inDigits()), \(version.patch.inDigits())))"
        } else {
            versionSpecification = "from: Version(\(version.major.inDigits()), \(version.minor.inDigits()), \(version.patch.inDigits()))"
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
                    var result: StrictString = "\(projectName) provides "
                    if libraries.count == 1 {
                        result += "a library"
                    } else {
                        result += "libraries"
                    }
                    result += " for use with the [Swift Package Manager](https://swift.org/package\u{2D}manager/)."
                    return result
                }
            }).resolved(for: localization),
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result: StrictString = "Simply add \(projectName) as a dependency in `Package.swift`"
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
            "let " + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "package"
                }
            }).resolved(for: localization) + " = Package(",
            ("    name: \u{22}" + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "MyPackage"
                }
            }).resolved(for: localization) + "\u{22},") as StrictString,
            "    dependencies: [",
            "        .package(url: \u{22}\(packageURL.absoluteString)\u{22}, \(versionSpecification)),",
            "    ],",
            "    targets: [",
            ("        .target(name: \u{22}" + UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "MyTarget"
                }
            }).resolved(for: localization) + "\u{22}, dependencies: [") as StrictString
        ]

        for library in libraries {
            result += ["            .productItem(name: \u{22}\(library.name)\u{22}, package: \u{22}\(projectName)\u{22}),"]
        }

        result += [
            "        ])",
            "    ]",
            ")",
            "```",
            "",
            UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    var result: StrictString = "The "
                    if libraries.count == 1 {
                        result += "library’s "
                        if libraries.first!.modules.count == 1 {
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
            }).resolved(for: localization),
            "",
            "```swift"
        ]

        for module in WorkspaceContext.current.manifest.productModules {
            result += ["import \(module)"]
        }

        result += [
            "```"
        ]

        return result.joinedAsLines()
    }
}
