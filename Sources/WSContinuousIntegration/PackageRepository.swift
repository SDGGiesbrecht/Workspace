/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
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
import WSSwift

// #workaround(SwiftPM 0.6.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import PackageModel
  import SwiftFormat
#endif

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  extension PackageRepository {

    public func refreshContinuousIntegration(output: Command.Output) throws {
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
      var workflowFile = try TextFile(
        possiblyAt: location.appendingPathComponent(".github/workflows/\(resolvedName).yaml")
      )
      workflowFile.body = String(workflow.joinedAsLines())
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
            "      \u{2D} master",
          ],
          jobFilter: { $0 == .deployment },
          output: output
        )
      }
      try cleanCMakeUp(output: output)
      try refreshWindowsTests(output: output)
      try refreshWindowsSDK(output: output)
      try refreshAndroidSDK(output: output)
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

    private func cleanCMakeUp(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/Windows/CMakeLists.txt")
      let mainURL = location.appendingPathComponent(".github/workflows/Windows/WindowsMain.swift")
      delete(url, output: output)
      delete(mainURL, output: output)
    }

    private func refreshWindowsTests(output: Command.Output) throws {
      // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
      #if !(os(Windows) || os(WASI) || os(Android))
        try refreshWindowsMain(output: output)
      #endif
    }

    // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
    #if !(os(Windows) || os(WASI) || os(Android))
      private func refreshWindowsMain(
        output: Command.Output
      ) throws {
        let url = location.appendingPathComponent("Tests/WindowsTests/main.swift")
        if try ¬relevantJobs(output: output).contains(.windows) {
          delete(url, output: output)
        } else {

          let graph = try self.cachedWindowsPackageGraph()
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

    private func refreshWindowsSDK(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/Windows/SDK.json")
      if try ¬relevantJobs(output: output).contains(.windows) {
        delete(url, output: output)
      } else {
        let sdk: [String] = [
          "{",
          "  \u{22}version\u{22}: 1,",
          "  \u{22}sdk\u{22}: \u{22}/mnt/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk\u{22},",
          "  \u{22}toolchain\u{2D}bin\u{2D}dir\u{22}: \u{22}/usr/bin\u{22},",
          "  \u{22}target\u{22}: \u{22}x86_64\u{2D}unknown\u{2D}windows\u{2D}msvc\u{22},",
          "  \u{22}dynamic\u{2D}library\u{2D}extension\u{22}: \u{22}dll\u{22},",
          "  \u{22}extra\u{2D}cc\u{2D}flags\u{22}: [],",
          "  \u{22}extra\u{2D}swiftc\u{2D}flags\u{22}: [],",
          "  \u{22}extra\u{2D}cpp\u{2D}flags\u{22}: []",
          "}",
        ]
        var sdkFile = try TextFile(possiblyAt: url)
        sdkFile.contents = sdk.joinedAsLines()
        try sdkFile.writeChanges(for: self, output: output)
      }
    }

    private func refreshAndroidSDK(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/Android/SDK.json")
      if try ¬relevantJobs(output: output).contains(.android) {
        delete(url, output: output)
      } else {
        let sdk: [String] = [
          "{",
          "  \u{22}version\u{22}: 1,",
          "  \u{22}sdk\u{22}: \u{22}/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk\u{22},",
          "  \u{22}toolchain\u{2D}bin\u{2D}dir\u{22}: \u{22}/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin\u{22},",
          "  \u{22}target\u{22}: \u{22}x86_64\u{2D}unknown\u{2D}linux\u{2D}android\u{22},",
          "  \u{22}dynamic\u{2D}library\u{2D}extension\u{22}: \u{22}so\u{22},",
          "  \u{22}extra\u{2D}cc\u{2D}flags\u{22}: [],",
          "  \u{22}extra\u{2D}swiftc\u{2D}flags\u{22}: [],",
          "  \u{22}extra\u{2D}cpp\u{2D}flags\u{22}: []",
          "}",
        ]
        var sdkFile = try TextFile(possiblyAt: url)
        sdkFile.contents = sdk.joinedAsLines()
        try sdkFile.writeChanges(for: self, output: output)
      }
    }
  }
#endif
