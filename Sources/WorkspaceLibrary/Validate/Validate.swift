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

import Foundation

import SDGCaching

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
    // Running unit tests...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    func printTestHeader(buildOnly: Bool, operatingSystemName: String) {
        
        let verbPhrase = buildOnly ? "Verifying build for" : "Running unit tests on"
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["\(verbPhrase) \(operatingSystemName)..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    }
    
    func runUnitTests(buildOnly: Bool, operatingSystemName: String, script: [String]) {
        
        if bash(script).succeeded {
            let phrase = buildOnly ? "Build succeeds for" : "Unit tests succeed on"
            individualSuccess(message: "\(phrase) \(operatingSystemName).")
        } else {
            let phrase = buildOnly ? "Build fails for" : "Unit tests fail on"
            individualFailure(message: "\(phrase) \(operatingSystemName). (See above for details.)")
        }
    }
    
    func runUnitTestsInSwiftPackageManager(operatingSystemName: String) {
        printTestHeader(buildOnly: false, operatingSystemName: operatingSystemName)
        runUnitTests(buildOnly: false, operatingSystemName: operatingSystemName, script: ["swift", "test"])
    }
    
    if Environment.operatingSystem == .macOS ∧ Configuration.supportMacOS {
        
        // macOS
        
        runUnitTestsInSwiftPackageManager(operatingSystemName: "macOS")
    }
    
    
    
    if Environment.operatingSystem == .linux {
        
        // Linux
        
        runUnitTestsInSwiftPackageManager(operatingSystemName: "Linux")
    }
    
    if Environment.operatingSystem == .macOS {
        
        var deviceList: [String: String]?
        
        func runUnitTestsInXcode(buildOnly: Bool, operatingSystemName: String, deviceKey: String) {
            
            printTestHeader(buildOnly: buildOnly, operatingSystemName: operatingSystemName)
            
            let devices = cachedResult(cache: &deviceList) {
                () -> [String: String] in
                
                print(["Searching for simulator..."], in: nil, spaced: true)
                
                guard let deviceManifest = bash(["instruments", "-s", "devices"]).output else {
                    fatalError(message: ["Failed to get list of simulators."])
                }
                
                var result: [String: String] = [:]
                for entry in deviceManifest.lines {
                    
                    if let identifier = entry.contents(of: ("[", "]")) {
                        if entry.contains("+") {
                            if let name = entry.contents(of: ("+ ", " (")) {
                                result[name] = identifier
                            }
                        } else {
                            if let nameEnd = entry.range(of: " (")?.lowerBound {
                                let name = entry.substring(to: nameEnd)
                                result[name] = identifier
                            }
                        }
                    }
                }
                return result
            }
            
            guard let deviceID = devices[deviceKey] else {
                fatalError(message: [
                    "Unable to find device:",
                    "",
                    deviceKey,
                    ])
            }
            
            if ¬buildOnly {
                // Manually launch the simulator to avoid timeouts.
                let _ = bash(["killall", "Simulator"])
                let _ = bash(["open", "-b", "com.apple.iphonesimulator", "--args", "-CurrentDeviceUDID", deviceID])
                
                var decasecondsToWait: Int?
                switch operatingSystemName {
                case "iOS":
                    decasecondsToWait = 12
                case "tvOS":
                    decasecondsToWait = 6
                default:
                    break
                }
                
                if let decaseconds = decasecondsToWait {
                    print(["Giving the simulator time to boot..."])
                    for decasecond in (1 ... decaseconds).reversed() {
                        print(["\(decasecond)0 s..."])
                        sleep(10)
                    }
                }
            }
            
            return runUnitTests(buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: [
                "xcodebuild", (buildOnly ? "build" : "test"),
                "-scheme", Configuration.projectName,
                "-destination", "id=\(deviceID)"
                ])
        }
        
        if Configuration.supportIOS {
            
            // iOS
            
            runUnitTestsInXcode(buildOnly: false, operatingSystemName: "iOS", deviceKey: "iPhone 7")
        }
        
        if Configuration.supportWatchOS {
            
            // watchOS
            
            runUnitTestsInXcode(buildOnly: true, operatingSystemName: "watchOS", deviceKey: "Apple Watch Series 2 - 38mm")
        }
        
        if Configuration.supportTVOS {
            
            // tvOS
            
            runUnitTestsInXcode(buildOnly: false, operatingSystemName: "tvOS", deviceKey: "Apple TV 1080p")
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
