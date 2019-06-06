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
    case documentationCorrection
    case question

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
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                name = "Documentation Correction"
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                name = "Question"
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
                description = "Request a new feature you would find helpful"
            }
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                description = "Report something incorrect or unclear in the documentation"
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                description = "Ask a question"
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

        switch self {
        case .bugReport, .featureRequest, .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Description")
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Question")
            }
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
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("There appears to be a mistake in the documentation about such‐and‐such.")
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("How can I do such‐and‐such?")
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

        switch self {
        case .bugReport, .featureRequest, .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                let task: StrictString
                switch self {
                case .bugReport, .documentationCorrection, .question:
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
                    ])
            }
        case .question:
            break
        }

        contents.append("")
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
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Recommended Correction")
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append("### Documentation Suggestion")
            }
        }
        switch self {
        case .bugReport, .featureRequest:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append(contentsOf: [
                    "",
                    "It might work to do something like..."
                    ])
            }
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append(contentsOf: [
                    "",
                    "“It makes more sense written like this.”"
                    ])
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                contents.append(contentsOf: [
                    "",
                    "I expected to find the answer under...",
                    "<!-- Answering this may help us organize the documentation more intuitively for others with the same question. -->",
                    ])
            }
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
        case .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                labels.append("Documentation")
            }
        case .question:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                labels.append("Question")
            }
        }
        switch self {
        case .bugReport, .featureRequest, .documentationCorrection:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                labels.append("Needs Investigation")
            }
        case .question:
            break
        }

        return IssueTemplate(
            name: name,
            description: description,
            content: contents.joinedAsLines(),
            labels: labels)
    }
}
