/*
 ProvidedIssueTemplate.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSLocalizations

internal enum ProvidedIssueTemplate: CaseIterable {

    // MARK: - Cases

    case bugReport
    case featureRequest

    // MARK: - Construction

    internal func constructed(for localization: ContentLocalization) -> IssueTemplate {
        let name: StrictString
        switch self {
        case .bugReport:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                name = "Bug Report"
            }
        case .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                name = "Feature Request"
            }
        }

        let description: StrictString
        switch self {
        case .bugReport:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                description = "Report a bug that needs fixing"
            }
        case .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                description = "Request a new feature you wish the project had"
            }
        }

        var contents: [StrictString] = []
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            contents.append(contentsOf: [
                "<!--",
                " Reminder:",
                " Have you searched to see if a related issue exists already?",
                " If one exists, please add your information there instead.",
                " -->"
                ])
        }
        contents.append("")

        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            contents.append("### Description")
        }
        contents.append("")

        switch self {
        case .bugReport:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("Such‐and‐such appears broken.")
            }
        case .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("Such‐and‐such would be a nice feature.")
            }
        }

        if self == .bugReport {
            let products = WorkspaceContext.current.manifest.products
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append(contentsOf: [
                    "",
                    "### Demonstration",
                    ""
                    ])
            }
            if products.contains(where: { $0.type == .executable }) {
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    contents.append(contentsOf: [
                        "```shell",
                        "$ this command •triggers \u{22}the bug\u{22}",
                        "```",
                        ""
                        ])
                }
            }
            if products.contains(where: { $0.type == .library }) {
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    contents.append(contentsOf: [
                        "```swift",
                        "let thisCode = trigger(theBug)",
                        "```",
                        ""
                        ])
                }
            }
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("<!-- Or provide a link to a demonstration elsewhere. -->")
            }
        }

        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            let task: StrictString
            switch self {
            case .bugReport:
                task = "fix"
            case .featureRequest:
                task = "implement"
            }
            contents.append(contentsOf: [
                "",
                "### Availability to Help",
                "",
                "<!-- Keep only one of the following lines. -->",
                "I **would like to help** \(task) it, and I think **I know my way around**.",
                "I **would like to help** \(task) it, but **I would need some guidance**.",
                "I **do not want to help** \(task) it.",
                "",
                ])
        }

        switch self {
        case .bugReport:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Possible Solution")
            }
        case .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Design Thoughts")
            }
        }
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            contents.append(contentsOf: [
                "",
                "It might work to do something like..."
                ])
        }

        var labels: [StrictString] = []
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            labels.append("🇬🇧🇺🇸🇨🇦EN")
        }
        switch self {
        case .bugReport:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                labels.append("Bug")
            }
        case .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                labels.append("Enhancement")
            }
        }
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            labels.append("Needs Investigation")
        }

        return IssueTemplate(
            name: name,
            description: description,
            content: contents.joinedAsLines(),
            labels: labels)
    }
}
