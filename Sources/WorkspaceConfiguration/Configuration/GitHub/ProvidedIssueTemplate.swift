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
        #warning("Update this.")
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
        return IssueTemplate(
            name: "Issue",
            description: "Report an issue.",
            content: template,
            labels: [])
    }
}
