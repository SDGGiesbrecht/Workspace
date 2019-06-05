/*
 GitHubConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to GitHub.
///
/// ```shell
/// $ workspace refresh github
/// ```
public struct GitHubConfiguration : Codable {

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

    private static func contributingTemplate(for localization: LocalizationIdentifier) -> StrictString? {
        guard let match = localization._reasonableMatch else {
            return nil
        }
        switch match {
        case .englishUnitedKingdom, .englishCanada:
            return StrictString(Resources.contributingTemplate)
                .replacingMatches(for: "#licence".scalars, with: "licence".scalars)
        case .englishUnitedStates:
            return StrictString(Resources.contributingTemplate)
                .replacingMatches(for: "#licence".scalars, with: "license".scalars)
        }
    }

    private static func developmentNotesHeading(for localization: LocalizationIdentifier) -> StrictString {
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Development Notes"
        }
    }

    /// The contributing instructions.
    ///
    /// By default, this is assembled from the other GitHub options.
    ///
    /// Contributing instructions are instructions in a `CONTRIBUTING.md` file which GitHub directs contributors to read.
    public var contributingInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<[LocalizationIdentifier: Markdown]>(resolve: { configuration in
        var result: [LocalizationIdentifier: Markdown] = [:]

        for localization in configuration.documentation.localizations {
            if var template = GitHubConfiguration.contributingTemplate(for: localization) {

                template.replaceMatches(for: "#packageName".scalars, with: WorkspaceContext.current.manifest.packageName.scalars)

                if let url = configuration.documentation.repositoryURL {
                    template.replaceMatches(for: "#cloneScript".scalars, with: " `git clone https://github.com/user/\(url.lastPathComponent)`".scalars)
                } else {
                    template.replaceMatches(for: "#cloneScript".scalars, with: "".scalars)
                }

                let administrators = configuration.gitHub.administrators
                var administratorList: StrictString
                if administrators.isEmpty {
                    #warning("Are administrators needed?")
                    administratorList = "an administrator"
                } else if administrators.count == 1 {
                    administratorList = administrators.first!
                } else {
                    let commas = StrictString(administrators.dropLast().joined(separator: ", ".scalars))
                    let or = " or " + administrators.last!
                    administratorList = commas + or
                }
                template.replaceMatches(for: "#administrators".scalars, with: administratorList)

                if let notes = configuration.gitHub.developmentNotes {
                    template.append(contentsOf: [
                        "",
                        "## \(GitHubConfiguration.developmentNotesHeading(for: localization))",
                        "",
                        notes
                        ].joinedAsLines())
                }

                result[localization] = template
            }
        }

        return result
    })

    /// The issue template.
    ///
    /// By default, this is assembled from the other GitHub options.
    ///
    /// An issue template is a markdown file in a `.github` folder which GitHub uses when someone creates a new issue.
    public var issueTemplate: Lazy<Markdown> = Lazy<Markdown>(resolve: { _ in

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
    })

    /// The pull request template.
    ///
    /// This defaults to a generic template.
    ///
    /// A pull request template is a markdown file in a `.github` folder which GitHub uses when someone creates a new pull request.
    public var pullRequestTemplate: Markdown = StrictString(Resources.pullRequestTemplate)
}
