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

                var readMe: [StrictString] = [ // [_Warning: Sink this._]
                    "#localizationLinks",
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
}
