/*
 PackageRepository + Continuous Integration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
  import PackageModel
  import SwiftFormat
#endif

import WorkspaceLocalizations
import WorkspaceConfiguration

extension PackageRepository {

  internal func refreshContinuousIntegration(output: Command.Output) throws {
    try refreshGitHubWorkflows(output: output)
    delete(location.appendingPathComponent(".travis.yml"), output: output)
  }

  private func relevantJobs(output: Command.Output) throws -> [ContinuousIntegrationJob] {
    return try ContinuousIntegrationJob.allCases.filter { job in
      return try job.isRequired(by: self, output: output)
        // Simulator is unavailable during normal test.
        ∨ (job ∈ ContinuousIntegrationJob.simulatorJobs ∧ isWorkspaceProject())
        // Enables testing of the provided continuous integration set‐up, even though Workspace cannot run on these platforms.
        ∨ ((job ∈ Set([.windows, .web, .android])) ∧ isWorkspaceProject())
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

    try adjustForWorkspace(&workflow)
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      var workflowFile = try TextFile(
        possiblyAt: location.appendingPathComponent(".github/workflows/\(resolvedName).yaml")
      )
      workflowFile.body = String(workflow.joinedAsLines())
      try workflowFile.writeChanges(for: self, output: output)
    #endif
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
    try cleanUpDeprecatedWorkflows(output: output)

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
    try cleanCMakeUp(output: output)
    try refreshWindowsTests(output: output)
    try cleanWindowsSDKUp(output: output)
    try cleanAndroidSDKUp(output: output)
  }

  private func adjustForWorkspace(_ configuration: inout [StrictString]) throws {
    if try isWorkspaceProject() {
      configuration = configuration.map { line in
        var line = line
        line.scalars.replaceMatches(
          for:
            "swift run workspace validate •job ios •language \u{27}🇬🇧EN;🇺🇸EN;🇨🇦EN;🇩🇪DE\u{27}"
            .scalars,
          with: "swift run test‐ios‐simulator".scalars
        )
        line.scalars.replaceMatches(
          for:
            "swift run workspace validate •job tvos •language \u{27}🇬🇧EN;🇺🇸EN;🇨🇦EN;🇩🇪DE\u{27}"
            .scalars,
          with: "swift run test‐tvos‐simulator".scalars
        )
        return line
      }
    }
  }

  private func cleanUpDeprecatedWorkflows(output: Command.Output) throws {
    let deprecatedWorkflowName = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Workspace Validation"
      case .deutschDeutschland:
        return "Arbeitsbereichprüfung"
      }
    }).resolved(for: try configuration(output: output).developmentInterfaceLocalization())
    delete(
      location.appendingPathComponent(".github/workflows/\(deprecatedWorkflowName).yaml"),
      output: output
    )
  }

  private func cleanCMakeUp(output: Command.Output) throws {
    let url = location.appendingPathComponent(".github/workflows/Windows/CMakeLists.txt")
    let mainURL = location.appendingPathComponent(".github/workflows/Windows/WindowsMain.swift")
    delete(url, output: output)
    delete(mainURL, output: output)
  }

  private func refreshWindowsTests(output: Command.Output) throws {
    // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
    #if !(os(Windows) || os(WASI) || os(Android))
      try refreshWindowsTestsManifestAdjustments(output: output)
      try refreshWindowsMain(output: output)
    #endif
  }

  // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))
    private func refreshWindowsTestsManifestAdjustments(output: Command.Output) throws {
      let url = location.appendingPathComponent("Package.swift")
      var manifest = try TextFile(possiblyAt: url)

      let start = "// Windows Tests (Generated automatically by Workspace.)"
      let end = "// End Windows Tests"
      let startPattern = ConcatenatedPatterns(
        start,
        RepetitionPattern(ConditionalPattern<Character>({ _ in return true }))
      )
      let range =
        manifest.contents.firstMatch(for: startPattern + end)?.range
        ?? manifest.contents[manifest.contents.endIndex...].bounds

      if try ¬relevantJobs(output: output).contains(.windows) {
        manifest.contents.replaceSubrange(range, with: "")
      } else {
        manifest.contents.replaceSubrange(
          range,
          with: [
            start,
            "import Foundation",
            "if ProcessInfo.processInfo.environment[\u{22}\(ContinuousIntegrationJob.windows.environmentVariable)\u{22}] == \u{22}true\u{22} {",
            "  var tests: [Target] = []",
            "  var other: [Target] = []",
            "  for target in package.targets {",
            "    if target.type == .test {",
            "      tests.append(target)",
            "    } else {",
            "      other.append(target)",
            "    }",
            "  }",
            "  package.targets = other",
            "  package.targets.append(",
            "    contentsOf: tests.map({ test in",
            "      return .target(",
            "        name: test.name,",
            "        dependencies: test.dependencies,",
            "        path: test.path ?? \u{22}Tests/\u{5C}(test.name)\u{22},",
            "        exclude: test.exclude,",
            "        sources: test.sources,",
            "        publicHeadersPath: test.publicHeadersPath,",
            "        cSettings: test.cSettings,",
            "        cxxSettings: test.cxxSettings,",
            "        swiftSettings: test.swiftSettings,",
            "        linkerSettings: test.linkerSettings",
            "      )",
            "    })",
            "  )",
            "  package.targets.append(",
            "    .target(",
            "      name: \u{22}WindowsTests\u{22},",
            "      dependencies: tests.map({ Target.Dependency.target(name: $0.name) }),",
            "      path: \u{22}Tests/WindowsTests\u{22}",
            "    )",
            "  )",
            "}",
            end,
          ].joinedAsLines()
        )
      }
      try manifest.writeChanges(for: self, output: output)
    }

    private func refreshWindowsMain(
      output: Command.Output
    ) throws {
      let url = location.appendingPathComponent("Tests/WindowsTests/main.swift")
      if try ¬relevantJobs(output: output).contains(.windows) {
        delete(url, output: output)
      } else {

        let graph = try self.cachedPackageGraph()
        let testTargets = graph.testTargets()

        var main: [String] = [
          "import XCTest",
          "",
        ]
        var testClasses: [(name: String, methods: [String])] = []
        for testTarget in testTargets {
          main.append("@testable import \(testTarget.name)")
          testClasses.append(contentsOf: try testTarget.testClasses())
        }
        main.append("")

        for testClass in testClasses {
          main.append(contentsOf: [
            "extension \(testClass.name) {",
            "  static let windowsTests: [XCTestCaseEntry] = [",
            "    testCase([",
          ])
          for methodIndex in testClass.methods.indices {
            let method = testClass.methods[methodIndex]
            let comma = methodIndex == testClass.methods.indices.last ? "" : ","
            main.append("      (\u{22}\(method)\u{22}, \(method))\(comma)")
          }
          main.append(contentsOf: [
            "    ])",
            "  ]",
            "}",
            "",
          ])
        }

        main.append(contentsOf: [
          "var tests = [XCTestCaseEntry]()"
        ])
        for testClass in testClasses {
          main.append("tests += \(testClass.name).windowsTests")
        }

        main.append(contentsOf: [
          "",
          "XCTMain(tests)",
        ])

        var source = main.joinedAsLines()
        try SwiftLanguage.format(
          generatedCode: &source,
          accordingTo: try configuration(output: output),
          for: url
        )

        var windowsMain = try TextFile(possiblyAt: url)
        windowsMain.body = source
        try windowsMain.writeChanges(for: self, output: output)
      }
    }
  #endif

  private func cleanWindowsSDKUp(output: Command.Output) throws {
    let url = location.appendingPathComponent(".github/workflows/Windows/SDK.json")
    delete(url, output: output)
  }

  private func cleanAndroidSDKUp(output: Command.Output) throws {
    let url = location.appendingPathComponent(".github/workflows/Android/SDK.json")
    delete(url, output: output)
  }
}
