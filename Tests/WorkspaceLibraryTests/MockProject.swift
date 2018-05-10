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
import GeneralTestImports

import SDGExternalProcess

extension PackageRepository {

    private static let mockProjectsDirectory = repositoryRoot.appendingPathComponent("Tests/Mock Projects")
    private static func beforeDirectory(for mockProject: String) -> URL {
        return mockProjectsDirectory.appendingPathComponent("Before").appendingPathComponent(mockProject)
    }

    // MARK: - Initialization

    init(mock name: String) {
        // Not using url(in: .temporary) because the dynamic URL causes Xcode’s derived data to grow limitlessly over many test iterations.
        self.init(at: URL(fileURLWithPath: "/tmp").appendingPathComponent(name))
    }

    func test<L>(commands: [[StrictString]], localizations: L.Type, withDependency: Bool = false, overwriteSpecificationInsteadOfFailing: Bool, file: StaticString = #file, line: UInt = #line) where L : InputLocalization {
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

                #if os(Linux)
                try Shell.default.run(command: ["cp", "\u{2D}r", Shell.quote(beforeLocation.path), Shell.quote(location.path)])
                #else
                try FileManager.default.copy(beforeLocation, to: location)
                #endif
                defer { try? FileManager.default.removeItem(at: location) }

                try FileManager.default.do(in: location) {
                    #if !os(Linux)
                    // [_Workaround: Until Xcode management is testable._]
                    _ = try? Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"])
                    #endif
                    _ = try? Shell.default.run(command: ["git", "init"])
                    _ = try? FileManager.default.copy(repositoryRoot.appendingPathComponent(".gitignore"), to: location.appendingPathComponent(".gitignore"))

                    for command in commands {
                        print(StrictString("$ workspace ") + command.joined(separator: " "))
                        let specificationName: StrictString = "Default (" + command.joined(separator: " ") + ")"

                        // Special handling of commands with platform differences
                        if ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil,
                            command == ["test"] {
                            // Phases skipped within Xcode due to bugged reroute.

                            do {
                                try Workspace.command.execute(with: command)
                            } catch {
                                XCTFail("\(error)")
                            }
                        }

                        // General commands
                        func postprocess(_ output: inout String) {

                            let any: RepetitionPattern<Unicode.Scalar> = RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy)

                            // Temporary directory varies.
                            output.scalars.replaceMatches(for: "`..".scalars, with: "`".scalars)
                            output.scalars.replaceMatches(for: "/..".scalars, with: "".scalars)
                            output.scalars.replaceMatches(for: FileManager.default.url(in: .temporary, at: "File").deletingLastPathComponent().path.scalars, with: "[Temporary]".scalars)
                            output.scalars.replaceMatches(for: "/private/tmp".scalars, with: "[Temporary]".scalars)

                            // Swift test times vary.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swift test".scalars),
                                any,
                                LiteralPattern("\n\n".scalars),
                                ]), with: "[$ swift test...]\n\n".scalars)

                            // Xcode order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ xcodebuild".scalars),
                                any,
                                LiteralPattern("\n\n".scalars),
                                ]), with: "[$ xcodebuild...]\n\n".scalars)

                            // SwiftLint order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swiftlint".scalars),
                                any,
                                LiteralPattern("\n\n".scalars),
                                ]), with: "[$ swiftlint...]\n\n".scalars)
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swiftlint".scalars),
                                any,
                                LiteralPattern("\n0".scalars),
                                ]), with: "[$ swiftlint...]\n0".scalars)
                        }

                        testCommand(Workspace.command, with: command, localizations: localizations, uniqueTestName: specificationName, postprocess: postprocess, overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing, file: file, line: line)
                    }

                    #if !os(Linux)
                    // [_Workaround: Jazzy issues._]
                    if location.lastPathComponent == "UnicodeSource" {
                        let index = try String(from: location.appendingPathComponent("docs/\(location.lastPathComponent)/index.html"))
                        XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")

                        if location.lastPathComponent == "UnicodeSource" {
                            let page = try String(from: location.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                            XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                        }
                    }
                    #endif
                }
            }
        } catch {
            XCTFail("\(error)")
        }
    }
}
