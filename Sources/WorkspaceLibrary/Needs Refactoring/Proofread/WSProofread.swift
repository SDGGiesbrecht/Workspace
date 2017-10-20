/*
 WSProofread.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

func runProofread(andExit shouldExit: Bool) -> Bool {

    if CommandLine.arguments[1] ≠ "proofread" {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Proofreading \(Configuration.projectName)..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    }

    if CommandLine.arguments[1] == "proofread" {
        // So that SwiftLint’s trailing_whitespace doesn’t trigger.
        normalizeFiles()
    }

    // Workspace Rules

    var overallSuccess = true

    for path in Repository.sourceFiles {
        let file = require() { try File(at: path) }

        if file.fileType ≠ nil {

            var ruleSet: [Rule.Type]
            if Configuration.sdg {
                ruleSet = sdgRules
            } else {
                ruleSet = rules
            }
            ruleSet += manualWarnings as [Rule.Type]

            for rule in ruleSet where rule.name ∉ Configuration.disableProofreadingRules {
                rule.check(file: file, status: &overallSuccess)
            }

        }
    }

    // SwiftLint

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
                // Workspace
                "  \u{2D} .Test Zone"
            ]
            let disabled = Configuration.disableProofreadingRules.sorted().map({ "  \u{2D} " + $0 })
            if ¬disabled.isEmpty {
                lines += [
                    "disabled_rules:",
                    join(lines: disabled)
                ]
            }

            file.contents = join(lines: lines)
            require() { try file.write() }
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
}
