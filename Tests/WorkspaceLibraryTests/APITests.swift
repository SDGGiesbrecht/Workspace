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

    func testCheckForUpdates() {
        do {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testDefaults() {
        PackageRepository(mock: "Default").test(commands: [
            // [_Workaround: This should just be “validate” once it is possible._]
            ["refresh", "scripts"],
            ["refresh", "resources"],

            ["proofread"],
            ["validate", "build"],
            ["test"],
            ["validate", "test‐coverage"],
            ["validate", "documentation‐coverage"],

            ["proofread", "•xcode"],
            ["validate", "build", "•job", "macos‐swift‐package‐manager"],
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: true) // [_Warning: Overwriting._]
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

    func testHelp() {
        testCommand(Workspace.command, with: ["help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace)", overwriteSpecificationInsteadOfFailing: false)
    }
}
