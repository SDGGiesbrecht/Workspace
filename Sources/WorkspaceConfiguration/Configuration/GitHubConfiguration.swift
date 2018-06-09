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
    ///
    /// The project name can be inserted using `[_project_]`.
    public var contributingInstructions: Lazy<Markdown> = Lazy<Markdown>() { configuration in

        var instructions: [Markdown] = [
            "# Contributing to [_project_]",
            "",
            "Everyone is welcome to contribute to [_project_]!",
            "",
            "## Step 1: Report",
            "",
            "From the smallest typo to the severest crash, whether you are reporting a bug or requesting a new feature, whether you already have a solution in mind or not, please **always start by reporting it**.",
            "",
            "Please start by searching the [existing issues](../../issues) to see if something related has already been reported.",
            "",
            "\u{2D} If there is already a related issue, please join that conversation and share any additional information you have.",
            "\u{2D} Otherwise, open a [new issue](../../issues/new). Please provide as much of the following as you can:",
            "",
            "    1. A concise and specific description of the bug or feature.",
            "    2. If it is a bug, try to provide a demonstration of the problem:",
            "        \u{2D} Optimally, provide a minimal example—a few short lines of source that trigger the problem when they are copied, pasted and run.",
            "        \u{2D} As a fallback option, if your own code is public, you could provide a link to your source code at the point where the problem occurs.",
            "        \u{2D} If neither of the above options is possible, please at least try to describe in words how to reproduce the problem.",
            "    3. Say whether or not you would like the honour of helping implement the fix or feature yourself.",
            "    4. Share any ideas you may have of possible solutions or designs.",
            "",
            "Even if you think you have the solution, please **do not start working on it** until you hear from one of the project administrators. This may save you some work in the event that someone else is already working on it, or if your idea ends up deemed beyond the scope of the project goals.",
            "",
            "## Step 2: Branch",
            "",
            "If you have [reported](#step\u{2D}1\u{2D}report) your idea and an administrator has given you the green light, follow these steps to get a local copy you can work on.",
            "",
            "1. **Fork the repository** by clicking “Fork” in the top‐right of the repository page. (Skip this step if you have been given write access.)",
            "2. **Create a local clone**. `git clone https://github.com/`user`/[_project_]`",
            "3. **Create a development branch**. `git checkout \u{2D}b `branch\u{2D}name` `",
            "4. **Set up the workspace** by double‐clicking `Refresh` in the root folder.",
            "",
            "Now you are all set to try out your idea.",
            "",
            "## Step 3: Submit",
            "",
            "Once you have your idea working properly, follow these steps to submit your changes.",
            "",
            "1. **Validate your changes** by double‐clicking `Validate` in the root folder.",
            "2. **Commit your changes**. `git commit \u{2D}m \u{22}`Description of changes.`\u{22}`",
            "3. **Push your changes**. `git push`",
            "4. **Submit a pull request** by clicking “New Pull Request” in the branch list on GitHub. In your description, please:",
            "    \u{2D} Link to the original issue with `#`000` `.",
            "    \u{2D} State your agreement to licensing your contributions under the [project licence](LICENSE.md).",
            "5. **Wait for continuous integration** to complete its validation.",
            ]

        let administrators = configuration.gitHub.administrators
        var administratorList: String
        if administrators.isEmpty {
            administratorList = "an administrator"
        } else {
            administratorList = administrators.dropLast().joined(separator: ", ").appending(" or " + administrators.last!)
        }
        instructions += [
            "6. **Request a review** from \(administratorList) by clicking the gear in the top right of the pull request page."
        ]

        if let notes = configuration.gitHub.developmentNotes {
            instructions.append(contentsOf: [
                "",
                "## Development Notes",
                "",
                notes
                ])
        }

        return instructions.joined(separator: "\n")
    }

    /// The issue template.
    ///
    /// By default, this is assembled from the other GitHub options.
    public var issueTemplate: Lazy<Markdown> = Lazy<Markdown>() { configuration in
        var template = [
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

        return template.joined(separator: "\n")
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
