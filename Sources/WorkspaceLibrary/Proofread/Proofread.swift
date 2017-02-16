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
    
    var overallSuccess = true
    
    for path in Repository.sourceFiles {
        let file = require() { try File(at: path) }
        
        for rule in rules {
            if ¬Configuration.disableProofreadingRules.contains(rule.name) {
                rule.check(file: file, status: &overallSuccess)
            }
        }
    }
    
    if let swiftLintResult = runThirdPartyTool(command: ["swiftlint", "lint", "--strict"], dropOutput: true) {
        if ¬swiftLintResult.succeeded {
            overallSuccess = false
        }
    }
    
    if shouldExit {
        exit(ExitCode.succeeded)
    }
    
    return overallSuccess
}
