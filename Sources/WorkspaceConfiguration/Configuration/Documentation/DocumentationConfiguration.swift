/*
 DocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import WSLocalizations

/// Options related to documentation.
public struct DocumentationConfiguration : Codable {

    // MARK: - Properties

    /// The localizations supported by the project.
    ///
    /// The default contains no localizations, but some tasks may throw errors if they require localizations to be specified.
    ///
    /// ### Localizing Documentation
    ///
    /// When documenting with more than one localization active, each documentation comment must be marked according to its localization.
    ///
    /// ```swift
    /// // @localization(🇫🇷FR)
    /// /// Vérifie l’inégalité.
    /// // @localization(🇨🇦EN) @localization(🇬🇧EN)
    /// /// Checks for inequality.
    /// infix operator ≠
    /// ```
    ///
    /// Localized versions of a symbol can be cross‐referenced with each other so that they will be treated as the same symbol. In the following example, `doSomething()` will only appear in the English documentation and `faireQuelqueChose()` will only appear in the French documentation. Switching the language while looking at one of them will display the opposite function.
    ///
    /// ```swift
    /// // @localization(🇨🇦EN) @localization(🇬🇧EN) @crossReference(doSomething)
    /// /// Does something.
    /// public func doSomething() {}
    /// // @localization(🇫🇷FR) @crossReference(doSomething)
    /// /// Fait quelque chose.
    /// public func faireQuelqueChose() {}
    /// ```
    public var localizations: [LocalizationIdentifier] = []

    /// The semantic version of the current stable release of the project.
    ///
    /// There is no default version.
    public var currentVersion: Version?

    /// The URL of the project website.
    ///
    /// There is no default website.
    public var projectWebsite: URL?

    /// The root URL where Workspace‐generated API documentation is hosted.
    public var documentationURL: URL?

    /// The URL of the project repository.
    ///
    /// There is no default URL.
    public var repositoryURL: URL?

    /// The primary project author.
    ///
    /// There is no default author.
    public var primaryAuthor: StrictString?

    /// Installation instructions.
    ///
    /// Default instructions exist for executable products if `repositoryURL` and `currentVersion` are defined.
    public var installationInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        guard let packageURL = configuration.documentation.repositoryURL,
            let version = configuration.documentation.currentVersion else {
                return [:]
        }

        var result: [LocalizationIdentifier: StrictString] = [:]
        for localization in configuration.documentation.localizations {
            if let provided = localization._reasonableMatch {
                result[localization] = localizedToolInstallationInstructions(
                    packageURL: packageURL,
                    version: version,
                    localization: provided)
            }
        }
        return result
    })

    /// Importing instructions.
    ///
    /// Default instructions exist for library products if `repositoryURL` and `currentVersion` are defined.
    public var importingInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        guard let packageURL = configuration.documentation.repositoryURL,
            let version = configuration.documentation.currentVersion else {
                return [:]
        }

        var result: [LocalizationIdentifier: StrictString] = [:]
        for localization in configuration.documentation.localizations {
            if let provided = localization._reasonableMatch {
                result[localization] = localizedLibraryImportingInstructions(
                    packageURL: packageURL,
                    version: version,
                    localization: provided)
            }
        }
        return result
    })

    /// The about section.
    public var about: [LocalizationIdentifier: Markdown] = [:]

    /// A list of related projects.
    ///
    /// There are no default related projects.
    public var relatedProjects: [RelatedProjectEntry] = []

    /// Options related to the project read‐me.
    public var readMe: ReadMeConfiguration = ReadMeConfiguration()

    /// Options related to API documentation.
    public var api: APIDocumentationConfiguration = APIDocumentationConfiguration()

    // MARK: - Installation Instructions

    private static func localizedToolInstallationInstructions(packageURL: URL, version: Version, localization: ContentLocalization) -> StrictString? {

        let tools = WorkspaceContext.current.manifest.products.filter { $0.type == .executable }

        guard ¬tools.isEmpty else {
            return nil
        }

        let projectName = WorkspaceContext.current.manifest.packageName
        let toolNames = tools.map { $0.name }

        return [
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
                    var result: StrictString = ""
                    if tools.count == 1 {
                        result += "It"
                    } else {
                        result += "They"
                    }
                    result += " can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update "
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
