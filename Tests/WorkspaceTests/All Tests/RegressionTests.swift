/*
 RegressionTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

import SDGCornerstone
import SDGCommandLine

import WorkspaceLibrary

class RegressionTests : TestCase {

    func testDocumentationNotRepeated() {
        // Untracked

        XCTAssertErrorFree {
            try LocalizationSetting(orderOfPrecedence: ["en"]).do {
                let project = try MockProject()
                try project.do {
                    try "Generate Documentation: True\nEnforce Documentation Coverage: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    do {
                    let validation = try Workspace.command.execute(with: ["validate", "•job", "macos‐swift‐package‐manager"])
                    XCTAssert(¬validation.contains("ocumentation".scalars), "Documentation generation repeated in wrong job.")
                    } catch let error as Command.Error {
                        XCTAssert(¬error.describe().contains("ocumentation".scalars), "Documentation generation repeated in wrong job.")
                    } catch let error {
                        throw error
                    }
                }
            }
        }
    }

    static var allTests: [(String, (RegressionTests) -> () throws -> Void)] {
        return [
            ("testDocumentationNotRepeated", testDocumentationNotRepeated)
        ]
    }
}
