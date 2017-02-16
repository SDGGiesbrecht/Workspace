/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

func runProofread(andExit shouldExit: Bool) -> Bool {
    
    if Command.current ≠ Command.proofread {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Proofreading \(Configuration.projectName)..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    }
    
    // Workspace Rules
    
    var overallSuccess = true
    
    for path in Repository.sourceFiles {
        let file = require() { try File(at: path) }
        
        for rule in rules {
            if ¬Configuration.disableProofreadingRules.contains(rule.name) {
                rule.check(file: file, status: &overallSuccess)
            }
        }
    }
    
    // SwiftLint
    
    if Environment.operatingSystem == .macOS {
        // [_Workaround: SwiftLint fails to build with the Swift Package Manager. Using homebrew instead. (SwiftLint 0.16.1)_]
        
        let swiftLintConfigurationPath = RelativePath(".swiftlint.yml")
        var manualSwiftLintConfiguration = false
        if Repository.sourceFiles.contains(swiftLintConfigurationPath) {
            manualSwiftLintConfiguration = true
        } else {
            var file = File(possiblyAt: swiftLintConfigurationPath)
            
            var lines = [
                "excluded",
                " - Packages",
                ]
            let disabled = Configuration.disableProofreadingRules.sorted().map({ "  - " + $0 })
            if ¬disabled.isEmpty {
                lines += [
                    "disabled_rules:",
                    join(lines: disabled)
                ]
            }
            
            file.contents = join(lines: lines)
            print(file.contents)
            require() { try file.write() }
        }
        
        if let swiftLintResult = runThirdPartyTool(
            name: "SwiftLint",
            repositoryURL: "https://github.com/realm/SwiftLint",
            tagPrefix: nil,
            versionCheck: ["swiftlint", "version"],
            continuousIntegrationSetUp: [
                ["brew", "install", "swiftlint"]
            ],
            command: ["swiftlint", "lint", "--strict"],
            updateInstructions: [
                "Command to install Homebrew (https://brew.sh):",
                "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"",
                "Command to install SwiftLint:",
                "brew install swiftlint",
                "Command to update SwiftLint:",
                "brew upgrade swiftlint",
                ],
            dropOutput: true) {
            
            if ¬swiftLintResult.succeeded {
                overallSuccess = false
            }
        }
        
        if ¬manualSwiftLintConfiguration {
            force() { try Repository.delete(swiftLintConfigurationPath) }
        }
        
    }
    
    // End
    
    if shouldExit {
        exit(ExitCode.succeeded)
    }
    
    return overallSuccess
}
