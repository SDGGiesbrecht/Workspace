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
    
    // [_Warning: Convert more of these to resources._]

    /// The issue template.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var issueTemplate: Lazy<Markdown> = Lazy<Markdown>() { configuration in
        var template: [StrictString] = [
            "<\u{21}\u{2D}\u{2D} Reminder: \u{2D}\u{2D}>",
            "<\u{21}\u{2D}\u{2D} Have you searched to see if a related issue exists already? \u{2D}\u{2D}>",
            "<\u{21}\u{2D}\u{2D} If one exists, please add your information there instead. \u{2D}\u{2D}>",
            "",
            "### Description",
            "",
            "“Such‐and‐such appears broken.”",
            "or",
            "“Such‐and‐such would be a nice feature.”",
            "",
            "### Demonstration",
            "<\u{21}\u{2D}\u{2D} If the issue is not a bug, erase this section.) \u{2D}\u{2D}>",
            ""
        ]

        let products = WorkspaceContext.current.manifest.products
        if products.contains(where: { $0.type == .library }) {
            template += [
                "```swift",
                "let thisCode = trigger(theBug)",
                "",
                "// Or provide a link to code elsewhere.",
                "```"
            ]
        }
        if products.contains(where: { $0.type == .executable }) {
            template += [
                "```shell",
                "this script \u{2D}\u{2D}triggers \u{22}the bug\u{22}",
                "",
                "# Or provide a link to a script elsewhere.",
                "```"
            ]
        }

        template += [
            "",
            "### Availability to Help",
            "",
            "<\u{21}\u{2D}\u{2D} Keep only one of the following lines. \u{2D}\u{2D}>",
            "I **would like** the honour of helping with the implementation, and I think **I know my way around**.",
            "I **would like** the honour of helping with the implementation, but **I would need some guidance** along the way.",
            "I **do not want to help** with the implementation.",
            "",
            "### Solution/Design Thoughts",
            "",
            "It might work to do something like..."
        ]

        return template.joinedAsLines()
    }

    /// The pull request template.
    ///
    /// This defaults to a generic template.
    public var pullRequestTemplate: Markdown = [
        "<\u{21}\u{2D}\u{2D} Reminder: \u{2D}\u{2D}>",
        "<\u{21}\u{2D}\u{2D} Have you opened an issue and gotten a response from an administrator? \u{2D}\u{2D}>",
        "<\u{21}\u{2D}\u{2D} Always do that first; sometimes it will save you some work. \u{2D}\u{2D}>",
        "",
        "<\u{21}\u{2D}\u{2D} Fill in the issue number. \u{2D}\u{2D}>",
        "This work was commissioned by an administrator in issue #000.",
        "",
        "<\u{21}\u{2D}\u{2D} Keep only one of the following lines. \u{2D}\u{2D}>",
        "I **am licensing** this under the [project licence](../blob/master/LICENSE.md).",
        "I **refuse to license** this under the [project licence](../blob/master/LICENSE.md)."
        ].joinedAsLines()
}
