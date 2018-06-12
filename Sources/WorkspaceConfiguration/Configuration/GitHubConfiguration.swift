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
    public var administrators: [StrictString] = []

    /// Project specific development notes.
    ///
    /// There are no default development notes.
    public var developmentNotes: Markdown?

    /// The contributing instructions.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var contributingInstructions: Lazy<Markdown> = Lazy<Markdown>() { configuration in

        var template = StrictString(Resources.contributingTemplate)

        template.replaceMatches(for: "#packageName".scalars, with: WorkspaceContext.current.manifest.packageName.scalars)

        if let url = configuration.documentation.repositoryURL {
            template.replaceMatches(for: "#cloneScript".scalars, with: " `git clone \(url.absoluteString)`".scalars)
        } else {
            template.replaceMatches(for: "#cloneScript".scalars, with: "".scalars)
        }

        let administrators = configuration.gitHub.administrators
        var administratorList: StrictString
        if administrators.isEmpty {
            administratorList = "an administrator"
        } else {
            let commas = StrictString(administrators.dropLast().joined(separator: ", ".scalars))
            let or = " or " + administrators.last!
            administratorList = commas + or
        }
        template.replaceMatches(for: "#administrators".scalars, with: administratorList)

        if let notes = configuration.gitHub.developmentNotes {
            template.append(contentsOf: [
                "",
                "## Development Notes",
                "",
                notes
                ].joinedAsLines())
        }

        return template
    }

    /// The issue template.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var issueTemplate: Lazy<Markdown> = Lazy<Markdown>() { configuration in

        var template = StrictString(Resources.issueTemplate)

        let products = WorkspaceContext.current.manifest.products
        var trigger: [StrictString] = []
        if products.contains(where: { $0.type == .library }) {
            trigger += [
                "```swift",
                "let thisCode = trigger(theBug)",
                "",
                "// Or provide a link to code elsewhere.",
                "```"
            ]
        }
        if products.contains(where: { $0.type == .executable }) {
            trigger += [
                "```shell",
                "this script \u{2D}\u{2D}triggers \u{22}the bug\u{22}",
                "",
                "# Or provide a link to a script elsewhere.",
                "```"
            ]
        }
        template.replaceMatches(for: "#trigger".scalars, with: trigger.joinedAsLines())

        return template
    }

    /// The pull request template.
    ///
    /// This defaults to a generic template.
    public var pullRequestTemplate: Markdown = StrictString(Resources.pullRequestTemplate)
}
