
import SDGCornerstone
import SDGCommandLine

enum Proofreading {

    static func proofread(project: PackageRepository, reporter: ProofreadingReporter, output: inout Command.Output) throws -> Bool {
        let status = ProofreadingStatus(reporter: reporter)

        let disabledRules: Set<StrictString> = try project.configuration.disabledProofreadingRules()
        let activeRules = (rules + manualWarnings as [Rule.Type]).filter { rule in
            for name in InterfaceLocalization.cases.lazy.map({ rule.name.resolved(for: $0) }) where  name ∈ disabledRules {
                return false
            }
            return true
        }

        for url in try project.sourceFiles(output: &output)
            where (try? FileType(url: url)) ≠ nil
                ∧ (try? FileType(url: url)) ≠ .xcodeProject {
            let file = try TextFile(alreadyAt: url)

            for rule in activeRules {
                rule.check(file: file, status: status, output: &output)
            }
        }

        proofreadWithSwiftLint(project: project, status: status, output: &output)

        return status.passing
    }

    private static func proofreadWithSwiftLint(project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {

        // [_Warning: Not finished._]

        /*

        if Environment.operatingSystem == .macOS {
            // [_Workaround: SwiftLint fails to build with the Swift Package Manager. Using homebrew instead. (swiftlint version 0.16.1)_]

            let swiftLintConfigurationPath = RelativePath(".swiftlint.yml")
            var manualSwiftLintConfiguration = false
            if Repository.sourceFiles.contains(swiftLintConfigurationPath) {
                manualSwiftLintConfiguration = true
            } else {
                var file = File(possiblyAt: swiftLintConfigurationPath)

                var lines = [
                    "excluded:",
                    // Swift Package Manager
                    "  \u{2D} .build",
                    "  \u{2D} Packages",
                    // Workspace Project
                    "  \u{2D} \u{22}Tests/Mock Projects\u{22}"
                ]
                let disabled = Configuration.disableProofreadingRules.sorted().map({ "  \u{2D} " + $0 })
                if ¬disabled.isEmpty {
                    lines += [
                        "disabled_rules:",
                        disabled.joinAsLines()
                    ]
                }

                file.contents = lines.joinAsLines()
                require() { try file.write(output: &output) }
            }

            if let swiftLintResult = runThirdPartyTool(
                name: "SwiftLint",
                repositoryURL: "https://github.com/realm/SwiftLint",
                versionCheck: ["swiftlint", "version"],
                continuousIntegrationSetUp: [
                    ["echo", "SwiftLint already updated."]
                ],
                command: ["swiftlint", "lint", "\u{2D}\u{2D}strict"],
                updateInstructions: [
                    "Command to install Homebrew (https://brew.sh):",
                    "/usr/bin/ruby -e \u{22}$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\u{22}",
                    "Command to install SwiftLint:",
                    "brew install swiftlint",
                    "Command to update SwiftLint:",
                    "brew upgrade swiftlint"
                ],
                dropOutput: true) {

                if ¬swiftLintResult.succeeded {
                    overallSuccess = false
                }
            }

            if ¬manualSwiftLintConfiguration {
                try? Repository.delete(swiftLintConfigurationPath)
            }

        }

        // End

        if shouldExit {
            exit(ExitCode.succeeded)
        }

        return overallSuccess
 */
    }
}
