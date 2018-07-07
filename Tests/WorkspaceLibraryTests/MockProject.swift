/*
 MockProject.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
@testable import WSInterface
import WSGeneralTestImports

import SDGExternalProcess

extension PackageRepository {

    private static let mockProjectsDirectory = repositoryRoot.appendingPathComponent("Tests/Mock Projects")
    private static func beforeDirectory(for mockProject: String) -> URL {
        return mockProjectsDirectory.appendingPathComponent("Before").appendingPathComponent(mockProject)
    }
    private static func afterDirectory(for mockProject: String) -> URL {
        return mockProjectsDirectory.appendingPathComponent("After").appendingPathComponent(mockProject)
    }

    // MARK: - Initialization

    init(mock name: String) {
        // Not using url(in: .temporary) because the dynamic URL causes Xcode’s derived data to grow limitlessly over many test iterations.
        self.init(at: URL(fileURLWithPath: "/tmp").appendingPathComponent(name))
    }

    func test<L>(commands: [[StrictString]], configuration: WorkspaceConfiguration = WorkspaceConfiguration(), sdg: Bool = false, localizations: L.Type, withDependency: Bool = false, overwriteSpecificationInsteadOfFailing: Bool, file: StaticString = #file, line: UInt = #line) where L : InputLocalization {
        do {
            try autoreleasepool {
                let developer = URL(fileURLWithPath: "/tmp/Developer")
                try? FileManager.default.removeItem(at: developer)
                defer { try? FileManager.default.removeItem(at: developer) }
                if withDependency {
                    let dependency = developer.appendingPathComponent("Dependency")
                    try FileManager.default.do(in: dependency) {
                        try Shell.default.run(command: ["swift", "package", "init"])
                        try Shell.default.run(command: ["git", "init"])
                        try Shell.default.run(command: ["git", "add", "."])
                        try Shell.default.run(command: ["git", "commit", "\u{2D}m", "Initialized."])
                        try Shell.default.run(command: ["git", "tag", "1.0.0"])
                    }
                }
                let beforeLocation = PackageRepository.beforeDirectory(for: location.lastPathComponent)

                // Simulators are not available to all CI jobs and must be tested separately.
                setenv("SIMULATOR_UNAVAILABLE_FOR_TESTING", "YES", 1 /* overwrite */)
                defer {
                    unsetenv("SIMULATOR_UNAVAILABLE_FOR_TESTING")
                }

                try? FileManager.default.removeItem(at: location)
                #if os(Linux)
                try Shell.default.run(command: ["cp", "\u{2D}r", Shell.quote(beforeLocation.path), Shell.quote(location.path)])
                #else
                try FileManager.default.copy(beforeLocation, to: location)
                #endif
                defer { try? FileManager.default.removeItem(at: location) }

                try FileManager.default.do(in: location) {
                    _ = try? Shell.default.run(command: ["git", "init"])
                    if (try? location.appendingPathComponent(".gitignore").checkResourceIsReachable()) ≠ true {
                        _ = try? FileManager.default.copy(repositoryRoot.appendingPathComponent(".gitignore"), to: location.appendingPathComponent(".gitignore"))
                    }

                    WorkspaceContext.current = try configurationContext()
                    if sdg {
                        configuration.applySDGOverrides()
                        configuration.validateSDGStandards()
                    }
                    WorkspaceConfiguration.queue(mock: configuration)
                    defer { _ = try? self.configuration(output: Command.Output.mock ) } // Dequeue even if unused.
                    resetConfigurationCache(debugReason: "new test")

                    for command in commands {

                        if ProcessInfo.isInContinuousIntegration {
                            // Travis CI needs period output of some sort; otherwise it assumes the tests have stalled.
                            _ = try? Shell.default.run(command: ["echo", "Tests continuing...", ">", "/dev/tty"])
                        }

                        print(StrictString("$ workspace ") + command.joined(separator: " "))
                        let specificationName: StrictString = StrictString("\(location.lastPathComponent) (") + command.joined(separator: " ") + ")"

                        // Special handling of commands with platform differences
                        func requireSuccess() {
                            do {
                                try Workspace.command.execute(with: command)
                            } catch {
                                XCTFail("\(error)", file: file, line: line)
                            }
                        }
                        func expectFailure() {
                            do {
                                XCTFail(String(try Workspace.command.execute(with: command)), file: file, line: line)
                            } catch {
                                // Expected.
                            }
                        }
                        if ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil, command == ["test"] {
                            // Phases skipped within Xcode due to rerouting interference.
                            if location.lastPathComponent == "Default" {
                                expectFailure()
                            } else {
                                requireSuccess()
                            }
                            continue
                        }
                        #if os(Linux)
                        if command == ["refresh", "scripts"]
                            ∨ command == ["validate", "build"]
                            ∨ command == ["test"] {
                            // Differing task set on Linux.
                            if location.lastPathComponent == "FailingTests" {
                                expectFailure()
                            } else {
                                requireSuccess()
                            }
                            continue
                        }
                        if command == ["validate", "build", "•job", "macos‐swift‐package‐manager"]
                            ∨ command == ["validate", "test‐coverage"]
                            ∨ command == ["document"]
                            ∨ command == ["validate", "documentation‐coverage"] {
                            // Invalid on Linux
                            expectFailure()
                            continue
                        }
                        #endif

                        // General commands
                        func postprocess(_ output: inout String) {

                            let any: RepetitionPattern<Unicode.Scalar> = RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy)

                            // Temporary directory varies.
                            output.scalars.replaceMatches(for: "`..".scalars, with: "`".scalars)
                            output.scalars.replaceMatches(for: "/..".scalars, with: "".scalars)
                            output.scalars.replaceMatches(for: FileManager.default.url(in: .temporary, at: "File").deletingLastPathComponent().path.scalars, with: "[Temporary]".scalars)
                            output.scalars.replaceMatches(for: "/private/tmp".scalars, with: "[Temporary]".scalars)
                            output.scalars.replaceMatches(for: "/tmp".scalars, with: "[Temporary]".scalars)

                            // Find hotkey varies.
                            output.scalars.replaceMatches(for: "⌘F".scalars, with: "[⌘F]".scalars)
                            output.scalars.replaceMatches(for: "Ctrl + F".scalars, with: "[⌘F]".scalars)

                            // Swift order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swift ".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ swift...]\n\n".scalars)

                            // Xcode order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ xcodebuild".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ xcodebuild...]\n\n".scalars)

                            // SwiftLint order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swiftlint".scalars),
                                any,
                                LiteralPattern("\n0".scalars)
                                ]), with: "[$ swiftlint...]\n0".scalars)
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swiftlint".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ swiftlint...]\n\n".scalars)

                            if command == ["validate"] {
                                // Refreshment occurs elswhere in continuous integration.
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\n\nValidating “".scalars)
                                    ]), with: "\n[Refreshing ...]\n\nValidating “".scalars)
                            }
                        }

                        testCommand(Workspace.command, with: command, localizations: localizations, uniqueTestName: specificationName, postprocess: postprocess, overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing, file: file, line: line)
                    }

                    #if !os(Linux)
                    // [_Workaround: Jazzy issues. (jazzy --version 0.9.3)_]
                    if location.lastPathComponent == "UnicodeSource" {
                        let index = try String(from: location.appendingPathComponent("docs/\(location.lastPathComponent)/index.html"))
                        XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")

                        if location.lastPathComponent == "UnicodeSource" {
                            let page = try String(from: location.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                            XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                        }
                    }
                    #endif

                    /// Commit hashes vary.
                    try? FileManager.default.removeItem(at: location.appendingPathComponent("Package.resolved"))
                    /// Documentation not generated on Linux.
                    if location.lastPathComponent == "PartialReadMe" {
                        try? FileManager.default.removeItem(at: location.appendingPathComponent("docs"))
                    }

                    let afterLocation = PackageRepository.afterDirectory(for: location.lastPathComponent)
                    if overwriteSpecificationInsteadOfFailing ∨ (try? afterLocation.checkResourceIsReachable()) ≠ true {
                        try? FileManager.default.removeItem(at: afterLocation)
                        try FileManager.default.move(location, to: afterLocation)
                    } else {

                        var files: Set<String> = []
                        for file in try PackageRepository(at: location).trackedFiles(output: Command.Output.mock) {
                            files.insert(file.path(relativeTo: location))
                        }
                        for file in try PackageRepository(at: afterLocation).trackedFiles(output: Command.Output.mock) {
                            files.insert(file.path(relativeTo: afterLocation))
                        }

                        for fileName in files where ¬fileName.hasSuffix(".dsidx") {
                            let result = location.appendingPathComponent(fileName)
                            let after = afterLocation.appendingPathComponent(fileName)
                            if let resultContents = try? String(from: result) {
                                if (try? String(from: after)) ≠ nil {
                                    compare(resultContents, against: after, overwriteSpecificationInsteadOfFailing: false, file: file, line: line)
                                } else {
                                    XCTFail("Unexpected file produced: “\(fileName)”")
                                }
                            } else {
                                if (try? String(from: after)) ≠ nil {
                                    XCTFail("Failed to produce “\(fileName)”.", file: file, line: line)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            XCTFail("\(error)", file: file, line: line)
        }
    }
}
