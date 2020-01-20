/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    try refreshGitHubWorkflows(output: output)
    delete(location.appendingPathComponent(".travis.yml"), output: output)
  }

  private func relevantJobs(output: Command.Output) throws -> [ContinuousIntegrationJob] {
    return try ContinuousIntegrationJob.allCases.filter { job in
      return try job.isRequired(by: self, output: output)
      // Simulator is unavailable during normal test.
        ∨ (job ∈ ContinuousIntegrationJob.simulatorJobs ∧ isWorkspaceProject())
        // Enables testing of the provided continuous integration set‐up, even though Workspace cannot run on Windows.
        ∨ (job == .windows ∧ isWorkspaceProject())
    }
  }

  private func refreshGitHubWorkflow(
    name: UserFacing<StrictString, InterfaceLocalization>,
    onConditions: [String],
    jobFilter: (ContinuousIntegrationJob) -> Bool,
    output: Command.Output
  ) throws {
    let configuration = try self.configuration(output: output)
    let interfaceLocalization = configuration.developmentInterfaceLocalization()
    let resolvedName = name.resolved(for: interfaceLocalization)

    var workflow: [String] = [
      "name: \(resolvedName)",
      ""
    ]
    workflow.append(contentsOf: onConditions)
    workflow.append(contentsOf: [
      "",
      "jobs:"
    ])

    for job in try relevantJobs(output: output)
    where jobFilter(job) {
      workflow.append(contentsOf: try job.gitHubWorkflowJob(for: self, output: output))
    }

    try adjustForWorkspace(&workflow)
    var workflowFile = try TextFile(
      possiblyAt: location.appendingPathComponent(".github/workflows/\(resolvedName).yaml")
    )
    workflowFile.body = workflow.joinedAsLines()
    try workflowFile.writeChanges(for: self, output: output)
  }

  private func refreshGitHubWorkflows(output: Command.Output) throws {
    try refreshGitHubWorkflow(
      name: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Workspace Validation"
        case .deutschDeutschland:
          return "Arbeitsbereichprüfung"
        }
      }),
      onConditions: ["on: [push, pull_request]"],
      jobFilter: { $0 ≠ .deployment },
      output: output
    )

    if try relevantJobs(output: output).contains(.deployment) {
      try refreshGitHubWorkflow(
        name: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Documentation Deployment"
          case .deutschDeutschland:
            return "Dokumentationsverteilung"
          }
        }),
        onConditions: [
          "on:",
          "  push:",
          "    branches:",
          "      \u{2D} master"
        ],
        jobFilter: { $0 == .deployment },
        output: output
      )
    }
    try refreshCMake(output: output)
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

  private func refreshCMake(output: Command.Output) throws {
    let url = location.appendingPathComponent(".github/workflows/Windows/CMakeLists.txt")
    if try ¬relevantJobs(output: output).contains(.windows) {
      delete(url, output: output)
    } else {
      var cmake: [String] = [
      ]

      var cmakeFile = try TextFile(possiblyAt: url)
      cmakeFile.body = cmake.joinedAsLines()
      try cmakeFile.writeChanges(for: self, output: output)
    }
  }
}
