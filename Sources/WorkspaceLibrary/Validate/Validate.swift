// Validate.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import SDGLogic

func runValidate(andExit shouldExit: Bool) {
    
    var overallSuccess = true
    
    var summary: [(result: Bool, message: String)] = []
    func individualSuccess(message: String) {
        summary.append((result: true, message: message))
    }
    func individualFailure(message: String) {
        summary.append((result: false, message: message))
        overallSuccess = false
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Refreshing
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    Command.refresh.run(andExit: false)
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Validating \(Configuration.projectName)..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Running unit tests..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    if Environment.operatingSystem == .macOS ∧ Configuration.supportMacOS {
        
        print(["Running unit tests on macOS..."], in: nil, spaced: true)
        
        if bash(["swift", "test"]).succeeded {
            individualSuccess(message: "Unit tests succeed on macOS.")
        } else {
            individualFailure(message: "Unit tests fail on macOS. (See above for details.)")
        }
    }
    
    if Environment.operatingSystem == .linux {
        
        print(["Running unit tests on Linux..."], in: nil, spaced: true)
        
        if bash(["swift", "test"]).succeeded {
            individualSuccess(message: "Unit tests succeed on Linux.")
        } else {
            individualFailure(message: "Unit tests fail on Linux. (See above for details.)")
        }
    }
    
    if Environment.operatingSystem == .macOS {
        
        if Configuration.supportIOS {
            
            print(["Running unit tests on iOS..."], in: nil, spaced: true)
            
            if bash(["xcodebuild", "test", "-destination", "'platform=iOS Simulator,name=iPhone 7'"]).succeeded {
                individualSuccess(message: "Unit tests succeed on iOS.")
            } else {
                individualFailure(message: "Unit tests fail on iOS. (See above for details.)")
            }
        }
        
        // watchOS does not support unit testing.
        
        if Configuration.supportTVOS {
            
            print(["Running unit tests on tvOS..."], in: nil, spaced: true)
            
            if bash(["xcodebuild", "test", "-destination", "'platform=tvOS Simulator'"]).succeeded {
                individualSuccess(message: "Unit tests succeed on tvOS.")
            } else {
                individualFailure(message: "Unit tests fail on tvOS. (See above for details.)")
            }
        }
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Summary"])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    for (result, message) in summary {
        if result {
            print(["✓ " + message], in: .green)
        } else {
            print(["✗ " + message], in: .red)
        }
    }
    
    if shouldExit {
        if overallSuccess {
            succeed(message: ["It looks like this is ready for a pull request."])
        } else {
            failTests(message: ["It looks like there are a few things left to fix."])
        }
        
    }
}
