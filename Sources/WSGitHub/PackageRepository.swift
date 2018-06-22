/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

extension PackageRepository {

    // MARK: - Locations

    private var gitHubDirectory: URL {
        return location.appendingPathComponent(".github")
    }

    private var depricatedContributingInstructions: URL {
        return location.appendingPathComponent("CONTRIBUTING.md")
    }
    private var contributingInstructionsLocation: URL {
        return gitHubDirectory.appendingPathComponent("CONTRIBUTING.md")
    }

    private var issueTemplateLocation: URL {
        return gitHubDirectory.appendingPathComponent("ISSUE_TEMPLATE.md")
    }

    private var pullRequestTemplateLocation: URL {
        return gitHubDirectory.appendingPathComponent("PULL_REQUEST_TEMPLATE.md")
    }

    // MARK: - Refreshment

    public func refreshGitHubConfiguration(output: Command.Output) throws {

        var contributingInstructionsFile = try TextFile(possiblyAt: contributingInstructionsLocation)
        contributingInstructionsFile.body = String(try contributingInstructions())
        try contributingInstructionsFile.writeChanges(for: self, output: output)

        var issueTemplateFile = try TextFile(possiblyAt: issueTemplateLocation)
        issueTemplateFile.body = String(try issueTemplate())
        try issueTemplateFile.writeChanges(for: self, output: output)

        var pullRequestTemplateFile = try TextFile(possiblyAt: pullRequestTemplateLocation)
        pullRequestTemplateFile.body = String(try configuration().gitHub.pullRequestTemplate)
        try pullRequestTemplateFile.writeChanges(for: self, output: output)

        // Remove deprecated.
        delete(depricatedContributingInstructions, output: output)
    }
}
