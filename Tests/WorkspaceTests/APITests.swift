/*
 APITests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGExternalProcess

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations
  import WorkspaceConfiguration
  import WorkspaceImplementation

  import XCTest

  import SDGPersistenceTestUtilities
  import SDGLocalizationTestUtilities
  import SDGXCTestUtilities

  import SDGCommandLineTestUtilities

  #if os(watchOS)
    // #workaround(SDGCornerstone 7.2.3, Real TestCase unavailable.)
    class TestCase: XCTestCase {}
  #endif
  class APITests: TestCase {

    static let configureGit: Void = {
        if isInGitHubAction {
          #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
              _ = try? Git.runCustomSubcommand(
                ["config", "\u{2D}\u{2D}global", "user.email", "john.doe@example.com"],
                versionConstraints: Version(0, 0, 0)..<Version(100, 0, 0)
              ).get()
              _ = try? Git.runCustomSubcommand(
                ["config", "\u{2D}\u{2D}global", "user.name", "John Doe"],
                versionConstraints: Version(0, 0, 0)..<Version(100, 0, 0)
              ).get()
          #endif
        }
    }()
    override func setUp() {
      super.setUp()
      Command.Output.testMode = true
      PackageRepository.resetRelatedProjectCache()  // Make sure starting state is consistent.
      CustomTask.emptyCache()
      APITests.configureGit
    }

    func testAllDisabled() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
          configuration.proofreading.swiftFormatConfiguration = nil
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "AllDisabled").test(
            commands: [
              ["refresh"],
              ["validate"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testAllTasks() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.optIntoAllTasks()
        configuration.documentation.localizations = ["🇮🇱עב"]
        configuration.licence.licence = .copyright
        configuration.documentation.api.yearFirstPublished = 2018
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
          resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇮🇱עב"] = "#dates"
            return result
          })
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "AllTasks").test(
            commands: [
              ["refresh"],
              ["validate"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testBadStyle() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.normalize = true
        configuration.proofreading.rules.insert(.listSeparation)
          configuration.proofreading.swiftFormatConfiguration?.rules["AlwaysUseLowerCamelCase"] =
            true
        let failing = CustomTask(
          url: URL(string: "file:///tmp/Developer/Dependency")!,
          version: Version(1, 0, 0),
          executable: "Dependency",
          arguments: ["fail"]
        )
        configuration.customProofreadingTasks.append(failing)
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "BadStyle").test(
            commands: [
              ["proofread"],
              ["proofread", "•xcode"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            withCustomTask: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testBrokenExample() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        PackageRepository(mock: "BrokenExample").test(
          commands: [
            ["refresh", "examples"]
          ],
          localizations: InterfaceLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testBrokenTests() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "BrokenTests").test(
            commands: [
              ["test"]
            ],
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testCheckedInDocumentation() throws {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        var output = try mockCommand.withRootBehaviour().execute(with: [
          "export‐interface", "•language", "en",
        ]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(
          for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
          with: "\n\n".scalars
        )
          try output.save(
            to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
              .appendingPathComponent("Resources/Tool/English.txt")
          )
        output = try mockCommand.withRootBehaviour().execute(with: [
          "export‐interface", "•language", "de",
        ]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(
          for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
          with: "\n\n".scalars
        )
          try output.save(
            to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
              .appendingPathComponent("Resources/Tool/Deutsch.txt")
          )

        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.normalize = true
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.api.enforceCoverage = false
        configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE", "zxx"]
        configuration.documentation.api.generate = true
        configuration.documentation.about["🇨🇦EN"] =
          "Stuff about the creators...\n\n...and more stuff..."
        configuration.documentation.about["🇺🇸EN"] = ""
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.documentation.api.ignoredDependencies.remove("Swift")
        configuration.documentation.api.applyWindowsCompatibilityFileNameReplacements()
          configuration.proofreading.swiftFormatConfiguration?.rules["UseShorthandTypeNames"] =
            false
          configuration.proofreading.swiftFormatConfiguration?.rules["UseEnumForNamespacing"] =
            false
        configuration.documentation.relatedProjects = [
          .heading(text: [
            "🇬🇧EN": "Heading",
            "🇺🇸EN": "Heading",
            "🇨🇦EN": "Heading",
            "🇩🇪DE": "Überschrift",
            "zxx": "...",
          ]),
          .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!),
        ]
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
          resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["zxx"] = "#dates"
            return result
          })
        configuration.provideWorkflowScripts = false
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "CheckedInDocumentation").test(
            commands: [
              ["refresh"],
              ["validate", "•job", "miscellaneous"],
              ["validate", "•job", "deployment"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testCheckForUpdates() throws {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        _ = try Workspace.command.execute(with: ["check‐for‐updates"]).get()
      #endif
    }

    func testContinuousIntegrationWithoutScripts() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.provideWorkflowScripts = false
        configuration.normalize = true
        configuration.continuousIntegration.manage = true
        configuration.licence.manage = true
        configuration.licence.licence = .mit
        configuration.fileHeaders.manage = true

        // Text rules but no syntax rules.
        configuration.proofreading.rules = [.manualWarnings]

        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "ContinuousIntegrationWithoutScripts").test(
            commands: [
              ["refresh", "continuous‐integration"],
              ["refresh", "licence"],
              ["refresh", "file‐headers"],
              ["proofread"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testCustomProofread() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.normalize = true
        configuration.proofreading.rules.remove(.calloutCasing)
        configuration.proofreading.unicodeRuleScope.remove(.ambiguous)
        for rule in ProofreadingRule.allCases {
          _ = rule.category
        }
        configuration.licence.manage = true
        configuration.licence.licence = .gnuGeneralPublic3_0
        configuration.fileHeaders.manage = true
        let passing = CustomTask(
          url: URL(string: "file:///tmp/Developer/Dependency")!,
          version: Version(1, 0, 0),
          executable: "Dependency",
          arguments: []
        )
        configuration.customProofreadingTasks.append(passing)
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "CustomProofread").test(
            commands: [
              ["proofread"],
              ["proofread", "•xcode"],
              ["refresh", "licence"],
              ["refresh", "file‐headers"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            withCustomTask: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testCustomReadMe() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.currentVersion = Version(1, 2, 3)
        configuration.documentation.repositoryURL = URL(
          string: "https://github.com/User/Repository"
        )!
        configuration.documentation.localizations = ["en"]
        configuration.documentation.installationInstructions = Lazy(resolve: { configuration in
          return [
            "en": StrictString(
              [
                "## Installation",
                "",
                "Build from source at tag `\(configuration.documentation.currentVersion!.string())` of `\(configuration.documentation.repositoryURL!.absoluteString)`.",
              ].joinedAsLines()
            )
          ]
        })
        configuration.licence.manage = true
        configuration.licence.licence = .unlicense
        configuration.fileHeaders.manage = true
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "CustomReadMe").test(
            commands: [
              ["refresh", "read‐me"],
              ["refresh", "licence"],
              ["refresh", "file‐headers"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testCustomTasks() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let passing = CustomTask(
          url: URL(string: "file:///tmp/Developer/Dependency")!,
          version: Version(1, 0, 0),
          executable: "Dependency",
          arguments: []
        )
        configuration.customRefreshmentTasks.append(passing)
        configuration.customValidationTasks.append(passing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
          configuration.proofreading.swiftFormatKonfiguration = nil
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "CustomTasks").test(
            commands: [
              ["refresh"],
              ["validate"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            withCustomTask: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testDefaults() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        let commands: [[StrictString]] = [
          ["refresh", "scripts"],
          ["refresh", "resources"],
          ["refresh", "examples"],
          ["refresh", "inherited‐documentation"],
          ["normalize"],

          ["proofread"],
          ["validate", "build"],
          ["test"],
          ["validate", "test‐coverage"],
          ["validate", "documentation‐coverage"],

          ["proofread", "•xcode"],
          ["validate", "build", "•job", "macos"],

          ["refresh"],
          ["validate"],
          ["validate", "•job", "macos"],

          ["proofread", "generate‐xcode‐project"],
        ]
        PackageRepository(mock: "Default").test(
          commands: commands,
          localizations: FastTestLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testDeutsch() throws {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        var output = try mockCommand.withRootBehaviour().execute(with: [
          "export‐interface", "•language", "de",
        ]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(
          for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
          with: "\n\n".scalars
        )
          try output.save(
            to: PackageRepository.beforeDirectory(for: "Deutsch")
              .appendingPathComponent("Resources/werkzeug/Deutsch.txt")
          )

        let konfiguration = ArbeitsbereichKonfiguration()
        konfiguration.optimizeForTests()
        konfiguration.dokumentation.lokalisationen = ["de"]
        konfiguration.dokumentation.programmierschnittstelle.erstellen = true
        konfiguration.dokumentation.programmierschnittstelle
          .durchGitHubSeitenVeröffentlichen = true
        konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2000
        konfiguration.dokumentation.programmierschnittstelle
          .dateinamensersetzungenZurWindowsVerträglichkeitHinzufügen()
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "Deutsch").test(
            commands: [
              ["auffrischen", "skripte"],
              ["auffrischen", "git"],
              ["auffrischen", "fortlaufende‐einbindung"],
              ["auffrischen", "ressourcen"],
              ["normalisieren"],
              ["prüfen", "erstellung"],
              ["prüfen", "testabdeckung"],
              ["prüfen", "dokumentationsabdeckung"],
              ["dokumentieren"],

              ["korrekturlesen", "xcode‐projekt‐erstellen"],
            ],
            configuration: konfiguration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testExecutable() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.documentation.localizations = ["en"]
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "Executable").test(
            commands: [
              ["refresh", "licence"],
              ["refresh", "read‐me"],
              ["document"],
              ["validate", "documentation‐coverage"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testFailingCustomTasks() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        let failing = CustomTask(
          url: URL(string: "file:///tmp/Developer/Dependency")!,
          version: Version(1, 0, 0),
          executable: "Dependency",
          arguments: ["fail"]
        )
        configuration.customRefreshmentTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "FailingCustomTasks").test(
            commands: [
              ["refresh"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            withCustomTask: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testFailingCustomValidation() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let failing = CustomTask(
          url: URL(string: "file:///tmp/Developer/Dependency")!,
          version: Version(1, 0, 0),
          executable: "Dependency",
          arguments: ["fail"]
        )
        configuration.customValidationTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
          configuration.proofreading.swiftFormatConfiguration = nil
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "FailingCustomValidation").test(
            commands: [
              ["validate"]
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            withCustomTask: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testFailingDocumentationCoverage() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.localizations = ["zxx"]
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        configuration.documentation.api.applyWindowsCompatibilityFileNameReplacements()
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "FailingDocumentationCoverage").test(
            commands: [
              ["validate", "documentation‐coverage"],
              ["document"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testFailingTests() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.testing.exemptPaths.insert("Sources/FailingTests/Exempt")
        // Attempt to remove existing derived data so that the build is clean.
        // Otherwise Xcode skips the build stages where the awaited warnings occur.
          do {
            for url in try FileManager.default.contentsOfDirectory(
              at: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(
                "Library/Developer/Xcode/DerivedData"
              ),
              includingPropertiesForKeys: nil,
              options: []
            ) {
              if url.lastPathComponent.contains("FailingTests") {
                try? FileManager.default.removeItem(at: url)
              }
            }
          } catch {}
        // This test may fail if derived data is not in the default location. See above.
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "FailingTests").test(
            commands: [
              ["validate", "build"],
              ["validate", "test‐coverage"],
              ["validate", "build", "•job", "miscellaneous"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testHeaders() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["🇨🇦EN"]
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "Headers").test(
            commands: [
              ["refresh", "file‐headers"],
              ["refresh", "examples"],
              ["refresh", "inherited‐documentation"],
              ["test"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testHelp() throws {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        testCommand(
          Workspace.command,
          with: ["help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["proofread", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace proofread)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["validate", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace validate)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["document", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace document)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "continuous‐integration", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh continuous‐integration)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "examples", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh examples)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "inherited‐documentation", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh inherited‐documentation)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "resources", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh resources)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["refresh", "scripts", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh scripts)",
          overwriteSpecificationInsteadOfFailing: false
        )
        testCommand(
          Workspace.command,
          with: ["normalize", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace normalize)",
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testInvalidResourceDirectory() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        PackageRepository(mock: "InvalidResourceDirectory").test(
          commands: [
            ["refresh", "resources"]
          ],
          localizations: InterfaceLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testInvalidTarget() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        PackageRepository(mock: "InvalidTarget").test(
          commands: [
            ["refresh", "resources"]
          ],
          localizations: InterfaceLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testMissingDocumentation() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        PackageRepository(mock: "MissingDocumentation").test(
          commands: [
            ["refresh", "inherited‐documentation"]
          ],
          localizations: InterfaceLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testMissingExample() {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        PackageRepository(mock: "MissingExample").test(
          commands: [
            ["refresh", "examples"]
          ],
          localizations: InterfaceLocalization.self,
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
    }

    func testMissingReadMeLocalization() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["zxx"]
        configuration.documentation.readMe.contents.resolve = { _ in [:] }
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "MissingReadMeLocalization").test(
            commands: [
              ["refresh", "read‐me"]
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testMultipleProducts() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "MultipleProducts").test(
            commands: [
              ["refresh", "read‐me"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testNoLibraries() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "NoLibraries").test(
            commands: [
              ["refresh", "read‐me"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testNoLocalizations() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "NoLocalizations").test(
            commands: [
              ["refresh", "read‐me"],
              ["validate", "documentation‐coverage"],
            ],
            configuration: configuration,
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testNurDeutsch() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.gitHub.manage = true
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "NurDeutsch").test(
            commands: [
              ["auffrischen", "github"],
              ["normalisieren"],
              ["korrekturlesen"],
              ["prüfen", "erstellung"],
              ["testen"],
            ],
            configuration: configuration,
            localizations: NurDeutsch.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testOneLocalization() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "OneLocalization").test(
            commands: [
              ["refresh", "github"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testOneProductMultipleModules() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        configuration.supportedPlatforms.remove(.windows)
        configuration.supportedPlatforms.remove(.android)
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "OneProductMultipleModules").test(
            commands: [
              ["refresh", "read‐me"],
              ["refresh", "continuous‐integration"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testOnlyBritish() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.gitHub.manage = true
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "OnlyBritish").test(
            commands: [
              ["refresh", "github"],
              ["normalize"],
            ],
            configuration: configuration,
            localizations: OnlyBritish.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testPartialReadMe() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.currentVersion = Version(0, 1, 0)
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        configuration.documentation.localizations = [
          "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx",
        ]
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.gitHub.developmentNotes = "..."
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
          resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
          })
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "PartialReadMe").test(
            commands: [
              ["refresh", "read‐me"],
              ["refresh", "github"],
              ["document"],
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testSDGLibrary() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(
          string: "https://example.github.io/SDG/SDG"
        )!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.serveFromGitHubPagesBranch = true
        configuration.gitHub.administrators = ["John Doe", "Jane Doe"]
        configuration.documentation.localizations = [
          "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx",
        ]
        for localization in configuration.documentation.localizations {
          configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
          .heading(text: ["🇨🇦EN": "Heading"]),
          .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!),
        ]
        configuration.testing.exemptionTokens.insert(
          TestCoverageExemptionToken("customSameLineToken", scope: .sameLine)
        )
        configuration.testing.exemptionTokens.insert(
          TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine)
        )

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
          resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
          })
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "SDGLibrary").test(
            commands: [
              ["refresh", "scripts"],
              ["refresh", "git"],
              ["refresh", "read‐me"],
              ["refresh", "licence"],
              ["refresh", "github"],
              ["refresh", "continuous‐integration"],
              ["refresh", "resources"],
              ["refresh", "file‐headers"],
              ["refresh", "examples"],
              ["refresh", "inherited‐documentation"],
              ["normalize"],
              ["proofread"],
              ["validate", "build"],
              ["test"],
              ["validate", "test‐coverage"],
              ["validate", "documentation‐coverage"],

              ["proofread", "•xcode"],
              ["validate"],
            ],
            configuration: configuration,
            sdg: true,
            localizations: FastTestLocalization.self,
            withDependency: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testSDGTool() {
      #if !os(Windows)  // #workaround(Swift 5.3.3, SegFault)
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(
          string: "https://example.github.io/SDG/SDG"
        )!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.serveFromGitHubPagesBranch = true
        configuration.gitHub.administrators = ["John Doe"]
        configuration.documentation.localizations = [
          "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx",
        ]
        for localization in configuration.documentation.localizations {
          configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
          .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.exemptionTokens.insert(
          TestCoverageExemptionToken("customSameLineToken", scope: .sameLine)
        )
        configuration.testing.exemptionTokens.insert(
          TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine)
        )

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
          resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
          })
        #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
          PackageRepository(mock: "SDGTool").test(
            commands: [
              ["refresh", "scripts"],
              ["refresh", "git"],
              ["refresh", "read‐me"],
              ["refresh", "licence"],
              ["refresh", "github"],
              ["refresh", "continuous‐integration"],
              ["refresh", "resources"],
              ["refresh", "file‐headers"],
              ["refresh", "examples"],
              ["refresh", "inherited‐documentation"],
              ["normalize"],
              ["proofread"],
              ["validate", "build"],
              ["test"],
              ["validate", "test‐coverage"],
              ["validate", "documentation‐coverage"],

              ["proofread", "•xcode"],
            ],
            configuration: configuration,
            sdg: true,
            localizations: FastTestLocalization.self,
            withDependency: true,
            overwriteSpecificationInsteadOfFailing: false
          )
        #endif
      #endif
    }

    func testSelfSpecificScripts() throws {
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        try FileManager.default.do(in: repositoryRoot) {
          _ = try Workspace.command.execute(with: ["refresh", "scripts"]).get()
          _ = try Workspace.command.execute(with: ["refresh", "continuous‐integration"]).get()
        }
      #endif
    }
  }
#endif
