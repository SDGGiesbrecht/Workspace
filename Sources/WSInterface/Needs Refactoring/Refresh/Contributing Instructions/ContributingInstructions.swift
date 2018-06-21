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

    static func refreshContributingInstructions(output: Command.Output) throws {

        var contributing = File(possiblyAt: contributingInstructionsPath)
        contributing.body = String(try Repository.packageRepository.contributingInstructions())
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
}
