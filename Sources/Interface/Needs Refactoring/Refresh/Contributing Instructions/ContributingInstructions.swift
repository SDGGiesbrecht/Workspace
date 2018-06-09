/*
 ContributingInstructions.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import GeneralImports

struct ContributingInstructions {

    static let deprecatedContributingInstructionsPath = RelativePath("CONTRIBUTING.md")
    static let contributingInstructionsPath = RelativePath(".github/CONTRIBUTING.md")
    static let issueTemplatePath = RelativePath(".github/ISSUE_TEMPLATE.md")
    static let pullRequestTemplatePath = RelativePath(".github/PULL_REQUEST_TEMPLATE.md")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .contributingInstructions)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static func defaultIssueTemplate() throws -> String {

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

        let products = try Repository.packageRepository.cachedPackage().products
        if products.contains(where: { $0.type.isLibrary }) {

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

        return template.joinAsLines()
    }

    static let defaultPullRequestTemplate: String = {

        var template = [
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
        ]

        return template.joinAsLines()
    }()

    static func refreshContributingInstructions(output: Command.Output) throws {

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        var body = [
            managementComment,
            "",
            String(try Repository.packageRepository.contributingInstructions())
            ].joinAsLines()

        body = body.replacingOccurrences(of: key("Project"), with: String(try Repository.packageRepository.projectName()))

        var contributing = File(possiblyAt: contributingInstructionsPath)
        contributing.body = body
        require { try contributing.write(output: output) }

        var issue = File(possiblyAt: issueTemplatePath)
        issue.contents = Configuration.issueTemplate
        require { try issue.write(output: output) }

        var pullRequest = File(possiblyAt: pullRequestTemplatePath)
        pullRequest.contents = Configuration.pullRequestTemplate
        require { try pullRequest.write(output: output) }

        // Remove deprecated.

        try? Repository.delete(deprecatedContributingInstructionsPath)
    }

    static func relinquishControl(output: Command.Output) {

        var printedHeader = false

        for path in [contributingInstructionsPath, issueTemplatePath, pullRequestTemplatePath] {
            autoreleasepool {

                var file = File(possiblyAt: path)
                if let range = file.contents.range(of: managementComment) {

                    if ¬printedHeader {
                        printedHeader = true
                        output.print("Cancelling contributing instruction management...".formattedAsSectionHeader())
                    }

                    file.contents.removeSubrange(range)
                    try? file.write(output: output)
                }
            }
        }
    }
}
