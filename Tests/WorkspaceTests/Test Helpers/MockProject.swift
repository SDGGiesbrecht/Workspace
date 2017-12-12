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

    init(type: String? = nil) throws {
        let uuid = UUID().uuidString
        location = FileManager.default.url(in: .temporary, at: "\(uuid)/MyProject")

        try FileManager.default.do(in: location) {
            // [_Workaround: This should use “workspace initialize”._]

            try Shell.default.run(command: ["swift", "package", "init"])
            if type == "Executable" {
                try [
                    "// swift-tools-version:4.0",
                    "",
                    "import PackageDescription",
                    "",
                    "let package = Package(",
                    "    name: \u{22}MyProject\u{22},",
                    "    products: [",
                    "        .library(name: \u{22}MyProject\u{22}, targets: [\u{22}MyProject\u{22}]),",
                    "        .executable(name: \u{22}tool\u{22}, targets: [\u{22}tool\u{22}]),",
                    "    ],",
                    "    targets: [",
                    "        .target(name: \u{22}MyProject\u{22}, dependencies: []),",
                    "        .target(name: \u{22}tool\u{22}, dependencies: []),",
                    "        .testTarget(name: \u{22}MyProjectTests\u{22}, dependencies: [\u{22}MyProject\u{22}])",
                    "    ]",
                    ")"
                    ].joined(separator: "\n").save(to: location.appendingPathComponent("Package.swift"))
                try "print(\u{22}Hello, world!\u{22})".save(to: location.appendingPathComponent("Sources/tool/main.swift"))
            }
            try Shell.default.run(command: ["git", "init"])

            if let projectType = type {
                try ("Project Type: " + projectType).save(to: location.appendingPathComponent(".Workspace Configuration.txt"))
            }
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
