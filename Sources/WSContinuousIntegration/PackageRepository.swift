/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    if try configuration(output: output).provideWorkflowScripts == false {
      throw Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              "Continuous integration requires workflow scripts to be present. (provideWorkflowScripts)"
          case .deutschDeutschland:
            return
              "Fortlaufende Einbindung benötigt, dass Arbeitsablaufsskripte vorhanden sind. (arbeitsablaufsskripteBereitstellen)"
          }
        })
      )
    }

    try refreshGitHubWorkflow(output: output)
    try refreshTravisCI(output: output)
  }

  private func relevantJobs(output: Command.Output) throws -> [ContinuousIntegrationJob] {
    return try ContinuousIntegrationJob.allCases.filter { job in
      return try job.isRequired(by: self, output: output)
      // Simulator is unavailable during normal test.
        ∨ (job ∈ ContinuousIntegrationJob.simulatorJobs ∧ isWorkspaceProject())
    }
  }

  internal static var macOSCachePath: String {
    return "Library/Caches/ca.solideogloria.Workspace"
  }
  internal static var linuxCachePath: String {
    return ".cache/ca.solideogloria.Workspace"
  }

  private func refreshGitHubWorkflow(output: Command.Output) throws {
    let configuration = try self.configuration(output: output)
    let interfaceLocalization = configuration.developmentInterfaceLocalization()
    let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Workspace Validation"
      case .deutschDeutschland:
        return "Arbeitsbereichprüfung"
      }
    }).resolved(for: interfaceLocalization)

    var workflow: [String] = [
      "name: \(name)",
      "",
      "on: [push, pull_request]",
      "",
      "jobs:"
    ]

    for job in try relevantJobs(output: output)
    // #workaround(Activating one at a time.)
    where job ∉ Set([.miscellaneous, .deployment]) {
      workflow.append(contentsOf: job.gitHubWorkflowJob(configuration: configuration))
    }

    try adjustForWorkspace(&workflow)
    var workflowFile = try TextFile(
      possiblyAt: location.appendingPathComponent(".github/workflows/\(name).yaml")
    )
    workflowFile.body = workflow.joinedAsLines()
    try workflowFile.writeChanges(for: self, output: output)
  }

  private func refreshTravisCI(output: Command.Output) throws {
    var travisConfiguration: [String] = [
      "language: generic",
      "matrix:",
      "  include:"
    ]

    for job in try relevantJobs(output: output) {
      travisConfiguration.append(
        contentsOf: try job.travisScript(configuration: configuration(output: output))
      )
    }

    travisConfiguration.append(contentsOf: [
      "",
      "cache:",
      "  directories:",
      "  \u{2D} $HOME/\(PackageRepository.macOSCachePath)",
      "  \u{2D} $HOME/\(PackageRepository.linuxCachePath)"
    ])

    try adjustForWorkspace(&travisConfiguration)
    var travisConfigurationFile = try TextFile(
      possiblyAt: location.appendingPathComponent(".travis.yml")
    )
    travisConfigurationFile.body = travisConfiguration.joinedAsLines()
    try travisConfigurationFile.writeChanges(for: self, output: output)
  }

  private func adjustForWorkspace(_ configuration: inout [String]) throws {
    if try isWorkspaceProject() {
      configuration = configuration.map { line in
        var line = line
        line.scalars.replaceMatches(
          for:
            "\u{27}./Validate (macOS).command\u{27} •job ios"
            .scalars,
          with: "swift run test‐ios‐simulator".scalars
        )
        line.scalars.replaceMatches(
          for:
            "\u{27}./Validate (macOS).command\u{27} •job tvos"
            .scalars,
          with: "swift run test‐tvos‐simulator".scalars
        )
        return line
      }
    }
  }
}
