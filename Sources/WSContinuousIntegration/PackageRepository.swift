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
      try refreshCMake(output: output)
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

    private func refreshCMake(output: Command.Output) throws {
      let url = location.appendingPathComponent(".github/workflows/Windows/CMakeLists.txt")
      let mainURL = location.appendingPathComponent(".github/workflows/Windows/WindowsMain.swift")
      if try ¬relevantJobs(output: output).contains(.windows) {
        delete(url, output: output)
        delete(mainURL, output: output)
      } else {
        // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
        #if !(os(Windows) || os(WASI) || os(Android))
          let package = try self.cachedWindowsPackage()
          let graph = try self.cachedWindowsPackageGraph()

          func quote(_ string: String) -> StrictString {
            return "\u{22}\(string)\u{22}"
          }
          func sanitize(_ string: String) -> StrictString {
            return quote(
              String(
                string.map({ $0.isASCII ∧ $0.isLetter ? $0 : "_" })
              )
            )
          }

          var cmake: [StrictString] = [
            "cmake_minimum_required(VERSION 3.15)",
            "",
            "project(\(sanitize(package.name)) LANGUAGES Swift C)",
            "",
            "include(CTest)",
            "",
            "set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)",
            "set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)",
            "set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)",
            "set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)",
            "",
            "option(BUILD_SHARED_LIBS \u{22}Use dynamic linking\u{22} YES)",
          ]

          var testTargets: [ResolvedTarget] = []
          for packageTarget in graph.sortedReachableTargets() {
            let target = packageTarget.target
            var pathPrefix: String = "../../../"
            if ¬graph.rootPackages.contains(where: { $0.name == packageTarget.package.name }) {
              pathPrefix += ".build/SDG/Dependencies/\(packageTarget.package.name)/"
            }

            if case .test = target.type {
              testTargets.append(target)
            }
            cmake.append("")
            switch target.type {
            case .library, .test:
              if target.underlyingTarget is ClangTarget {
                cmake.append("add_library(\(sanitize(target.name)) SHARED")
              } else {
                cmake.append("add_library(\(sanitize(target.name))")
              }
            case .executable:
              cmake.append("add_executable(" + sanitize(target.name))
            case .systemModule:  // @exempt(from: tests)
              break
            }
            for source in target.sources.paths {
              let absoluteURL = source.asURL
              let relativeURL = absoluteURL.path(relativeTo: packageTarget.package.path.asURL)
              cmake.append("  " + quote(pathPrefix + relativeURL))
            }
            switch target.type {
            case .library, .executable, .test:
              cmake.append(")")
            case .systemModule:  // @exempt(from: tests)
              break
            }
            switch target.type {
            case .library, .test:
              if target.underlyingTarget is SwiftTarget {
                cmake.append(contentsOf: [
                  "set_target_properties(\(sanitize(target.name)) PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})",
                  "target_compile_options(\(sanitize(target.name)) PRIVATE \u{2D}enable\u{2D}testing)",
                ])
              } else if let c = target.underlyingTarget as? ClangTarget {
                let include = c.includeDir.asURL.path(relativeTo: packageTarget.package.path.asURL)
                cmake.append(
                  "target_include_directories(\(sanitize(target.name)) PUBLIC \u{22}${CMAKE_CURRENT_SOURCE_DIR}/../../../\(include)\u{22})"
                )
              }
            case .executable, .systemModule:
              break
            }
            switch target.type {
            case .library, .executable, .test:
              let dependencies = target.dependencyTargets
              if ¬dependencies.isEmpty {
                cmake.append("target_link_libraries(\(sanitize(target.name)) PRIVATE")
                for dependency in dependencies {
                  cmake.append("  " + sanitize(dependency.name))
                }
                cmake.append(")")
              }
            case .systemModule:  // @exempt(from: tests)
              break
            }
          }

          cmake.append(contentsOf: [
            "",
            "add_executable(WindowsMain",
            "  WindowsMain.swift",
            ")",
          ])
          if ¬testTargets.isEmpty {
            cmake.append("target_link_libraries(WindowsMain PRIVATE")
            for testTarget in testTargets {
              cmake.append("  " + sanitize(testTarget.name))
            }
            cmake.append(")")
          }
          cmake.append(contentsOf: [
            "add_test(NAME WindowsMain COMMAND WindowsMain)",
            "set_property(TEST WindowsMain PROPERTY ENVIRONMENT \u{22}LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}\u{22})",
          ])

          var cmakeFile = try TextFile(possiblyAt: url)
          cmakeFile.body = String(cmake.joinedAsLines())
          try cmakeFile.writeChanges(for: self, output: output)

          try refreshWindowsMain(testTargets: testTargets, url: mainURL, output: output)
        #endif
      }
    }

    // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
    #if !(os(Windows) || os(WASI) || os(Android))
      private func refreshWindowsMain(
        testTargets: [ResolvedTarget],
        url: URL,
        output: Command.Output
      ) throws {
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

        if try isWorkspaceProject() {
          main.append(contentsOf: [
            "#if os(macOS)",
            "  import Foundation",
            "",
            "  typealias XCTestCaseClosure = (XCTestCase) throws \u{2D}> Void",
            "  typealias XCTestCaseEntry = (",
            "    testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)]",
            "  )",
            "",
            "  func test<T: XCTestCase>(",
            "    _ testFunc: @escaping (T) \u{2D}> () throws \u{2D}> Void",
            "  ) \u{2D}> XCTestCaseClosure {",
            "    return { try testFunc($0 as! T)() }",
            "  }",
            "",
            "  func testCase<T: XCTestCase>(",
            "    _ allTests: [(String, (T) \u{2D}> () throws \u{2D}> Void)]",
            "  ) \u{2D}> XCTestCaseEntry {",
            "    let tests: [(String, XCTestCaseClosure)] = allTests.map { ($0.0, test($0.1)) }",
            "    return (T.self, tests)",
            "  }",
            "",
            "  func XCTMain(_ testCases: [XCTestCaseEntry]) \u{2D}> Never {",
            "    for testGroup in testCases {",
            "      let testClass = testGroup.testCaseClass.init()",
            "      print(type(of: testClass))",
            "      for test in testGroup.allTests {",
            "        print(test.0)",
            "        do {",
            "          try test.1(testClass)",
            "        } catch {",
            "          print(error.localizedDescription)",
            "        }",
            "      }",
            "    }",
            "    exit(EXIT_SUCCESS)",
            "  }",
            "#endif",
            "",
          ])
        }

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
    #endif

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
