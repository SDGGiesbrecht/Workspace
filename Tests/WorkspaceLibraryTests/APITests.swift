/*
 APITests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralTestImports

import SDGExternalProcess

import WorkspaceConfiguration
import WSProject

class APITests : TestCase {

    static var triggeredVersionChecks: Void?
    override func setUp() {
        super.setUp()
        Command.Output.testMode = true
        PackageRepository.emptyRelatedProjectCache() // Make sure starting state is consistent.
        CustomTask.emptyCache()
    }

    func testAllDisabled() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "AllDisabled").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testAllTasks() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.optIntoAllTasks()
        configuration.documentation.localizations = ["🇮🇱עב"]
        configuration.licence.licence = .copyright
        configuration.documentation.api.yearFirstPublished = 2018
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇮🇱עב"] = "#dates"
            return result
        })
        PackageRepository(mock: "AllTasks").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testBadStyle() {
        let configuration = WorkspaceConfiguration()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customProofreadingTasks.append(failing)
        PackageRepository(mock: "BadStyle").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testBrokenExample() {
        PackageRepository(mock: "BrokenExample").test(commands: [
            ["refresh", "examples"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testBrokenTests() {
        PackageRepository(mock: "BrokenTests").test(commands: [
            ["test"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCheckedInDocumentation() throws {
        var output = try mockCommand.withRootBehaviour().execute(with: ["export‐interface", "•language", "en"]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(for: CompositePattern([
            LiteralPattern("\n".scalars),
            RepetitionPattern(" ".scalars),
            LiteralPattern("\n".scalars)
            ]), with: "\n\n".scalars)
        try output.save(
            to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
                .appendingPathComponent("Resources/Tool/English.txt"))

        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.repositoryURL = URL(string: "does://not.exist.git")!
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.api.enforceCoverage = false
        configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE", "zxx"]
        configuration.documentation.api.generate = true
        configuration.documentation.about["🇨🇦EN"] = "Stuff about the creators...\n\n...and more stuff..."
        configuration.documentation.about["🇺🇸EN"] = ""
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.documentation.api.ignoredDependencies.remove("Swift")
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["zxx"] = "#dates"
            return result
        })
        configuration.provideWorkflowScripts = false
        PackageRepository(mock: "CheckedInDocumentation").test(commands: [
            ["refresh"],
            ["validate", "•job", "miscellaneous"],
            ["validate", "•job", "deployment"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCheckForUpdates() throws {
        _ = try Workspace.command.execute(with: ["check‐for‐updates"]).get()
    }

    func testConfiguration() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults(openSource: false)
        XCTAssertFalse(configuration.documentation.readMe.manage)
    }

    func testContinuousIntegrationWithoutScripts() {
        let configuration = WorkspaceConfiguration()
        configuration.provideWorkflowScripts = false
        configuration.continuousIntegration.manage = true
        configuration.licence.manage = true
        configuration.licence.licence = .mit
        configuration.fileHeaders.manage = true
        PackageRepository(mock: "ContinuousIntegrationWithoutScripts").test(commands: [
            ["refresh", "continuous‐integration"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomProofread() {
        let configuration = WorkspaceConfiguration()
        configuration.proofreading.rules.remove(.colonSpacing)
        configuration.proofreading.unicodeRuleScope.remove(.ambiguous)
        for rule in ProofreadingRule.allCases {
            _ = rule.category
        }
        configuration.licence.manage = true
        configuration.licence.licence = .gnuGeneralPublic3_0
        configuration.fileHeaders.manage = true
        let passing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: [])
        configuration.customProofreadingTasks.append(passing)
        PackageRepository(mock: "CustomProofread").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.currentVersion = Version(1, 2, 3)
        configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Repository")!
        configuration.documentation.localizations = ["en"]
        configuration.documentation.installationInstructions = Lazy(resolve: { configuration in
            return [
                "en": StrictString([
                    "## Installation",
                    "",
                    "Build from source at tag `\(configuration.documentation.currentVersion!.string())` of `\(configuration.documentation.repositoryURL!.absoluteString)`."
                    ].joinedAsLines())
            ]
        })
        configuration.licence.manage = true
        configuration.licence.licence = .unlicense
        configuration.fileHeaders.manage = true
        PackageRepository(mock: "CustomReadMe").test(commands: [
            ["refresh", "read‐me"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomTasks() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let passing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: [])
        configuration.customRefreshmentTasks.append(passing)
        configuration.customValidationTasks.append(passing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        configuration.xcode.manage = true
        PackageRepository(mock: "CustomTasks").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testDefaults() {
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
            ["validate", "•job", "macos"]
        ]
        PackageRepository(mock: "Default").test(commands: commands, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testDeutsch() {
        let konfiguration = ArbeitsbereichKonfiguration()
        konfiguration.optimizeForTests()
        konfiguration.dokumentation.lokalisationen = ["de"]
        konfiguration.dokumentation.programmierschnittstelle.encryptedTravisCIDeploymentKey = "..."
        PackageRepository(mock: "Deutsch").test(commands: [
            ["auffrischen", "fortlaufende‐einbindung"],
            ], configuration: konfiguration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testExecutable() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.documentation.localizations = ["en"]
        PackageRepository(mock: "Executable").test(commands: [
            ["refresh", "licence"],
            ["refresh", "read‐me"],
            ["document"],
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingCustomTasks() {
        let configuration = WorkspaceConfiguration()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customRefreshmentTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "FailingCustomTasks").test(commands: [
            ["refresh"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingCustomValidation() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customValidationTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "FailingCustomValidation").test(commands: [
            ["validate"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingDocumentationCoverage() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.localizations = ["zxx"]
        configuration.xcode.manage = true
        configuration.documentation.repositoryURL = URL(string: "domain.tld")!
        PackageRepository(mock: "FailingDocumentationCoverage").test(commands: [
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingTests() {
        let configuration = WorkspaceConfiguration()
        configuration.xcode.manage = true
        configuration.testing.exemptPaths.insert("Sources/FailingTests/Exempt")
        // Attempt to remove existing derived data so that the build is clean.
        // Otherwise Xcode skips the build stages where the awaited warnings occur.
        do {
            for url in try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Developer/Xcode/DerivedData"), includingPropertiesForKeys: nil, options: []) {
                if url.lastPathComponent.contains("FailingTests") {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch {}
        // This test may fail if derived data is not in the default location. See above.
        PackageRepository(mock: "FailingTests").test(commands: [
            ["validate", "build"],
            ["validate", "test‐coverage"],
            ["validate", "build", "•job", "miscellaneous"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testHeaders() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["🇨🇦EN"]
        PackageRepository(mock: "Headers").test(commands: [
            ["refresh", "file‐headers"],
            ["refresh", "examples"],
            ["refresh", "inherited‐documentation"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testHelp() throws {
        testCommand(Workspace.command, with: ["help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["proofread", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace proofread)", overwriteSpecificationInsteadOfFailing: false)
        #if os(Linux) // Linux has no “xcode” subcommand, causing spec mis‐match.
        for localization in InterfaceLocalization.allCases {
            try LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                _ = try Workspace.command.execute(with: ["refresh", "help"])
            }
        }
        #else
        testCommand(Workspace.command, with: ["refresh", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh)", overwriteSpecificationInsteadOfFailing: false)
        #endif
        testCommand(Workspace.command, with: ["validate", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace validate)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["document", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace document)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "continuous‐integration", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh continuous‐integration)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "examples", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh examples)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "inherited‐documentation", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh inherited‐documentation)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "resources", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh resources)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "scripts", "help"], localizations: FastTestLocalization.self, uniqueTestName: "Help (workspace refresh scripts)", overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidResourceDirectory() {
        PackageRepository(mock: "InvalidResourceDirectory").test(commands: [
            ["refresh", "resources"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidTarget() {
        PackageRepository(mock: "InvalidTarget").test(commands: [
            ["refresh", "resources"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testLocalizationIdentifier() {
        var dictionary: [LocalizationIdentifier: Bool] = [:]
        dictionary[ContentLocalization.englishCanada] = true
        XCTAssertEqual(dictionary["🇨🇦EN"], true)
        dictionary["🇬🇧EN"] = false
        XCTAssertEqual(dictionary[ContentLocalization.englishUnitedKingdom], false)

        testCustomStringConvertibleConformance(of: LocalizationIdentifier("en"), localizations: FastTestLocalization.self, uniqueTestName: "English", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("cmn"), localizations: FastTestLocalization.self, uniqueTestName: "Mandarin", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("zxx"), localizations: FastTestLocalization.self, uniqueTestName: "Unknown", overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingDocumentation() {
        PackageRepository(mock: "MissingDocumentation").test(commands: [
            ["refresh", "inherited‐documentation"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingExample() {
        PackageRepository(mock: "MissingExample").test(commands: [
            ["refresh", "examples"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingReadMeLocalization() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["zxx"]
        configuration.documentation.readMe.contents.resolve = { _ in [:] }
        PackageRepository(mock: "MissingReadMeLocalization").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMultipleProducts() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "MultipleProducts").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLibraries() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "NoLibraries").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLocalizations() {
        PackageRepository(mock: "NoLocalizations").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testOneLocalization() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        PackageRepository(mock: "OneLocalization").test(commands: [
            ["refresh", "github"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testOneProductMultipleModules() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "OneProductMultipleModules").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testPartialReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.xcode.manage = true
        configuration.documentation.currentVersion = Version(0, 1, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.com")!
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.gitHub.developmentNotes = "..."
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇩🇪DE"] = "#dates"
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
        })
        PackageRepository(mock: "PartialReadMe").test(commands: [
            ["refresh", "read‐me"],
            ["refresh", "github"],
            ["document"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSDGLibrary() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(string: "https://example.github.io/SDG/SDG")!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.encryptedTravisCIDeploymentKey = "0123456789abcdef"
        configuration.gitHub.administrators = ["John Doe", "Jane Doe"]
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        for localization in configuration.documentation.localizations {
            configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .heading(text: ["🇨🇦EN": "Heading"]),
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇩🇪DE"] = "#dates"
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
        })
        var commands: [[StrictString]] = [
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
            ["normalize"]
        ]
        #if !os(Linux)
        commands.append(["refresh", "xcode"])
        #endif
        commands.append(contentsOf: [
            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"],
            ["validate"]
            ])
        PackageRepository(mock: "SDGLibrary").test(commands: commands, configuration: configuration, sdg: true, localizations: FastTestLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSDGTool() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(string: "https://example.github.io/SDG/SDG")!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.encryptedTravisCIDeploymentKey = "0123456789abcdef"
        configuration.gitHub.administrators = ["John Doe"]
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        for localization in configuration.documentation.localizations {
            configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇩🇪DE"] = "#dates"
            result["🇫🇷FR"] = "#dates"
            result["🇬🇷ΕΛ"] = "#dates"
            result["🇮🇱עב"] = "#dates"
            result["zxx"] = "#dates"
            return result
        })
        var commands: [[StrictString]] = [
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
            ["normalize"]
        ]
        #if !os(Linux)
        commands.append(["refresh", "xcode"])
        #endif
        commands.append(contentsOf: [
            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"]
            ])
        PackageRepository(mock: "SDGTool").test(commands: commands, configuration: configuration, sdg: true, localizations: FastTestLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSelfSpecificScripts() throws {
        try FileManager.default.do(in: repositoryRoot) {
            _ = try Workspace.command.execute(with: ["refresh", "scripts"]).get()
            _ = try Workspace.command.execute(with: ["refresh", "continuous‐integration"]).get()
        }
    }
}
