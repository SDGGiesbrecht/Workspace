/*
 ContinuousIntegration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import GeneralImports

enum ContinuousIntegration {

    static func refreshContinuousIntegration(for project: PackageRepository, output: Command.Output) throws {

        var travisConfiguration: [String] = [
            "language: generic",
            "matrix:",
            "  include:"
        ]

        for job in Job.cases where try job.isRequired(by: project, output: output)

            ∨ (job ∈ Tests.simulatorJobs ∧ project.isWorkspaceProject()) { // Simulator is unavailable during normal test.

            travisConfiguration.append(contentsOf: try job.script(configuration: project.configuration))
        }

        if try project.isWorkspaceProject() {
            travisConfiguration = travisConfiguration.map {
                var line = $0
                line.scalars.replaceMatches(for: "\u{22}bash \u{5C}\u{22}./Validate (macOS).command\u{5C}\u{22} •job ios\u{22}".scalars, with: "swift run test‐ios‐simulator".scalars)
                line.scalars.replaceMatches(for: "\u{22}bash \u{5C}\u{22}./Validate (macOS).command\u{5C}\u{22} •job tvos\u{22}".scalars, with: "swift run test‐tvos‐simulator".scalars)
                return line
            }
        }

        travisConfiguration.append(contentsOf: [
            "",
            "cache:",
            "  directories:",
            "  \u{2D} $HOME/Library/Caches/ca.solideogloria.Workspace",
            "  \u{2D} $HOME/.cache/ca.solideogloria.Workspace"
            ])

        var travisConfigurationFile = try TextFile(possiblyAt: project.location.appendingPathComponent(".travis.yml"))
        travisConfigurationFile.body = travisConfiguration.joinAsLines()
        try travisConfigurationFile.writeChanges(for: project, output: output)
    }

    static func commandEntry(_ command: String) -> String {
        var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
        escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
        return "        \u{2D} \u{22}\(escapedCommand)\u{22}"
    }
}
