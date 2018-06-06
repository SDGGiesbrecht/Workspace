/*
 GitHubConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to GitHub.
public struct GitHubConfiguration: Codable {

    /// Whether or not to manage the project’s GitHub configuration files.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// A list of the administrator’s GitHub usernames.
    ///
    /// There are no default administrators.
    public var administrators: [String] = []

    /// Project specific development notes.
    ///
    /// There are no default development notes.
    public var developmentNotes: Markdown?

    /// The contributing instructions.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var contributingInstructions: Lazy<Markdown> = Lazy<Markdown>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return ""
    }

    /// The issue template.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var issueTemplate: Lazy<Markdown> = Lazy<Markdown>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return ""
    }

    /// The pull request template.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var pullRequestTemplate: Lazy<Markdown> = Lazy<Markdown>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return ""
    }
}
