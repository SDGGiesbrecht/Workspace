/*
 MockProject.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
@testable import WSInterface
import WSGeneralTestImports

import SDGExternalProcess
import SDGWeb

import WSProject

extension PackageRepository {

    private static let mockProjectsDirectory = repositoryRoot.appendingPathComponent("Tests/Mock Projects")
    internal static func beforeDirectory(for mockProject: String) -> URL {
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

    func test<L>(
        commands: [[StrictString]],
        configuration: WorkspaceConfiguration = WorkspaceConfiguration(),
        sdg: Bool = false,
        localizations: L.Type,
        withDependency: Bool = false,
        withCustomTask: Bool = false,
        overwriteSpecificationInsteadOfFailing: Bool,
        file: StaticString = #file,
        line: UInt = #line) where L : InputLocalization {

        do {
            try autoreleasepool {
                let developer = URL(fileURLWithPath: "/tmp/Developer")
                try? FileManager.default.removeItem(at: developer)
                defer { try? FileManager.default.removeItem(at: developer) }
                if withDependency ∨ withCustomTask {

                    let dependency = developer.appendingPathComponent("Dependency")
                    try FileManager.default.do(in: dependency) {
                        var initialize = ["swift", "package", "init"]
                        if withCustomTask {
                            initialize += ["\u{2D}\u{2D}type", "executable"]
                        }
                        _ = try Shell.default.run(command: initialize).get()
                        if withCustomTask {
                            try "import Foundation\nprint(\u{22}Hello, world!\u{22})\nif ProcessInfo.processInfo.arguments.count > 1 {\n    exit(1)\n}".save(to: dependency.appendingPathComponent("Sources/Dependency/main.swift"))
                        }
                        _ = try Shell.default.run(command: ["git", "init"]).get()
                        _ = try Shell.default.run(command: ["git", "add", "."]).get()
                        _ = try Shell.default.run(command: ["git", "commit", "\u{2D}m", "Initialized."]).get()
                        _ = try Shell.default.run(command: ["git", "tag", "1.0.0"]).get()
                    }
                }
                let beforeLocation = PackageRepository.beforeDirectory(for: location.lastPathComponent)

                // Simulators are not available to all CI jobs and must be tested separately.
                setenv("SIMULATOR_UNAVAILABLE_FOR_TESTING", "YES", 1 /* overwrite */)
                defer {
                    unsetenv("SIMULATOR_UNAVAILABLE_FOR_TESTING")
                }
                _isDuringSpecificationTest = true

                try? FileManager.default.removeItem(at: location)
                #if os(Linux)
                try Shell.default.run(command: ["cp", "\u{2D}r", Shell.quote(beforeLocation.path), Shell.quote(location.path)])
                #else
                try FileManager.default.copy(beforeLocation, to: location)
                #endif
                defer { try? FileManager.default.removeItem(at: location) }

                try FileManager.default.do(in: location) {
                    Shell.default.run(command: ["git", "init"])
                    let gitIgnore = location.appendingPathComponent(".gitignore")
                    if (try? gitIgnore.checkResourceIsReachable()) ≠ true {
                        _ = try? FileManager.default.copy(repositoryRoot.appendingPathComponent(".gitignore"), to: gitIgnore)
                    }

                    WorkspaceContext.current = try configurationContext()
                    if sdg {
                        configuration._applySDGOverrides()
                        configuration._validateSDGStandards()
                    }
                    WorkspaceConfiguration.queue(mock: configuration)
                    defer { _ = try? self.configuration(output: Command.Output.mock ) } // Dequeue even if unused.
                    resetConfigurationCache(debugReason: "new test")

                    for command in commands {
                        FileType.resetUnsupportedFileTypes()

                        if ProcessInfo.isInContinuousIntegration {
                            // Travis CI needs periodic output of some sort; otherwise it assumes the tests have stalled.
                            Shell.default.run(command: ["echo", "Tests continuing...", ">", "/dev/tty"])
                        }

                        print(StrictString("$ workspace ") + command.joined(separator: " "))
                        let specificationName: StrictString = "\(location.lastPathComponent) (\(command.joined(separator: " ")))"

                        // Special handling of commands with platform differences
                        func requireSuccess() {
                            for localization in L.allCases {
                                LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                                    do {
                                        _ = try Workspace.command.execute(with: command).get()
                                    } catch {
                                        XCTFail("\(error)", file: file, line: line)
                                    }
                                }
                            }
                        }
                        func expectFailure() {
                            for localization in L.allCases {
                                LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                                    do {
                                        var output = try Workspace.command.execute(with: command).get()
                                        // Reset cache to resurface compiler warnings.
                                        try? FileManager.default.removeItem(
                                            at: location.appendingPathComponent(".build"))
                                        output = try Workspace.command.execute(with: command).get()
                                        XCTFail(String(output), file: file, line: line)
                                    } catch {
                                        // Expected.
                                    }
                                }
                            }
                        }

                        #if os(Linux)
                        if command == ["refresh", "scripts"]
                            ∨ command == ["auffrischen", "skripte"]
                            ∨ command == ["validate", "build"]
                            ∨ command == ["prüfen", "erstellung"]
                            ∨ command == ["test"]
                            ∨ command == ["testen"] {
                            // Differing task set on Linux.
                            if location.lastPathComponent ∈ Set(["BrokenTests", "FailingTests", "NurDeutsch"]) {
                                expectFailure()
                            } else {
                                requireSuccess()
                            }
                            continue
                        }
                        if command == ["validate", "build", "•job", "macos"] {
                            // Invalid on Linux
                            expectFailure()
                            continue
                        }
                        // Differing task sets on Linux.
                        if (command == ["refresh"] ∧ location.lastPathComponent ∈ Set(["AllTasks", "CustomTasks"]))
                            ∨ (command == ["validate"] ∧ location.lastPathComponent ∈ Set(["AllDisabled", "CustomTasks", "SDGLibrary"]))
                            ∨ (command == ["validate", "test‐coverage"] ∧ location.lastPathComponent ∈ Set(["Default", "SDGLibrary", "SDGTool"]))
                            ∨ (command == ["prüfen", "testabdeckung"] ∧ location.lastPathComponent ∈ Set(["Deutsch"]))
                            ∨ (command == ["validate", "•job", "macos"] ∧ location.lastPathComponent ∈ Set(["Default"])){
                            requireSuccess()
                            continue
                        } else if (command == ["validate"] ∧ location.lastPathComponent ∈ Set(["AllTasks", "Default", "FailingCustomValidation"]))
                            ∨ (command == ["validate", "test‐coverage"] ∧ location.lastPathComponent ∈ Set(["FailingTests"])) {
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
                            output.scalars.replaceMatches(for: "/private/tmp".scalars, with: "[Temporary]".scalars)
                            output.scalars.replaceMatches(for: "/tmp".scalars, with: "[Temporary]".scalars)

                            // Find hotkey varies.
                            output.scalars.replaceMatches(for: "⌘F".scalars, with: "[⌘F]".scalars)
                            output.scalars.replaceMatches(for: "Ctrl + F".scalars, with: "[⌘F]".scalars)
                            output.scalars.replaceMatches(for: "Strg + F".scalars, with: "[⌘F]".scalars)

                            // Git paths vary.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ git ".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ git...]\n\n".scalars)

                            // Swift order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swift ".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ swift...]\n\n".scalars)
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ swift ".scalars),
                                any,
                                LiteralPattern("\n0".scalars)
                                ]), with: "[$ swift...]\n0".scalars)

                            // Xcode order varies.
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("$ xcodebuild".scalars),
                                any,
                                LiteralPattern("\n\n".scalars)
                                ]), with: "[$ xcodebuild...]\n\n".scalars)

                            if command == ["validate"] ∨ command.hasPrefix(["validate", "•job"]) {
                                // Refreshment occurs elswhere in continuous integration.
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\nValidating “".scalars)
                                    ]), with: "\n[Refreshing ...]\n\nValidating “".scalars)
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\nValidating ‘".scalars)
                                    ]), with: "\n[Refreshing ...]\n\nValidating ‘".scalars)
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\n„AllDisabled“ wird geprüft".scalars)
                                    ]), with: "\n[... wird aufgefrisct ...]\n\n„AllDisabled“ wird geprüft".scalars)
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\n„CustomTasks“ wird geprüft".scalars)
                                    ]), with: "\n[... wird aufgefrisct ...]\n\n„CustomTasks“ wird geprüft".scalars)
                                output.scalars.replaceMatches(for: CompositePattern([
                                    LiteralPattern("\n".scalars),
                                    any,
                                    LiteralPattern("\n„FailingCustomValidation“ wird geprüft".scalars)
                                    ]), with: "\n[... wird aufgefrisct ...]\n\n„FailingCustomValidation“ wird geprüft".scalars)
                            }
                        }

                        testCommand(Workspace.command, with: command, localizations: localizations, uniqueTestName: specificationName, postprocess: postprocess, overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing, file: file, line: line)
                    }

                    // #workaround(SDGWeb 1.0.2, Maintain toggle until SDGWeb is upgraded and everything passes.)
                    let runExtraTests = { return true }()

                    let documentationDirectory = location.appendingPathComponent("docs")
                    if (try? documentationDirectory.checkResourceIsReachable()) == true,
                        runExtraTests {
                        var warnings = Site<InterfaceLocalization>.validate(site: documentationDirectory)

                        // #workaround(SDGWeb 1.0.2, Mishandled by SDGWeb.)
                        warnings = warnings.mapValues { warnings in
                            return warnings.filter { warning in
                                if case .syntaxError(let syntax) = warning {
                                    let description = syntax.presentableDescription()
                                    if description.contains("An attribute is unknown.\n\u{2D}\u{2D}")
                                        ∨ description.contains("An attribute is unknown.\nonmouseenter")
                                        ∨ description.contains("An attribute is unknown.\nonmouseleave")
                                        ∨ description.contains("A tag is empty.\n<>")
                                        ∨ description.contains("A greater‐than sign has no corresponding less‐than sign.")
                                        ∨ description.contains("An attribute is unknown.\nclass=\u{22}punctuation\u{22}>\u{2D}") {
                                        return false
                                    }
                                }
                                return true
                            }
                        }
                        warnings = warnings.filter({ (_, warnings) in
                            return ¬warnings.isEmpty
                        })

                        if ¬warnings.isEmpty {
                            let files = warnings.keys.sorted()
                            let warningList = files.map({ url in
                                var fileMessage = url.path(relativeTo: documentationDirectory)
                                let errors = warnings[url]!
                                fileMessage.append(contentsOf: errors.map({ error in
                                    return error.localizedDescription
                                }).joined(separator: "\n"))
                                return fileMessage
                            }).joined(separator: "\n\n")
                            XCTFail(warningList, file: file, line: line)
                        }
                    }

                    /// Commit hashes vary.
                    try? FileManager.default.removeItem(at: location.appendingPathComponent("Package.resolved"))
                    /// Manifest updates only on macOS.
                    try? FileManager.default.removeItem(at: location.appendingPathComponent("Tests/LinuxMain.swift"))
                    for manifest in ((try? FileManager.default.deepFileEnumeration(in: location)) ?? [])
                        where manifest.lastPathComponent == "XCTestManifests.swift" {
                            try? FileManager.default.removeItem(at: manifest)
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
