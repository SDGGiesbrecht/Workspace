/*
 MockProject.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGExternalProcess

  import SDGCommandLine

  import SDGSwift
  import SDGHTML
  import SDGWeb

  import WorkspaceLocalizations
  import WorkspaceConfiguration
  import WorkspaceProjectConfiguration
  @testable import WorkspaceImplementation

  import XCTest

  import SDGPersistenceTestUtilities

  import SDGCommandLineTestUtilities

  extension PackageRepository {

    private static let mockProjectsDirectory = repositoryRoot.appendingPathComponent(
      "Tests/Mock Projects"
    )
    static func beforeDirectory(for mockProject: String) -> URL {
      return mockProjectsDirectory.appendingPathComponent("Before").appendingPathComponent(
        mockProject
      )
    }
    private static func afterDirectory(for mockProject: String) -> URL {
      return mockProjectsDirectory.appendingPathComponent("After").appendingPathComponent(
        mockProject
      )
    }

    // MARK: - Initialization

    init(mock name: String) {
      let temporary: URL
      #if os(macOS)
        // Not using FileManager.default.temporaryDirectory because the dynamic URL causes Xcode’s derived data to grow limitlessly over many test iterations.
        temporary = URL(fileURLWithPath: "/tmp")
      #else
        temporary = FileManager.default.temporaryDirectory
      #endif
      self.init(at: temporary.appendingPathComponent(name))
    }

    func test<L>(
      commands: [[StrictString]],
      configuration: WorkspaceConfiguration = WorkspaceConfiguration(),
      sdg: Bool = false,
      localizations: L.Type,
      withDependency: Bool = false,
      withCustomTask: Bool = false,
      overwriteSpecificationInsteadOfFailing: Bool,
      file: StaticString = #filePath,
      line: UInt = #line
    ) where L: InputLocalization {

      do {
        try purgingAutoreleased {
          func dodgeLackOfThrowingCalls() throws {}
          try dodgeLackOfThrowingCalls()

          let developer = URL(fileURLWithPath: "/tmp/Developer")
          try? FileManager.default.removeItem(at: developer)
          defer { try? FileManager.default.removeItem(at: developer) }
          if withDependency ∨ withCustomTask {

            let dependency = developer.appendingPathComponent("Dependency")
            try FileManager.default.do(in: dependency) {
              var initialize = ["swift", "package", "init"]
              if withCustomTask {
                initialize += ["\u{2D}\u{2D}type", "executable"]
              }
              _ = try Shell.default.run(command: initialize).get()
              if withCustomTask {
                let manifest = dependency.appendingPathComponent("Package.swift")
                var manifestContents = try StrictString(from: manifest)
                manifestContents.replaceMatches(
                  for: "name: \u{22}Dependency\u{22},\n    dependencies: [",
                  with:
                    "name: \u{22}Dependency\u{22},\n    products: [\n        .executable(name: \u{22}Dependency\u{22}, targets: [\u{22}Dependency\u{22}])\n    ],\n    dependencies: ["
                )
                try manifestContents.save(to: manifest)
                try
                  "import Foundation\nprint(\u{22}Hello, world!\u{22})\nif ProcessInfo.processInfo.arguments.count > 1 {\n    exit(1)\n}"
                  .save(
                    to: dependency.appendingPathComponent(
                      "Sources/main.swift"
                    )
                  )
              }
              _ = try Shell.default.run(command: ["git", "init"]).get()
              _ = try Shell.default.run(command: ["git", "add", "."]).get()
              _ = try Shell.default.run(command: [
                "git", "commit", "\u{2D}m", "Initialized.",
              ]).get()
              _ = try Shell.default.run(command: ["git", "tag", "1.0.0"]).get()
            }
          }
          let beforeLocation = PackageRepository.beforeDirectory(
            for: location.lastPathComponent
          )

          // Simulators are not available to all CI jobs and must be tested separately.
          setenv("SIMULATOR_UNAVAILABLE_FOR_TESTING", "YES", 1 /* overwrite */)
          defer {
            unsetenv("SIMULATOR_UNAVAILABLE_FOR_TESTING")
          }
          _isDuringSpecificationTest = true

          try? FileManager.default.removeItem(at: location)
          try FileManager.default.copy(beforeLocation, to: location)
          defer { try? FileManager.default.removeItem(at: location) }

          try FileManager.default.do(in: location) {
            _ = try Shell.default.run(command: ["git", "init"]).get()
            let gitIgnore = location.appendingPathComponent(".gitignore")
            if (try? gitIgnore.checkResourceIsReachable()) ≠ true {
              _ = try? FileManager.default.copy(
                repositoryRoot.appendingPathComponent(".gitignore"),
                to: gitIgnore
              )
            }

            WorkspaceContext.current = try configurationContext()
            if sdg {
              configuration._applySDGOverrides()
              configuration._validateSDGStandards()
            }
            WorkspaceConfiguration.queue(mock: configuration)
            defer {
              // Dequeue even if unused.
              _ = try? self.configuration(output: Command.Output.mock)
            }
            resetConfigurationCache(debugReason: "new test")

            for command in commands {
              FileType.resetUnsupportedFileTypes()
              PackageRepository.resetLocalizationFallback()

              print(
                StrictString("$ workspace ")
                  + command.joined(separator: " ")
              )
              let specificationName: StrictString =
                "\(location.lastPathComponent) (\(command.joined(separator: " ")))"

              // Special handling of commands with platform differences
              func requireSuccess() {
                for localization in L.allCases {
                  LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                    do {
                      _ = try Workspace.command.execute(with: command).get()
                    } catch {
                      XCTFail("\(error)", file: file, line: line)
                    }
                  }
                }
              }
              func expectFailure() {
                for localization in L.allCases {
                  LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                    do {
                      var output = try Workspace.command.execute(with: command)
                        .get()
                      // Reset cache to resurface compiler warnings.
                      try? FileManager.default.removeItem(
                        at: location.appendingPathComponent(".build")
                      )
                      output = try Workspace.command.execute(with: command).get()
                      XCTFail(String(output), file: file, line: line)
                    } catch {
                      // Expected.
                    }
                  }
                }
              }

              // #workaround(Swift 5.7.2, Hardware compatibility.)
              #if compiler(<5.8)
                if Tuple2((location.lastPathComponent, command)) ∈ Set([
                  Tuple2(("BadStyle", ["proofread", "•xcode"])),
                  Tuple2(("CustomProofread", ["proofread"])),
                  Tuple2(("CustomProofread", ["proofread", "•xcode"])),
                  Tuple2(("CustomTasks", ["refresh"])),
                  Tuple2(("CustomTasks", ["validate"])),
                  Tuple2(("Default", ["validate", "test‐coverage"])),
                  Tuple2(("Default", ["validate", "•job", "macos"])),
                  Tuple2(("Deutsch", ["prüfen", "testabdeckung"]))
                ])
                {
                  requireSuccess()
                  continue
                }
                if Tuple2((location.lastPathComponent, command)) ∈ Set([
                  Tuple2(("AllTasks", ["validate"])),
                  Tuple2(("BadStyle", ["proofread"])),
                  Tuple2(("Default", ["validate"])),
                  Tuple2(("FailingTests", ["validate", "test‐coverage"])),
                ])
                {
                  expectFailure()
                  continue
                }
                if Tuple2((location.lastPathComponent, command)) ∈ Set([
                  Tuple2(("FailingCustomTasks", ["refresh"])),
                  Tuple2(("FailingCustomValidation", ["validate"])),
                ])
                {
                  // Switches to failing due to difference in package initialization.
                  continue
                }
              #endif

              #if os(Linux)
                if command == ["refresh", "scripts"]
                  ∨ command == ["auffrischen", "skripte"]
                  ∨ command == ["validate", "build"]
                  ∨ command == ["prüfen", "erstellung"]
                  ∨ command == ["test"]
                  ∨ command == ["testen"]
                {
                  // Differing task set on Linux.
                  if location.lastPathComponent
                    ∈ Set(["BrokenTests", "FailingTestCoverage", "FailingTests", "NurDeutsch"])
                  {
                    expectFailure()
                  } else {
                    requireSuccess()
                  }
                  continue
                }
                if command == ["validate", "build", "•job", "macos"] {
                  // Invalid on Linux
                  expectFailure()
                  continue
                }
                // Differing task sets on Linux.
                if (command == ["refresh"] ∧ location.lastPathComponent
                  ∈ Set(["AllTasks", "CustomTasks"]))
                  ∨ (command == ["validate"] ∧ location.lastPathComponent
                    ∈ Set(["AllDisabled", "CustomTasks", "SDGLibrary"]))
                  ∨ (command == ["validate", "test‐coverage"]
                    ∧ location.lastPathComponent
                    ∈ Set(["Default", "SDGLibrary", "SDGTool"]))
                  ∨ (command == ["prüfen", "testabdeckung"]
                    ∧ location.lastPathComponent ∈ Set(["Deutsch"]))
                  ∨ (command == ["validate", "•job", "macos"]
                    ∧ location.lastPathComponent ∈ Set(["Default"]))
                {
                  requireSuccess()
                  continue
                } else if (command == ["validate"] ∧ location.lastPathComponent
                  ∈ Set(["AllTasks", "Default", "FailingCustomValidation"]))
                  ∨ (command == ["validate", "test‐coverage"]
                    ∧ location.lastPathComponent ∈ Set(["FailingTestCoverage", "FailingTests"]))
                {
                  expectFailure()
                  continue
                }
              #endif

              // General commands
              func postprocess(_ output: inout String) {
                let any = RepetitionPattern(
                  ConditionalPattern<String.ScalarView>({ _ in true }),
                  consumption: .lazy
                )

                // Temporary directory varies.
                output.scalars.replaceMatches(for: "`..".scalars, with: "`".scalars)
                output.scalars.replaceMatches(for: "/..".scalars, with: "".scalars)
                output.scalars.replaceMatches(
                  for: "/private/tmp".scalars,
                  with: "[Temporary]".scalars
                )
                output.scalars.replaceMatches(
                  for: "/tmp".scalars,
                  with: "[Temporary]".scalars
                )

                // Find hotkey varies.
                output.scalars.replaceMatches(for: "⌘F".scalars, with: "[⌘F]".scalars)
                output.scalars.replaceMatches(
                  for: "Ctrl + F".scalars,
                  with: "[⌘F]".scalars
                )
                output.scalars.replaceMatches(
                  for: "Strg + F".scalars,
                  with: "[⌘F]".scalars
                )

                // Git paths vary.
                output.scalars.replaceMatches(
                  for: "$ git ".scalars + any + "\n\n".scalars,
                  with: "[$ git...]\n\n".scalars
                )

                // Swift order varies.
                let matches = output.scalars.matches(
                  for: NestingPattern(opening: "$ swift ".scalars, closing: "\n\n".scalars)
                )
                .map { (match) -> Range<String.ScalarOffset> in
                  var range = match.range
                  var remainder = output.scalars[range.upperBound...]
                  while remainder.hasPrefix("* Build Completed!".scalars.literal()),
                    let end = remainder.firstMatch(for: "\n\n".scalars.literal())?.range
                      .upperBound
                  {
                    range = range.lowerBound..<end
                    remainder = output.scalars[range.upperBound...]
                  }
                  return output.offsets(of: range)
                }
                for match in matches.reversed() {
                  let range = output.indices(of: match)
                  output.scalars.replaceSubrange(range, with: "[$ swift...]\n\n".scalars)
                }
                output.scalars.replaceMatches(
                  for: "$ swift ".scalars + any + "\n0".scalars,
                  with: "[$ swift...]\n0".scalars
                )

                // Xcode order varies.
                output.scalars.replaceMatches(
                  for: NestingPattern(opening: "$ xcodebuild".scalars, closing: "\n\n".scalars),
                  with: "[$ xcodebuild...]\n\n".scalars
                )
                output.scalars.replaceMatches(
                  for: NestingPattern(opening: "[0/1] Planning build".scalars, closing: "\n\n".scalars),
                  with: "[...]\n\n".scalars
                )

                if command == ["validate"] ∨ command.hasPrefix(["validate", "•job"]) {
                  // Refreshment occurs elswhere in continuous integration.
                  output.scalars.replaceMatches(
                    for: "\n".scalars + any + "\nValidating “".scalars,
                    with: "\n[Refreshing ...]\n\nValidating “".scalars
                  )
                  output.scalars.replaceMatches(
                    for: "\n".scalars + any + "\nValidating ‘".scalars,
                    with: "\n[Refreshing ...]\n\nValidating ‘".scalars
                  )
                  output.scalars.replaceMatches(
                    for: "\n".scalars + any
                      + "\n„AllDisabled“ wird geprüft".scalars,
                    with:
                      "\n[... wird aufgefrisct ...]\n\n„AllDisabled“ wird geprüft"
                      .scalars
                  )
                  output.scalars.replaceMatches(
                    for: "\n".scalars + any
                      + "\n„CustomTasks“ wird geprüft".scalars,
                    with:
                      "\n[... wird aufgefrisct ...]\n\n„CustomTasks“ wird geprüft"
                      .scalars
                  )
                  output.scalars.replaceMatches(
                    for: "\n".scalars + any
                      + "\n„FailingCustomValidation“ wird geprüft".scalars,
                    with:
                      "\n[... wird aufgefrisct ...]\n\n„FailingCustomValidation“ wird geprüft"
                      .scalars
                  )
                }

                // DocC paths are unpredictable
                output.scalars.replaceMatches(
                  for: NestingPattern(opening: "$ docc".scalars, closing: "\n\n".scalars),
                  with: "[$ docc...]\n\n".scalars
                )
                #warning("Debugging...")
                print(output)
              }

              testCommand(
                Workspace.command,
                with: command,
                localizations: localizations,
                uniqueTestName: specificationName,
                postprocess: postprocess,
                overwriteSpecificationInsteadOfFailing:
                  overwriteSpecificationInsteadOfFailing,
                file: file,
                line: line
              )
            }

            /// Commit hashes vary.
            try? FileManager.default.removeItem(
              at: location.appendingPathComponent("Package.resolved")
            )
            /// Manifest updates only on macOS.
            try? FileManager.default.removeItem(
              at: location.appendingPathComponent("Tests/LinuxMain.swift")
            )
            for manifest in ((try? FileManager.default.deepFileEnumeration(in: location)) ?? [])
            where manifest.lastPathComponent == "XCTestManifests.swift" {
              try? FileManager.default.removeItem(at: manifest)
            }
            for file in ((try? FileManager.default.deepFileEnumeration(in: location)) ?? []) {
              if var text = try? String(from: file) {
                text.scalars.replaceMatches(
                  for: Metadata.latestStableVersion.string().scalars,
                  with: "[Current Version]".scalars
                )
                text.scalars.replaceMatches(
                  for: CalendarDate.gregorianNow().gregorianYear.inEnglishDigits().literal(),
                  with: "[Current Date]".scalars
                )
                try text.save(to: file)
              }
            }
            /// DocC output varies.
            try? FileManager.default.removeItem(at: location.appendingPathComponent("docs"))

            let afterLocation = PackageRepository.afterDirectory(
              for: location.lastPathComponent
            )
            if overwriteSpecificationInsteadOfFailing
              ∨ (try? afterLocation.checkResourceIsReachable()) ≠ true
            {
              try? FileManager.default.removeItem(at: afterLocation)
              try FileManager.default.move(location, to: afterLocation)
            } else {

              var files: Set<String> = []
              for file in try PackageRepository(at: location).trackedFiles(
                output: Command.Output.mock
              ) {
                files.insert(file.path(relativeTo: location))
              }
              for file in try PackageRepository(at: afterLocation).trackedFiles(
                output: Command.Output.mock
              ) {
                files.insert(file.path(relativeTo: afterLocation))
              }

              #if compiler(<5.8)
                if location.lastPathComponent == "CheckedInDocumentation" {
                  // Generated documention differs due to toolchain.
                  return
                }
              #endif

              for fileName in files {
                let result = location.appendingPathComponent(fileName)
                let after = afterLocation.appendingPathComponent(fileName)
                if let resultContents = try? String(from: result) {
                  if (try? String(from: after)) ≠ nil {
                    compare(
                      resultContents,
                      against: after,
                      overwriteSpecificationInsteadOfFailing: false,
                      file: file,
                      line: line
                    )
                  } else {
                    XCTFail("Unexpected file produced: “\(fileName)”")
                  }
                } else {
                  if (try? String(from: after)) ≠ nil {
                    XCTFail(
                      "Failed to produce “\(fileName)”.",
                      file: file,
                      line: line
                    )
                  }
                }
              }
            }
          }
        }
      } catch {
        XCTFail("\(error)", file: file, line: line)
      }
    }
  }
#endif
