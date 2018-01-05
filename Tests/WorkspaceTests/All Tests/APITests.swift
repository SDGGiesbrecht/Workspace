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

    func testWorkflow() {
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

                    #if !os(Linux)
                        // [_Workaround: Linux differs due to absence of Jazzy._]
                        let resultLocation = mockProjectsDirectory.appendingPathComponent("After/" + project.lastPathComponent)
                        let outputLocation = mockProjectsDirectory.appendingPathComponent("Output/" + project.lastPathComponent + ".txt")
                    #endif

                    // Ensure proper starting state.
                    func revertToStartingState() {
                        try? FileManager.default.removeItem(at: project)
                        XCTAssertErrorFree {
                            try FileManager.default.do(in: repositoryRoot) {
                                try Shell.default.run(command: [
                                    "git", "checkout", Shell.quote(project.path)
                                    ])
                            }
                        }
                    }
                    revertToStartingState()
                    defer { revertToStartingState() }

                    try FileManager.default.do(in: project) {
                        LocalizationSetting(orderOfPrecedence: ["en\u{2D}CA"]).do {

                            // [_Workaround: This should eventually just do “workspace validate”._]
                            var output: StrictString = ""

                            if expectedToFail {
                                do {
                                    output += "\n$ workspace refresh scripts\n"
                                    output += try Workspace.command.execute(with: ["refresh", "scripts", "•no‐colour"])

                                    if project.lastPathComponent ∉ Set(["FailingDocumentationCoverage", "InvalidConfigurationEnumerationValue", "InvalidResourceDirectory",
                                                                            "InvalidTarget",
                                                                            "NoAuthor"]) {
                                        output += "\n$ workspace refresh read‐me\n"
                                        output += try Workspace.command.execute(with: ["refresh", "read‐me", "•no‐colour"])
                                    }

                                    if project.lastPathComponent ∉ Set(["FailingDocumentationCoverage", "InvalidConfigurationEnumerationValue", "InvalidProjectType",
                                                                            "NoLocalizations", "UndefinedConfigurationValue"]) {
                                        output += "\n$ workspace refresh continuous‐integration\n"
                                        output += try Workspace.command.execute(with: ["refresh", "continuous‐integration", "•no‐colour"])
                                    }

                                    output += "\n$ workspace refresh resources\n"
                                    output += try Workspace.command.execute(with: ["refresh", "resources", "•no‐colour"])

                                    #if !os(Linux)
                                        try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])

                                        output += "\n$ workspace validate documentation‐coverage\n"
                                        output += try Workspace.command.execute(with: ["validate", "documentation‐coverage", "•no‐colour"])
                                    #endif
                                } catch let error as Command.Error {
                                    output += "\n" + error.describe()
                                } catch let error {
                                    XCTFail("Unexpected error: \(error)")
                                }
                            } else {
                                XCTAssertErrorFree {
                                    output += "\n$ workspace refresh scripts\n"
                                    output += try Workspace.command.execute(with: ["refresh", "scripts", "•no‐colour"])
                                }

                                if project.lastPathComponent ∉ Set(["ApplicationProjectType", "Default", "NoMacOS", "NoMacOSOrIOS", "NoMacOSOrIOSOrWatchOS", "UnicodeSource"]) {
                                    XCTAssertErrorFree {
                                        output += "\n$ workspace refresh read‐me\n"
                                        output += try Workspace.command.execute(with: ["refresh", "read‐me", "•no‐colour"])
                                    }
                                }

                                if project.lastPathComponent ∉ Set(["CustomReadMe", "Default", "ExecutableProjectType", "NoMacOS", "NoMacOSOrIOS", "NoMacOSOrIOSOrWatchOS", "PartialReadMe", "UnicodeSource"]) {
                                    XCTAssertErrorFree {
                                        output += "\n$ workspace refresh continuous‐integration\n"
                                        output += try Workspace.command.execute(with: ["refresh", "continuous‐integration", "•no‐colour"])
                                    }
                                }

                                XCTAssertErrorFree {
                                    output += "\n$ workspace refresh resources\n"
                                    output += try Workspace.command.execute(with: ["refresh", "resources", "•no‐colour"])
                                }

                                #if !os(Linux)
                                    XCTAssertErrorFree {
                                        try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                                    }

                                    XCTAssertErrorFree {
                                        output += "\n$ workspace validate documentation‐coverage\n"
                                        output += try Workspace.command.execute(with: ["validate", "documentation‐coverage", "•no‐colour"])

                                        if project.lastPathComponent ∉ Set(["ApplicationProjectType", "CustomReadMe", "Default", "ExecutableProjectType", "PartialReadMe", "SDG"]) {
                                            let index = try String(from: project.appendingPathComponent("docs/\(project.lastPathComponent)/index.html"))
                                            XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")

                                            if project.lastPathComponent == "UnicodeSource" {
                                                let page = try String(from: project.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                                                XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                                            }
                                        }
                                    }
                                #endif

                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (macOS).command"), "Generated macOS refresh script is not executable.")
                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (Linux).sh"), "Generated Linux refresh script is not executable.")
                                XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (macOS).command"), "Generated macOS validate script is not executable.")
                                #if os(Linux)
                                    XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (Linux).sh"), "Generated Linux validate script is not executable.")
                                #endif

                                #if !os(Linux)
                                    // [_Workaround: Linux differs due to absence of Jazzy._]
                                    XCTAssertErrorFree {
                                        try? FileManager.default.removeItem(at: resultLocation)
                                        try FileManager.default.copy(project, to: resultLocation)
                                        // Remove variable files.
                                        try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("Package.resolved"))
                                        try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("docs/\(project.lastPathComponent)/docsets"))
                                    }
                                    checkForDifferences(in: "repository", at: resultLocation, for: project)
                                #endif
                            }

                            #if !os(Linux)
                                // [_Workaround: Linux differs due to absence of Jazzy._]
                                let replacement = "[...]".scalars
                                // Remove varying repository location.
                                output.replaceMatches(for: repositoryRoot.path.scalars, with: replacement)
                                // Remove varying temporary directory.
                                output.replaceMatches(for: FileManager.default.url(in: .temporary, at: "Temporary").deletingLastPathComponent().path.scalars, with: replacement)
                                output.replaceMatches(for: "`..".scalars, with: "`".scalars)
                                output.replaceMatches(for: "/..".scalars, with: [])

                                XCTAssertErrorFree { try output.save(to: outputLocation) }
                                checkForDifferences(in: "output", at: outputLocation, for: project)
                            #endif
                        }
                    }
            }
        }
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCheckForUpdates", testCheckForUpdates),
            ("testWorkflow", testWorkflow)
        ]
    }
}
