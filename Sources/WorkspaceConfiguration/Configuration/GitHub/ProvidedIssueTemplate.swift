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
        var contents: [StrictString] = []
        contents.append(contentsOf: [
            "<!--",
            " Reminder:",
            " Have you searched to see if a related issue exists already?",
            " If one exists, please add your information there instead.",
            " -->",
            "",
            "### Description",
            "",
            "“Such‐and‐such appears broken.”",
            "or",
            "“Such‐and‐such would be a nice feature.”",
            "",
            "### Demonstration",
            "<!-- (If the issue is not a bug, erase this section.) -->",
            "",
            "#trigger",
            "",
            "### Availability to Help",
            "",
            "<!-- Keep only one of the following lines. -->",
            "I **would like** the honour of helping with the implementation, and I think **I know my way around**.",
            "I **would like** the honour of helping with the implementation, but **I would need some guidance** along the way.",
            "I **do not want to help** with the implementation.",
            "",
            "### Solution/Design Thoughts",
            "",
            "It might work to do something like..."
            ])
        var template = contents.joinedAsLines()

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
        return IssueTemplate(
            name: "Issue",
            description: "Report an issue.",
            content: template,
            labels: [])
    }
}
