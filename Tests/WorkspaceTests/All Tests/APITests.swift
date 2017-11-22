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

    func testCheckForUpdates() {
        XCTAssertErrorFree {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        }
    }

    func testConfiguration() {
        XCTAssertThrowsError(containing: "Invalid") {
            let project = try MockProject()
            try project.do {
                try "Manage Continuous Integration: Maybe".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
            }
        }
        XCTAssertThrowsError(containing: "Invalid") {
            let project = try MockProject()
            try project.do {
                try "Project Type: Something\nManage Continuous Integration: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
            }
        }
    }

    func testContinuousIntegration() {

        // Inactive.
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Manage Continuous Integration: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssertEqual(try String(from: configuration), "...")
            }
        }

        // Active.
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Manage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
        XCTAssertErrorFree {
            let project = try MockProject(type: "Application")
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Project Type: Application\nManage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
        XCTAssertErrorFree {
            let project = try MockProject(type: "Executable")
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Project Type: Executable\nManage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
    }

    func testDocumentation() {
        #if !os(Linux)
            XCTAssertErrorFree {
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Repository URL: https://github.com/user/project\nAuthor: John Doe\nSupport macOS: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                }
            }

            XCTAssertErrorFree {
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Documentation Copyright: ©0001 John Doe\nSupport macOS: False\nSupport iOS: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try [
                        "/// ...",
                        "infix operator ≠",
                        "/// ...",
                        "infix operator ¬",
                        "extension Bool {",
                        "    /// ...",
                        "    public static func ≠(lhs: Bool, rhs: Bool) -> Bool {",
                        "        return true",
                        "    }",
                        "    /// ...",
                        "    public static func ¬(lhs: Bool, rhs: Bool) -> Bool {",
                        "        return true",
                        "    }",
                        "    /// ...",
                        "    public static func אבג() {}",
                        "}"
                        ].joined(separator: "\n").save(to: project.location.appendingPathComponent("Sources/MyProject/Unicode.swift"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                    let page = try String(from: project.location.appendingPathComponent("docs/MyProject/Extensions/Bool.html"))
                    XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                }
            }

            XCTAssertThrowsError(containing: "not defined") {
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Documentation Copyright: [_Author_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                }
            }

            XCTAssertErrorFree {
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Support macOS: False\nSupport iOS: False\nSupport watchOS: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                }
            }

            XCTAssertThrowsError(containing: "fails validation") {
                let project = try MockProject(type: "Library")
                try project.do {
                    try "public func undocumentedFunction() {}".save(to: project.location.appendingPathComponent("Sources/MyProject/Undocumented.swift"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                }
            }
        #endif
    }

    func testResources() {
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                try "Text File".save(to: project.location.appendingPathComponent("Resources/MyProject/Text Resource.txt"))
                defer {
                    XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("let textResource ="), "Failed to generate code to access resources.")
                }

                try "Data File".save(to: project.location.appendingPathComponent("Resources/MyProject/Miscellaneous/1‐2‐3!.undefined"))
                defer {
                    XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("enum Miscellaneous {"), "Failed to generate resource namespace.")
                    XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("let _1_2_3 ="), "Failed to generate code to access nested resources.")
                }

                // [_Workaround: This should eventually just run “validate” to make sure it passes other validation too._]]
                try Workspace.command.execute(with: ["refresh", "resources"])
                try Shell.default.run(command: ["swift", "build"]) // Generated code must have valid syntax.
            }
        }

        XCTAssertThrowsError(containing: "Text Resource.txt") {
            let project = try MockProject()
            try project.do {
                try "Text File".save(to: project.location.appendingPathComponent("Resources/Text Resource.txt"))
                try Workspace.command.execute(with: ["refresh", "resources"])
            }
        }

        XCTAssertThrowsError(containing: "InvalidTarget") {
            let project = try MockProject()
            try project.do {
                try "Text File".save(to: project.location.appendingPathComponent("Resources/InvalidTarget/Text Resource.txt"))
                try Workspace.command.execute(with: ["refresh", "resources"])
            }
        }
    }

    func testScripts() {
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                // Validate that generated scripts work.
                try "Deprecated".save(to: project.location.appendingPathComponent("Refresh Workspace (macOS).command"))
                try Workspace.command.execute(with: ["refresh", "scripts"])
                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (macOS).command"), "Generated macOS refresh script is not executable.")
                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (Linux).sh"), "Generated Linux refresh script is not executable.")
                XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (macOS).command"), "Generated macOS validate script is not executable.")
                #if os(Linux)
                    XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (Linux).sh"), "Generated Linux validate script is not executable.")
                #endif
            }
        }

        XCTAssertErrorFree {
            try FileManager.default.do(in: repositoryRoot) {
                // Validate generation of self‐specific scripts.
                try Workspace.command.execute(with: ["refresh", "scripts"])
            }
        }
    }

    func testWorkflow() {
        XCTAssertErrorFree {
            try MockProject().do {

                // [_Workaround: This should eventually just do “validate”._]
                try Workspace.command.execute(with: ["refresh", "scripts"])
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                try Workspace.command.execute(with: ["refresh", "resources"])
                try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
            }
        }

        XCTAssertErrorFree {
            try MockProject(type: "Library").do {

                // [_Workaround: This should eventually just do “validate”._]
                try Workspace.command.execute(with: ["refresh", "scripts"])
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                try Workspace.command.execute(with: ["refresh", "resources"])
                try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
            }
        }

        XCTAssertErrorFree {
            try MockProject(type: "Application").do {

                // [_Workaround: This should eventually just do “validate”._]
                try Workspace.command.execute(with: ["refresh", "scripts"])
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                try Workspace.command.execute(with: ["refresh", "resources"])
                try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
            }
        }

        XCTAssertErrorFree {
            try MockProject(type: "Executable").do {

                // [_Workaround: This should eventually just do “validate”._]
                try Workspace.command.execute(with: ["refresh", "scripts"])
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                try Workspace.command.execute(with: ["refresh", "resources"])
                try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
            }
        }
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCheckForUpdates", testCheckForUpdates),
            ("testConfiguration", testConfiguration),
            ("testContinuousIntegration", testContinuousIntegration),
            ("testDocumentation", testDocumentation),
            ("testResources", testResources),
            ("testScripts", testScripts),
            ("testWorkflow", testWorkflow)
        ]
    }
}
