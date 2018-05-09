
import SDGLogic
import GeneralTestImports

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
        self.init(at: FileManager.default.url(in: .temporary, at: name))
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
                let resultLocation = PackageRepository.afterDirectory(for: location.lastPathComponent)
                
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
                    
                    for command in commands {
                        let specificationName: StrictString = "Default (" + command.joined(separator: " ") + ")"
                        
                        func postprocess(_ output: inout String) {
                            
                            // Platform differences.
                            let any: RepetitionPattern<Unicode.Scalar> = RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy)
                            output.scalars.replaceMatches(for: CompositePattern([
                                LiteralPattern("[_Begin Xcode Exemption_]".scalars),
                                any,
                                LiteralPattern("[_End Xcode Exemption_]".scalars),
                                ]), with: "[Different from Xcode]".scalars)
                        }
                        
                        testCommand(Workspace.command, with: command, localizations: localizations, uniqueTestName: specificationName, postprocess: postprocess, overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing, file: file, line: line)
                    }
                }
            }
        } catch {
            XCTFail("\(error)")
        }
    }
}

func testOnMockProjects() {
    
    /*do {
        for project in try FileManager.default.contentsOfDirectory(at: beforeDirectory, includingPropertiesForKeys: nil, options: [])
            where project.lastPathComponent ≠ ".DS_Store" {
                try autoreleasepool {
                    
                    try FileManager.default.do(in: resultLocation) {
                        LocalizationSetting(orderOfPrecedence: ["en\u{2D}CA"]).do {
                            
                            var output: StrictString = ""
                            
                            for command in commands {
                                autoreleasepool {
                                    output += "\n$ workspace " + command.joined(separator: " ") + "\n"
                                    let execute = { output += try Workspace.command.execute(with: command + ["•no‐colour"]) }
                                    if expectedToFail {
                                        do {
                                            try execute()
                                        } catch let error as Command.Error {
                                            output += StrictString("\n\(error)")
                                        } catch let error {
                                            XCTFail("Unexpected error: \(error)")
                                        }
                                        
                                    } else {
                                        do {
                                            try execute()
                                        } catch {
                                            XCTFail("\(error)")
                                        }
                                    }
                                }
                            }
                            
                            #if !os(Linux)
                            do {
                                
                                if project.lastPathComponent == "UnicodeSource" {
                                    let index = try String(from: resultLocation.appendingPathComponent("docs/\(project.lastPathComponent)/index.html"))
                                    XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")
                                    
                                    if project.lastPathComponent == "UnicodeSource" {
                                        let page = try String(from: resultLocation.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                                        XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                                    }
                                }
                            } catch {
                                XCTFail("\(error)")
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
                            
                            do {
                                try output.save(to: outputLocation)
                            } catch {
                                XCTFail("\(error)")
                            }
                            checkForDifferences(in: "output", at: outputLocation, for: project)
                        }
                    }
                }
        }
    } catch {
        XCTFail("\(error)")
    }*/
}
