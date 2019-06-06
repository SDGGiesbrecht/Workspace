/*
 GitHubConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSLocalizations

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
        var localizations = configuration.documentation.localizations
        if localizations.isEmpty {
            localizations.append(LocalizationIdentifier(ContentLocalization.fallbackLocalization))
        }

        var result: [LocalizationIdentifier: Markdown] = [:]
        for localization in localizations {
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
                    switch localization._bestMatch {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        administratorList = "an administrator"
                    }
                } else if administrators.count == 1 {
                    administratorList = administrators.first!
                } else {
                    let separator: StrictString
                    let finalSeparator: StrictString
                    switch localization._bestMatch {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        separator = ", "
                        finalSeparator = " or "
                    }
                    let commas = StrictString(administrators.dropLast().joined(separator: separator))
                    let or = finalSeparator + administrators.last!
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

    /// The issue templates.
    ///
    /// By default, these are assembled from the other GitHub options.
    ///
    /// An issue template is a markdown file in a `.github` folder which GitHub uses when someone creates a new issue.
    public var issueTemplates: Lazy<[LocalizationIdentifier: [IssueTemplate]]>
        = Lazy<[LocalizationIdentifier: [IssueTemplate]]>(resolve: { configuration in

            var localizations = configuration.documentation.localizations
            if localizations.isEmpty {
                localizations.append(LocalizationIdentifier(ContentLocalization.fallbackLocalization))
            }

            var result: [LocalizationIdentifier: [IssueTemplate]] = [:]
            for localization in localizations {
                for providedTemplate in ProvidedIssueTemplate.allCases {
                    if let language = localization._reasonableMatch {
                        result[localization, default: []].append(providedTemplate.constructed(for: language))
                    }
                }
            }
            return result
        })

    /// The pull request template.
    ///
    /// This defaults to a generic template.
    ///
    /// A pull request template is a markdown file in a `.github` folder which GitHub uses when someone creates a new pull request.
    public var pullRequestTemplate: Markdown = StrictString(Resources.pullRequestTemplate)
}
