/*
 PackageRepository + Continuous Integration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import PackageModel
  import SwiftFormat

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  extension PackageRepository {

    internal func refreshContinuousIntegration(output: Command.Output) throws {
      try refreshGitHubWorkflows(output: output)
    }

    private func relevantJobs(output: Command.Output) throws -> [ContinuousIntegrationJob] {
      return try ContinuousIntegrationJob.allCases.filter { job in
        return try job.isRequired(by: self, output: output)
      }
    }

    private func refreshGitHubWorkflow(
      name: UserFacing<StrictString, InterfaceLocalization>,
      onConditions: [StrictString],
      jobFilter: (ContinuousIntegrationJob) -> Bool,
      output: Command.Output
    ) throws {
      let configuration = try self.configuration(output: output)
      let interfaceLocalization = configuration.developmentInterfaceLocalization()
      let resolvedName = name.resolved(for: interfaceLocalization)

      var workflow: [StrictString] = [
        "name: \(resolvedName)",
        "",
      ]
      workflow.append(contentsOf: onConditions)
      workflow.append(contentsOf: [
        "",
        "jobs:",
      ])

      for job in try relevantJobs(output: output)
      where jobFilter(job) {
        workflow.append(contentsOf: try job.gitHubWorkflowJob(for: self, output: output))
      }

      var workflowFile = try TextFile(
        possiblyAt: location.appendingPathComponent(".github/workflows/\(resolvedName).yaml")
      )
      workflowFile.body = String(workflow.joinedAsLines())
      try workflowFile.writeChanges(for: self, output: output)
    }

    private func refreshGitHubWorkflows(output: Command.Output) throws {
      for job in try relevantJobs(output: output) where job ≠ .deployment {
        try refreshGitHubWorkflow(
          name: job.name,
          onConditions: ["on: [push, pull_request]"],
          jobFilter: { $0 == job },
          output: output
        )
      }

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
            "      \u{2D} master",
          ],
          jobFilter: { $0 == .deployment },
          output: output
        )
      }

      // Clean up after deprecated strategies.
      try cleanWindowsTestsUp(output: output)
      try cleanWindowsSDKUp(output: output)
      try cleanCentOSUp(output: output)
    }

    private func cleanWindowsTestsUp(output: Command.Output) throws {
      try cleanWindowsTestsManifestAdjustmentsUp(output: output)
      try cleanWindowsMainUp(output: output)
    }

    private func cleanWindowsTestsManifestAdjustmentsUp(output: Command.Output) throws {
      let url = location.appendingPathComponent("Package.swift")
      var manifest = try TextFile(possiblyAt: url)

      let start = "// Windows Tests (Generated automatically by Workspace.)"
      let end = "// End Windows Tests"
      let startPattern = ConcatenatedPatterns(
        start,
        RepetitionPattern(ConditionalPattern<String>({ _ in return true }))
      )
      let range =
        manifest.contents.firstMatch(for: startPattern + end)?.range
        ?? manifest.contents[manifest.contents.endIndex...].bounds

      manifest.contents.replaceSubrange(range, with: "")
      try manifest.writeChanges(for: self, output: output)
    }

    private func cleanWindowsMainUp(
      output: Command.Output
    ) throws {
      let url = location.appendingPathComponent("Tests/WindowsTests/main.swift")
      delete(url, output: output)
    }

    private func cleanWindowsSDKUp(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/Windows/SDK.json")
      delete(url, output: output)
    }

    private func cleanCentOSUp(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/CentOS.yaml")
      delete(url, output: output)
    }
  }
#endif
