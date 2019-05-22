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

    /// The entire contents of the read‐me.
    ///
    /// By default, this is assembled from the other documentation and read‐me options.
    ///
    /// Workspace will replace the dynamic element `#packageDocumentation` with the documentation comment parsed from the package manifest.
    public var contents: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        var result: [LocalizationIdentifier: Markdown] = [:]
        for localization in configuration.documentation.localizations {

            var readMe: [StrictString] = []

            if let provided = localization._reasonableMatch {
                readMe += [
                    OperatingSystem.allCases.filter({ configuration.supportedOperatingSystems.contains($0) }).map({ $0._isolatedName(for: provided) }).joined(separator: " • "),
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

            if let installation = configuration.documentation.installationInstructions.resolve(configuration)[localization] {
                let header: StrictString
                switch localization._bestMatch {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    header = "Installation"
                }
                readMe += [
                    "",
                    "## " + header,
                    "",
                    installation
                ]
            }
            if let importing = configuration.documentation.importingInstructions.resolve(configuration)[localization] {
                let header: StrictString
                switch localization._bestMatch {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    header = "Importing"
                }
                readMe += [
                    "",
                    "## " + header,
                    "",
                    importing
                ]
            }

            if let about = configuration.documentation.about[localization] {
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
}
