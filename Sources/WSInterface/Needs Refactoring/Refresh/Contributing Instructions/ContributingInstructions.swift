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
import WSGeneralImports

struct ContributingInstructions {

    static let deprecatedContributingInstructionsPath = RelativePath("CONTRIBUTING.md")
    static let contributingInstructionsPath = RelativePath(".github/CONTRIBUTING.md")
    static let issueTemplatePath = RelativePath(".github/ISSUE_TEMPLATE.md")
    static let pullRequestTemplatePath = RelativePath(".github/PULL_REQUEST_TEMPLATE.md")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .contributingInstructions)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static func refreshContributingInstructions(output: Command.Output) throws {

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        var body = [
            managementComment,
            "",
            String(try Repository.packageRepository.contributingInstructions())
            ].joinedAsLines()

        body = body.replacingOccurrences(of: key("Project"), with: String(try Repository.packageRepository.projectName()))

        var contributing = File(possiblyAt: contributingInstructionsPath)
        contributing.body = body
        require { try contributing.write(output: output) }

        var issue = File(possiblyAt: issueTemplatePath)
        issue.contents = String(try Repository.packageRepository.issueTemplate())
        require { try issue.write(output: output) }

        var pullRequest = File(possiblyAt: pullRequestTemplatePath)
        pullRequest.contents = String(try Repository.packageRepository.configuration().gitHub.pullRequestTemplate)
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
