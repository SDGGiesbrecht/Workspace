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
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
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
                    autoreleasepool {

                        if let filter = ProcessInfo.processInfo.environment["MOCK_PROJECT"],
                            project.lastPathComponent ≠ filter {
                            // This environment variable can be used to test a single mock project at a time.
                            continue
                        }

                        print("\n\nTesting on “\(project.lastPathComponent)”...\n\n".formattedAsSectionHeader())

                        let expectedToFail = (try? project.appendingPathComponent("✗").checkResourceIsReachable()) == true
                        var commands = try String(from: project.appendingPathComponent("$.txt")).components(separatedBy: "\n").filter({ ¬$0.isEmpty }).map { $0.components(separatedBy: " ").map({ StrictString($0) }) }
                        #if os(Linux)
                        commands = commands.filter { command in
                            return ¬command.contains(where: { $0 ∈ Set<StrictString>(["documentation‐coverage", "macos‐swift‐package‐manager"])})
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
                        #if os(Linux)
                        try Shell.default.run(command: ["cp", "\u{2D}r", Shell.quote(project.path), Shell.quote(resultLocation.path)])
                        #else
                        try FileManager.default.copy(project, to: resultLocation)
                        #endif

                        try FileManager.default.do(in: resultLocation) {
                            LocalizationSetting(orderOfPrecedence: ["en\u{2D}CA"]).do {

                                // Simulators are not available to all CI jobs and must be tested separately.
                                setenv("SIMULATOR_UNAVAILABLE_FOR_TESTING", "YES", 1 /* overwrite */)
                                defer {
                                    unsetenv("SIMULATOR_UNAVAILABLE_FOR_TESTING")
                                }

                                #if !os(Linux)
                                // [_Workaround: Until Xcode management is testable._]
                                _ = try? Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"])
                                #endif

                                var output: StrictString = ""

                                for command in commands {
                                    autoreleasepool {
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

                                let replacement: StrictString = "[...]"
                                // Remove varying repository location.
                                output.replaceMatches(for: repositoryRoot.path.scalars, with: replacement)
                                // Remove varying cache directory.
                                output.replaceMatches(for: FileManager.default.url(in: .cache, at: "Cache").deletingLastPathComponent().path.scalars, with: replacement)
                                // Remove varying SwiftLint location.
                                output.replaceMatches(for: "\u{22}[...]/Tools/SwiftLint/swiftlint\u{22}".scalars, with: "swiftlint".scalars)
                                // Remove varying temporary directory.
                                output.replaceMatches(for: FileManager.default.url(in: .temporary, at: "Temporary").deletingLastPathComponent().path.scalars, with: replacement)
                                // Remove varying home directory.
                                output.replaceMatches(for: NSHomeDirectory().scalars, with: replacement)
                                output.replaceMatches(for: "`..".scalars, with: "`".scalars)
                                output.replaceMatches(for: "/..".scalars, with: [])
                                // Remove varying times.
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("started at ".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" })),
                                    LiteralPattern("\n".scalars)
                                    ]), with: "started at " + replacement + "\n")
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("passed (".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ " " })),
                                    LiteralPattern(" seconds".scalars)
                                    ]), with: "passed " + replacement + " seconds")
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("unexpected) in ".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" })),
                                    LiteralPattern(" seconds".scalars)
                                    ]), with: "unexpected) in " + replacement + " seconds")
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("passed at ".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" })),
                                    LiteralPattern(".\n".scalars)
                                    ]), with: "passed at " + replacement + "\n")
                                // Remove varying Xcode output
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("Build settings from command line:".scalars),
                                    RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
                                    LiteralPattern("** BUILD SUCCEEDED **".scalars)
                                    ]), with: replacement)
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("Build settings from command line:".scalars),
                                    RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
                                    LiteralPattern("** TEST SUCCEEDED **".scalars)
                                    ]), with: replacement)
                                // Remove tests skipped in Xcode sandbox
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("$ swift test".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "§" }), consumption: .lazy),
                                    LiteralPattern("\n\n\n".scalars)
                                    ]), with: "".scalars)
                                output.replaceMatches(for: "✓ Tests pass on macOS with the Swift Package Manager.\n".scalars, with: "".scalars)
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("Test Suite".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" }), consumption: .lazy),
                                    LiteralPattern("\n".scalars)
                                    ]), with: "".scalars)
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("Test Case".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" }), consumption: .lazy),
                                    LiteralPattern("\n".scalars)
                                    ]), with: "".scalars)
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\u{9} Executed".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\n" }), consumption: .lazy),
                                    LiteralPattern("\n".scalars)
                                    ]), with: "".scalars)
                                // Remove clang notices
                                output.replaceMatches(for: "warning: minimum recommended clang is version 3.6, otherwise you may encounter linker errors.\n".scalars, with: "".scalars)
                                #if os(Linux)
                                // Remove resolves
                                output.replaceMatches(for: "\n$ swift package resolve\n\n".scalars, with: "".scalars)
                                #endif
                                // SwiftLint parses files in a non‐deterministic order.
                                output.replaceMatches(for: CompositePattern([
                                    LiteralPattern("Linting \u{27}".scalars),
                                    RepetitionPattern(ConditionalPattern({ $0 ≠ "\u{27}" }), consumption: .lazy),
                                    LiteralPattern("\u{27}".scalars)
                                    ]), with: "Linting \u{27}[...]\u{27}".scalars)
                                // Xcode prints this inconsistently
                                output.replaceMatches(for: "Generating coverage data...\n".scalars, with: "".scalars)

                                XCTAssertErrorFree { try output.save(to: outputLocation) }
                                checkForDifferences(in: "output", at: outputLocation, for: project)
                            }
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
