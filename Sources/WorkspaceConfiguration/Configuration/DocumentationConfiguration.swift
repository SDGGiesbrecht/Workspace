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

    /// The semantic version of the current stable release of the project.
    ///
    /// There is no default version.
    public var currentVersion: Version?

    /// The URL of the project website.
    ///
    /// There is no default website.
    public var projectWebsite: URL?

    /// The root URL where Workspace‐generated API documentation is hosted.
    ///
    /// Specify the directory for the package, not for an individual module. Workspace will link to each module individually.
    public var documentationURL: URL?

    /// The URL of the project repository.
    ///
    /// There is no default URL.
    public var repositoryURL: URL?

    /// The primary project author.
    ///
    /// There is no default author.
    public var primaryAuthor: StrictString?

    /// A list of related projects.
    ///
    /// There are no default related projects.
    public var relatedProjects: [RelatedProjectEntry] = []

    /// Options related to the project read‐me.
    public var readMe: ReadMeConfiguration = ReadMeConfiguration()

    /// Options related to API documentation.
    public var api: APIDocumentationConfiguration = APIDocumentationConfiguration()
}
