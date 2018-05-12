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
import GeneralTestImports

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

    func testCustomProofread() {
        PackageRepository(mock: "CustomProofread").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomReadMe() {
        PackageRepository(mock: "CustomReadMe").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
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

    func testExecutableProjectType() {
        PackageRepository(mock: "ExecutableProjectType").test(commands: [
            ["refresh", "read‐me"],
            ["document"],
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
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

    func testInvalidConfigurationEnumerationValue() {
        PackageRepository(mock: "InvalidConfigurationEnumerationValue").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidReference() {
        PackageRepository(mock: "InvalidReference").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidRelatedProject() {
        PackageRepository(mock: "InvalidRelatedProject").test(commands: [
            ["refresh", "read‐me"]
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

    func testNoAbout() {
        PackageRepository(mock: "NoAbout").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoAuthor() {
        #if !os(Linux)
        PackageRepository(mock: "NoAuthor").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
    }

    func testNoDescription() {
        PackageRepository(mock: "NoDescription").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoDocumentationURL() {
        PackageRepository(mock: "NoDocumentationURL").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoExamples() {
        PackageRepository(mock: "NoExamples").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoFeatures() {
        PackageRepository(mock: "NoFeatures").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLocalizations() {
        PackageRepository(mock: "NoLocalizations").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoMacOS() {
        #if !os(Linux)
        PackageRepository(mock: "NoMacOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
    }

    func testNoMacOSOrIOS() {
        #if !os(Linux)
        PackageRepository(mock: "NoMacOSOrIOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
    }

    func testNoMacOSOrIOSOrWatchOS() {
        #if !os(Linux)
        PackageRepository(mock: "NoMacOSOrIOSOrWatchOS").test(commands: [
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
    }

    func testNoOther() {
        PackageRepository(mock: "NoOther").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoQuotation() {
        PackageRepository(mock: "NoQuotation").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoQuotationSource() {
        PackageRepository(mock: "NoQuotationSource").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoRepositoryURL() {
        PackageRepository(mock: "NoRepositoryURL").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testPartialReadMe() {
        PackageRepository(mock: "PartialReadMe").test(commands: [
            ["refresh", "read‐me"],
            ["document"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSDGLibrary() {
        PackageRepository(mock: "SDGLibrary").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "read‐me"],
            ["refresh", "continuous‐integration"],
            ["refresh", "resources"],
            ["normalize"],

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"]
            ], localizations: InterfaceLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSDGTool() {
        PackageRepository(mock: "SDGTool").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "read‐me"],
            ["refresh", "continuous‐integration"],
            ["refresh", "resources"],
            ["normalize"],

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"]
            ], localizations: InterfaceLocalization.self, withDependency: true, overwriteSpecificationInsteadOfFailing: false)
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

    func testUndefinedConfigurationValue() {
        PackageRepository(mock: "UndefinedConfigurationValue").test(commands: [
            ["refresh", "read‐me"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testUnicodeSource() {
        #if !os(Linux)
        PackageRepository(mock: "UnicodeSource").test(commands: [
            ["refresh", "read‐me"],
            ["validate", "documentation‐coverage"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
        #endif
    }

    func testHelp() {
        testCommand(Workspace.command, with: ["help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["proofread", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace proofread)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["validate", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace validate)", overwriteSpecificationInsteadOfFailing: false)
    }
}
