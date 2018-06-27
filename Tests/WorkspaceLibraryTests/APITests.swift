/*
 APITests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralTestImports

import SDGExternalProcess

class APITests : TestCase {

    static var triggeredVersionChecks: Void?
    override func setUp() {
        super.setUp()
        // Get version checks over with, so that they are not in the output.
        cached(in: &APITests.triggeredVersionChecks) {
            triggerVersionChecks()
        }
    }

    func testBadStyle() {
        PackageRepository(mock: "BadStyle").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"]
            ], localizations: InterfaceLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCheckForUpdates() {
        do {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testContinuousIntegrationWithoutScripts() {
        let configuration = WorkspaceConfiguration()
        configuration.provideWorkflowScripts = false
        configuration.continuousIntegration.manage = true
        PackageRepository(mock: "ContinuousIntegrationWithoutScripts").test(commands: [
            ["refresh", "continuous‐integration"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomProofread() {
        let configuration = WorkspaceConfiguration()
        configuration.proofreading.rules.remove(.colonSpacing)
        configuration.proofreading.rules.remove(.unicode)
        for rule in ProofreadingRule.cases {
            _ = rule.category
        }
        PackageRepository(mock: "CustomProofread").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.currentVersion = Version(1, 2, 3)
        configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Repository")!
        configuration.documentation.localizations = ["en"]
        configuration.documentation.readMe.quotation = Quotation(original: "Blah blah blah...")
        configuration.documentation.readMe.quotation?.link["en"] = URL(string: "http://somewhere.com")!
        configuration.documentation.readMe.installationInstructions = Lazy(resolve: { configuration in
            return [
                "en": StrictString([
                    "## Installation",
                    "",
                    "Build from source at tag `\(configuration.documentation.currentVersion!.string())` of `\(configuration.documentation.repositoryURL!.absoluteString)`."
                    ].joinedAsLines())
            ]
        })
        configuration.documentation.readMe.exampleUsage = [
            "en": StrictString([
                "```swift",
                "let x = something()",
                "```"
                ].joinedAsLines())
        ]
        PackageRepository(mock: "CustomReadMe").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testDefaults() {
        PackageRepository(mock: "Default").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "resources"],
            ["normalize"],

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"],
            ["validate", "build", "•job", "macos‐swift‐package‐manager"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testExecutable() {
        let configuration = WorkspaceConfiguration()
        configuration.supportedOperatingSystems.remove(.iOS)
        configuration.supportedOperatingSystems.remove(.watchOS)
        configuration.supportedOperatingSystems.remove(.tvOS)
        configuration.documentation.localizations = ["en"]
        configuration.documentation.readMe.quotation = Quotation(original: "Blah blah blah...")
        PackageRepository(mock: "Executable").test(commands: [
            ["refresh", "read‐me"],
            ["document"],
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testFailingDocumentationCoverage() {
        PackageRepository(mock: "FailingDocumentationCoverage").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testFailingTests() {
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
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testInvalidResourceDirectory() {
        PackageRepository(mock: "InvalidResourceDirectory").test(commands: [
            ["refresh", "resources"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testInvalidTarget() {
        PackageRepository(mock: "InvalidTarget").test(commands: [
            ["refresh", "resources"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testLocalizationIdentifier() {
        var dictionary: [LocalizationIdentifier: Bool] = [:]
        dictionary[ContentLocalization.englishCanada] = true
        XCTAssertEqual(dictionary["🇨🇦EN"], true)
        dictionary["🇬🇧EN"] = false
        XCTAssertEqual(dictionary[ContentLocalization.englishUnitedKingdom], false)

        testCustomStringConvertibleConformance(of: LocalizationIdentifier("en"), localizations: InterfaceLocalization.self, uniqueTestName: "English", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("cmn"), localizations: InterfaceLocalization.self, uniqueTestName: "Mandarin", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("zxx"), localizations: InterfaceLocalization.self, uniqueTestName: "Unknown", overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingReadMeLocalization() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["zxx"]
        configuration.documentation.readMe.contents.resolve = { _ in [:] }
        PackageRepository(mock: "MissingReadMeLocalization").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMultipleProducts() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "MultipleProducts").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLibraries() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "NoLibraries").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLocalizations() {
        PackageRepository(mock: "NoLocalizations").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoMacOS() {
        #if !os(Linux)
        let configuration = WorkspaceConfiguration()
        configuration.supportedOperatingSystems.remove(.macOS)
        configuration.documentation.api.generate = true
        configuration.documentation.api.yearFirstPublished = 2017
        PackageRepository(mock: "NoMacOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
     }

    func testNoMacOSOrIOS() {
        #if !os(Linux)
        let configuration = WorkspaceConfiguration()
        configuration.supportedOperatingSystems.remove(.macOS)
        configuration.supportedOperatingSystems.remove(.iOS)
        configuration.documentation.api.generate = true
        PackageRepository(mock: "NoMacOSOrIOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
     }

    func testNoMacOSOrIOSOrWatchOS() {
        #if !os(Linux)
        let configuration = WorkspaceConfiguration()
        configuration.supportedOperatingSystems.remove(.macOS)
        configuration.supportedOperatingSystems.remove(.iOS)
        configuration.supportedOperatingSystems.remove(.watchOS)
        configuration.documentation.api.generate = true
        PackageRepository(mock: "NoMacOSOrIOSOrWatchOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
     }

    func testOneProductMultipleModules() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "OneProductMultipleModules").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testPartialReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.currentVersion = Version(0, 1, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.com")!
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        configuration.documentation.readMe.quotation = Quotation(original: "Blah blah blah...")
        configuration.documentation.readMe.quotation?.link["🇨🇦EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIV")!
        configuration.documentation.readMe.quotation?.link["🇬🇧EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIVUK")!
        configuration.documentation.readMe.quotation?.link["🇺🇸EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIV")!
        PackageRepository(mock: "PartialReadMe").test(commands: [
            ["refresh", "read‐me"],
            ["document"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
     }

    func testSDGLibrary() {
        let configuration = WorkspaceConfiguration()
        configuration.applySDGDefaults()
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
        configuration.documentation.readMe.quotation = Quotation(original: "« ... »")
        for localization in configuration.documentation.localizations {
            configuration.documentation.readMe.shortProjectDescription[localization] = "..."
            configuration.documentation.readMe.quotation?.translation[localization] = "..."
            configuration.documentation.readMe.quotation?.citation[localization] = "..."
            configuration.documentation.readMe.quotation?.link[localization] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV")!
            configuration.documentation.readMe.featureList[localization] = "..."
            configuration.documentation.readMe.other[localization] = "..."
            configuration.documentation.readMe.about[localization] = "..."
            configuration.documentation.readMe.exampleUsage[localization] = Markdown("#example(Read‐Me \(localization.icon.flatMap({String($0)}) ?? localization.code))")
        }
        configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "This project does stuff."
        configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = "“...”"
        configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = "someone"
        configuration.documentation.readMe.quotation?.link["🇬🇧EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIVUK")!
        configuration.documentation.readMe.featureList["🇨🇦EN"] = [
            "\u{2D} Stuff.",
            "\u{2D} More stuff.",
            "\u{2D} Even more stuff."
            ].joinedAsLines()
        configuration.documentation.readMe.other["🇨🇦EN"] = [
            "## Other",
            "",
            "..."
            ].joinedAsLines()
        configuration.documentation.readMe.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .heading(text: ["🇨🇦EN": "Heading"]),
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.testCoverageExemptions.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.testCoverageExemptions.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        PackageRepository(mock: "SDGLibrary").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "read‐me"],
            ["refresh", "github"],
            ["refresh", "continuous‐integration"],
            ["refresh", "resources"],
            ["normalize"],
            #if !os(Linux)
            ["refresh", "xcode"],
            #endif

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"]
            ], configuration: configuration, sdg: true, localizations: InterfaceLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
     }

    func testSDGTool() {
        let configuration = WorkspaceConfiguration()
        configuration.applySDGDefaults()
        configuration.supportedOperatingSystems.remove(.iOS)
        configuration.supportedOperatingSystems.remove(.watchOS)
        configuration.supportedOperatingSystems.remove(.tvOS)
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
        configuration.documentation.readMe.quotation = Quotation(original: "« ... »")
        for localization in configuration.documentation.localizations {
            configuration.documentation.readMe.shortProjectDescription[localization] = "..."
            configuration.documentation.readMe.quotation?.translation[localization] = "..."
            configuration.documentation.readMe.quotation?.citation[localization] = "..."
            configuration.documentation.readMe.quotation?.link[localization] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV")!
            configuration.documentation.readMe.featureList[localization] = "..."
            configuration.documentation.readMe.other[localization] = "..."
            configuration.documentation.readMe.about[localization] = "..."
            configuration.documentation.readMe.exampleUsage[localization] = Markdown("#example(Read‐Me \(localization.icon.flatMap({String($0)}) ?? localization.code))")
        }
        configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "This project does stuff."
        configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = "“...”"
        configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = "someone"
        configuration.documentation.readMe.quotation?.link["🇬🇧EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIVUK")!
        configuration.documentation.readMe.featureList["🇨🇦EN"] = [
            "\u{2D} Stuff.",
            "\u{2D} More stuff.",
            "\u{2D} Even more stuff."
            ].joinedAsLines()
        configuration.documentation.readMe.other["🇨🇦EN"] = [
            "## Other",
            "",
            "..."
            ].joinedAsLines()
        configuration.documentation.readMe.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.testCoverageExemptions.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.testCoverageExemptions.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        PackageRepository(mock: "SDGTool").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "read‐me"],
            ["refresh", "github"],
            ["refresh", "continuous‐integration"],
            ["refresh", "resources"],
            ["normalize"],
            #if !os(Linux)
            ["refresh", "xcode"],
            #endif

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"]
            ], configuration: configuration, sdg: true, localizations: InterfaceLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
     }

    func testSelfSpecificScripts() {
        do {
            try FileManager.default.do(in: repositoryRoot) {
                try Workspace.command.execute(with: ["refresh", "scripts"])
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
            }
        } catch {
            XCTFail("\(error)")
        }
     }

    func testUnicodeSource() {
        #if !os(Linux)
        let configuration = WorkspaceConfiguration()
        configuration.documentation.api.generate = true
        configuration.documentation.localizations = ["en"]
        PackageRepository(mock: "UnicodeSource").test(commands: [
            ["refresh", "read‐me"],
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
     }

    func testHelp() {
        testCommand(Workspace.command, with: ["help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["proofread", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace proofread)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["validate", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace validate)", overwriteSpecificationInsteadOfFailing: false)
     }
}
