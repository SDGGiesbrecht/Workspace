
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
