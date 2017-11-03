/*
 APITests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone

import WorkspaceLibrary

class APITests : TestCase {

    func testResources() {
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                try "Text file.".save(to: project.location.appendingPathComponent("Resources/MyProject/Text Resource.txt"))

                try Workspace.command.execute(with: ["refresh", "resources"])

                XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("let textResource ="), "Failed to generate code to access resources.")

                try Shell.default.run(command: ["swift", "build"]) // Generated code has valid syntax.
            }
        }
    }

    func testWorkflow() {
        XCTAssertErrorFree {
            try MockProject().do {

                // [_Workaround: This should eventually just do “validate”._]
                try Workspace.command.execute(with: ["refresh", "resources"])
            }
        }
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testWorkflow", testWorkflow)
        ]
    }
}
