/*
 MockProject.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

class MockProject {

    // MARK: - Initialization

    init() throws {
        location = FileManager.default.url(in: .temporary, at: "MyProject")
        print("Mock project: \(location.path)")

        try FileManager.default.do(in: location) {
            // [_Workaround: This should use “workspace initialize”._]

            try Shell.default.run(command: ["swift", "package", "init"])
            try Shell.default.run(command: ["git", "init"])
        }
    }

    deinit {
        try? FileManager.default.removeItem(at: location)
    }

    // MARK: - Properties

    let location: URL

    // MARK: - Usage

    func `do`(closure: () throws -> Void) throws {
        try FileManager.default.do(in: location) {
            try closure()
        }
    }
}
