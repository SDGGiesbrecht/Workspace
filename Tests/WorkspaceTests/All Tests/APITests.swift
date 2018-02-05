/*
 APITests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone
import SDGCommandLine

import WorkspaceLibrary

class APITests : TestCase {

    func testCheckForUpdates() {
        XCTAssertErrorFree {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        }
    }

    func testSelfSpecificScripts() {
        XCTAssertErrorFree {
            try FileManager.default.do(in: repositoryRoot) {
                try Workspace.command.execute(with: ["refresh", "scripts"])
            }
        }
    }

    func testOnMockProjects() {
        // Get version checks over with, so that they are not in the output.
        triggerVersionChecks()

        // Make a depencency available.
        let developer = URL(fileURLWithPath: "/tmp/Developer")
        try? FileManager.default.removeItem(at: developer)
        defer { try? FileManager.default.removeItem(at: developer) }
        let dependency = developer.appendingPathComponent("Dependency")
        XCTAssertErrorFree {
            try FileManager.default.do(in: dependency) {
                try Shell.default.run(command: ["swift", "package", "init"])
                try Shell.default.run(command: ["git", "init"])
                try Shell.default.run(command: ["git", "add", "."])
                try Shell.default.run(command: ["git", "commit", "\u{2D}m", "Initialized."])
                try Shell.default.run(command: ["git", "tag", "1.0.0"])
            }
        }

        // Test on mock projects.
        let mockProjectsDirectory = repositoryRoot.appendingPathComponent("Tests/Mock Projects")
        let beforeDirectory = mockProjectsDirectory.appendingPathComponent("Before")
        XCTAssertErrorFree {
            for project in try FileManager.default.contentsOfDirectory(at: beforeDirectory, includingPropertiesForKeys: nil, options: [])
                where project.lastPathComponent ≠ ".DS_Store" {
                    print("\n\nTesting on “\(project.lastPathComponent)”...\n\n".formattedAsSectionHeader())

                    let expectedToFail = (try? project.appendingPathComponent("✗").checkResourceIsReachable()) == true
                    var commands = try String(from: project.appendingPathComponent("$.txt")).components(separatedBy: "\n").filter({ ¬$0.isEmpty }).map { $0.components(separatedBy: " ").map({ StrictString($0) }) }
                    #if os(Linux)
                        commands = commands.filter { command
                            return ¬command.contains("documentation‐coverage")
                        }
                    #endif

                    #if os(Linux)
                        // [_Workaround: Linux differs due to absence of Jazzy._]
                        let resultLocation = mockProjectsDirectory.appendingPathComponent("After (Linux)/" + project.lastPathComponent)
                        let outputLocation = mockProjectsDirectory.appendingPathComponent("Output (Linux)/" + project.lastPathComponent + ".txt")
                    #else
                        let resultLocation = mockProjectsDirectory.appendingPathComponent("After/" + project.lastPathComponent)
                        let outputLocation = mockProjectsDirectory.appendingPathComponent("Output/" + project.lastPathComponent + ".txt")
                    #endif

                    // Ensure proper starting state.
                    try? FileManager.default.removeItem(at: resultLocation)
                    try FileManager.default.copy(project, to: resultLocation)

                    try FileManager.default.do(in: resultLocation) {
                        LocalizationSetting(orderOfPrecedence: ["en\u{2D}CA"]).do {

                            #if !os(Linux)
                                // [_Workaround: Until Xcode management is testable._]
                                _ = try? Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                            #endif

                            var output: StrictString = ""

                            for command in commands {
                                output += "\n$ workspace " + command.joined(separator: " ") + "\n"
                                let execute = { output += try Workspace.command.execute(with: command + ["•no‐colour"]) }
                                if expectedToFail {
                                    do {
                                        try execute()
                                    } catch let error as Command.Error {
                                        output += "\n" + error.describe()
                                    } catch let error {
                                        XCTFail("Unexpected error: \(error)")
                                    }

                                } else {
                                    XCTAssertErrorFree {
                                        try execute()
                                    }
                                }
                            }

                            #if !os(Linux)
                                XCTAssertErrorFree {

                                    if project.lastPathComponent == "UnicodeSource" {
                                        let index = try String(from: resultLocation.appendingPathComponent("docs/\(project.lastPathComponent)/index.html"))
                                        XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")

                                        if project.lastPathComponent == "UnicodeSource" {
                                            let page = try String(from: resultLocation.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                                            XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                                        }
                                    }
                                }
                            #endif

                            if project.lastPathComponent == "SDG" {
                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (macOS).command"), "Generated macOS refresh script is not executable.")
                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (Linux).sh"), "Generated Linux refresh script is not executable.")
                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (macOS).command"), "Generated macOS validate script is not executable.")
                                #if os(Linux)
                                    XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (Linux).sh"), "Generated Linux validate script is not executable.")
                                #endif
                            }

                            // Remove variable files.
                            try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("Package.resolved"))
                            try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("docs/\(project.lastPathComponent)/docsets"))
                            checkForDifferences(in: "repository", at: resultLocation, for: project)

                            let replacement = "[...]".scalars
                            // Remove varying repository location.
                            output.replaceMatches(for: repositoryRoot.path.scalars, with: replacement)
                            // Remove varying cache directory.
                            output.replaceMatches(for: FileManager.default.url(in: .cache, at: "Cache").deletingLastPathComponent().path.scalars, with: replacement)
                            // Remove varying SwiftLint location.
                            output.replaceMatches(for: "\u{22}[...]/Tools/SwiftLint/swiftlint\u{22}".scalars, with: "swiftlint".scalars)
                            // Remove varying temporary directory.
                            output.replaceMatches(for: FileManager.default.url(in: .temporary, at: "Temporary").deletingLastPathComponent().path.scalars, with: replacement)
                            output.replaceMatches(for: "`..".scalars, with: "`".scalars)
                            output.replaceMatches(for: "/..".scalars, with: [])

                            XCTAssertErrorFree { try output.save(to: outputLocation) }
                            checkForDifferences(in: "output", at: outputLocation, for: project)
                        }
                    }
            }
        }
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCheckForUpdates", testCheckForUpdates),
            ("testOnMockProjects", testOnMockProjects)
        ]
    }
}
