/*
 DocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to documentation.
public struct DocumentationConfiguration : Codable {

    // MARK: - Properties

    /// The localizations supported by the project.
    ///
    /// The default contains no localizations, but some tasks may throw errors if they require localizations to be specified.
    public var localizations: [LocalizationIdentifier] = []

    /// The URL of the project repository.
    ///
    /// There is no default URL.
    public var repositoryURL: URL?

    /// Options related to the project read‐me.
    public var readMe: ReadMeConfiguration = ReadMeConfiguration()
}
