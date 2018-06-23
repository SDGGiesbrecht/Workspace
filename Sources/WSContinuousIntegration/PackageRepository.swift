/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports
import WSProject

extension PackageRepository {

    public func refreshContinuousIntegration(output: Command.Output) throws {

        if try configuration().provideWorkflowScripts == false {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Continuous integration requires workflow scripts to be present. (provideWorkflowScripts)"
                }
            }))
        }

        var travisConfiguration: [String] = [
            "language: generic",
            "matrix:",
            "  include:"
        ]

        for job in ContinuousIntegrationJob.cases where try job.isRequired(by: self)
            ∨ (job ∈ ContinuousIntegrationJob.simulatorJobs ∧ isWorkspaceProject()) { // Simulator is unavailable during normal test.

                travisConfiguration.append(contentsOf: try job.script(configuration: configuration()))
        }

        if try isWorkspaceProject() {
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

        var travisConfigurationFile = try TextFile(possiblyAt: location.appendingPathComponent(".travis.yml"))
        travisConfigurationFile.body = travisConfiguration.joinedAsLines()
        try travisConfigurationFile.writeChanges(for: self, output: output)
    }
}
