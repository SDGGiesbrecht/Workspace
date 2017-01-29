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
    
    if Environment.operatingSystem == .macOS ∧ Configuration.supportMacOS {
        
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Running unit tests on macOS..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        if bash(["swift", "test"]).succeeded {
            individualSuccess(message: "Unit tests succeed on macOS.")
        } else {
            individualFailure(message: "Unit tests fail on macOS. (See above for details.)")
        }
    }
    
    if Environment.operatingSystem == .linux {
        
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Running unit tests on Linux..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        if bash(["swift", "test"]).succeeded {
            individualSuccess(message: "Unit tests succeed on Linux.")
        } else {
            individualFailure(message: "Unit tests fail on Linux. (See above for details.)")
        }
    }
    
    if Environment.operatingSystem == .macOS {
        
        func xcodebuildArguments(platform: String, name: String, test: Bool = true) -> [String] {
            let arguments: [String] = [
                "xcodebuild", (test ? "test" : "build"),
                "-scheme", Configuration.projectName,
                "-destination", "platform=\(platform) Simulator,name=\(name)"
            ]
            print(join(lines: arguments))
            return arguments
        }
        
        if Configuration.supportIOS {
            
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["Running unit tests on iOS..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            
            if bash(xcodebuildArguments(platform: "iOS", name: "iPhone 7")).succeeded {
                individualSuccess(message: "Unit tests succeed on iOS.")
            } else {
                individualFailure(message: "Unit tests fail on iOS. (See above for details.)")
            }
        }
        
        if Configuration.supportWatchOS {
            
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["Verifying build on watchOS..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            
            if bash(xcodebuildArguments(platform: "watchOS", name: "Apple Watch Series 2 - 38mm", test: false)).succeeded {
                individualSuccess(message: "Build succeeds on watchOS.")
            } else {
                individualFailure(message: "Build fails on watchOS. (See above for details.)")
            }
        }
        
        if Configuration.supportTVOS {
            
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["Running unit tests on tvOS..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            
            if bash(xcodebuildArguments(platform: "tvOS", name: "Apple TV 1080p")).succeeded {
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
