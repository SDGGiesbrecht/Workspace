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
        issue.contents = String(try Repository.packageRepository.issueTemplate())
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
