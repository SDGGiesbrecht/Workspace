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

    func testWorkflow() {
        XCTAssertErrorFree {
            let library = FileManager.default.url(in: .temporary, at: "My Library")
            defer { FileManager.default.delete(.temporary) }

            try FileManager.default.do(in: library) {
                try Workspace.command.execute(with: ["initialize"])
                try Workspace.command.execute(with: ["validate"])
            }
        }
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testWorkflow", testWorkflow)
        ]
    }
}
