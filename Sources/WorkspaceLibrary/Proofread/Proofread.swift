/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

func runProofread(andExit shouldExit: Bool) -> Bool {
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Proofreading \(Configuration.projectName)..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    var overallSuccess = true
    
    if shouldExit {
        if overallSuccess {
            succeed(message: ["This code passes proofreading."])
        } else {
            failTests(message: ["It looks like there are a few things left to fix."])
        }
    }
    
    return overallSuccess
}
