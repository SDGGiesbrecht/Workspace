/*
 ReadMeConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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
    public var installationInstructions: Automatic<[LocalizationIdentifier: Markdown]?> = .automatic

    /// Example usage.
    ///
    /// By default, Workspace will look for example identifiers beginning with `Read‐Me ` and ending with a localization key, and will include them in the read‐me.
    ///
    /// Arbitrary examples can be parsed from the project source by including placeholders of the form “[&#x5F;Example: identifier_]” in the markdown.
    public var exampleUsage: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return [:]
    }

    /// The entire contents of the read‐me.
    ///
    /// By default, this is assembled from the other documentation and read‐me options.
    public var contents: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return [:]
    }
}
