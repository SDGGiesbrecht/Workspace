/*
 ReadMeConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import Localizations

/// Options related to the project read‐me.
public struct ReadMeConfiguration : Codable {

    /// Whether or not to manage the project read‐me.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// A short description of the project.
    ///
    /// There is no default description.
    public var shortProjectDescription: [LocalizationIdentifier: Markdown] = [:]

    /// A quotation to go with the project.
    ///
    /// There is no default quotation.
    public var quotation: Quotation?

    /// A list of features.
    ///
    /// There is no default feature list.
    public var featureList: [LocalizationIdentifier: Markdown] = [:]

    /// Other read‐me content.
    ///
    /// There is nothing by default.
    public var other: [LocalizationIdentifier: Markdown] = [:]

    /// The about section.
    public var about: [LocalizationIdentifier: Markdown] = [:]

    /// Installation instructions.
    ///
    /// Default instructions exist for executable and library products if `repositoryURL` and `currentVersion` are defined.
    public var installationInstructions: Automatic<[LocalizationIdentifier: Markdown]> = .automatic

    /// Example usage.
    ///
    /// By default, Workspace will look for example identifiers beginning with `Read‐Me ` and ending with a localization key, and will include them in the read‐me.
    ///
    /// Arbitrary examples can be parsed from the project source by including placeholders of the form “[&#x5F;example: identifier_]” in the markdown.
    public var exampleUsage: Automatic<[LocalizationIdentifier: Markdown]> = .automatic

    /// The entire contents of the read‐me.
    ///
    /// By default, this is assembled from the other documentation and read‐me options.
    ///
    /// Workspace will replace several template tokens after the configuration is loaded:
    ///
    /// - `#localizationLinks`: Links to the read‐me in its other languages.
    /// - `#apiLinks`: Links to the generated documentation (blank unless `documentationURL` is specified).
    /// - `#relatedProjects`: A link to the list of related projects.
    /// - `#installationInstructions`: The value of `installationInstructions`
    /// - `#exampleUsage`: The value of `exampleUsage`.
    public var contents: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>() { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

        var result: [LocalizationIdentifier: Markdown] = [:]
        for localization in configuration.documentation.localizations {
            if let provided = localization._reasonableMatch {

                var readMe: [StrictString] = [
                    localizationLinksMarkup(localizations: configuration.documentation.localizations),
                    ""
                ]

                readMe += [
                    OperatingSystem.cases.filter({ configuration.supportedOperatingSystems.contains($0) }).map({ $0.isolatedName(for: provided) }).joined(separator: " • "),
                    ""
                ]

                if configuration.documentation.documentationURL ≠ nil {
                    readMe += [ // [_Warning: Sink this._]
                        "#apiLinks",
                        ""
                    ]
                }

                readMe += ["# " + WorkspaceContext.current.manifest.packageName.scalars]

                if let description = configuration.documentation.readMe.shortProjectDescription[localization] {
                    readMe += [
                        "",
                        description
                    ]
                }

                if let quotation = configuration.documentation.readMe.quotation {
                    readMe += [
                        "",
                        quotation.source(for: localization)
                    ]
                }

                if let features = configuration.documentation.readMe.featureList[localization] {
                    let header: StrictString
                    switch provided {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        header = "Features"
                    }
                    readMe += [
                        "",
                        "## " + header,
                        "",
                        features
                    ]
                }

                if ¬configuration.documentation.relatedProjects.isEmpty {
                    readMe += [
                        "",
                        "#relatedProjects" // [_Warning: Sink this._]
                    ]
                }

                readMe += [
                    "",
                    "#installationInstructions" // [_Warning: Sink this._]
                ]

                let examplesHeader: StrictString
                switch provided {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    examplesHeader = "Example Usage"
                }

                readMe += [
                    "",
                    "## " + examplesHeader,
                    "",
                    "#exampleUsage" // [_Warning: Sink this._]
                ]

                if let other = configuration.documentation.readMe.other[localization] {
                    readMe += [
                        "",
                        other
                    ]
                }

                if let about = configuration.documentation.readMe.about[localization] {
                    let header: StrictString
                    switch provided {
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
        }
        return result
    }

    // MARK: - Localization Links

    private static let documentationDirectoryName = "Documentation"
    /// :nodoc:
    public static func _documentationDirectory(for project: URL) -> URL {
        return project.appendingPathComponent(documentationDirectoryName)
    }

    /// :nodoc:
    public static func _locationOfDocumentationFile(named name: StrictString, for localization: LocalizationIdentifier, in project: URL) -> URL {
        let icon = ContentLocalization.icon(for: localization.code) ?? StrictString("[" + localization.code + "]")
        let fileName: StrictString = icon + " " + name + ".md"
        return _documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    /// :nodoc:
    public static func _readMeLocation(for project: URL, localization: LocalizationIdentifier) -> URL {
        let name: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            name = "Read Me"
        }
        return _locationOfDocumentationFile(named: name, for: localization, in: project)
    }

    /// :nodoc:
    public static let _skipInJazzy: StrictString = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    private static func localizationLinksMarkup(localizations: [LocalizationIdentifier]) -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in localizations {
            let linkText = ContentLocalization.icon(for: targetLocalization.code) ?? StrictString("[" + targetLocalization.code + "]")
            let absoluteURL = _readMeLocation(for: WorkspaceContext.current.location, localization: targetLocalization)
            var relativeURL = StrictString(absoluteURL.path(relativeTo: WorkspaceContext.current.location))
            relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

            var link: StrictString = "[" + linkText + "]"
            link += "(" + relativeURL + ")"
            links.append(link)
        }
        return StrictString(links.joined(separator: " • ".scalars)) + " " + _skipInJazzy
    }
}
