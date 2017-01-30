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
    
    func runUnitTests(enabledInConfiguration: Bool, buildOnly: Bool, operatingSystemName: String, script: [String]) {
        
        if enabledInConfiguration {
            
            let verbPhrase = buildOnly ? "Verifying build for" : "Running unit tests on"
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["\(verbPhrase) \(operatingSystemName)..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            
            if bash(script).succeeded {
                let phrase = buildOnly ? "Build succeeds for" : "Unit tests succeed on"
                individualSuccess(message: "\(phrase) \(operatingSystemName).")
            } else {
                let phrase = buildOnly ? "Build fails for" : "Unit tests fail on"
                individualFailure(message: "\(phrase) \(operatingSystemName). (See above for details.)")
            }
        }
    }
    
    func runUnitTestsInSwiftPackageManager(enabledInConfiguration: Bool, operatingSystemName: String) {
        runUnitTests(enabledInConfiguration: enabledInConfiguration, buildOnly: false, operatingSystemName: operatingSystemName, script: ["swift", "test"])
    }
    
    runUnitTestsInSwiftPackageManager(enabledInConfiguration: Environment.operatingSystem == .macOS ∧ Configuration.supportMacOS, operatingSystemName: "macOS")
    runUnitTestsInSwiftPackageManager(enabledInConfiguration: Environment.operatingSystem == .linux, operatingSystemName: "Linux")
    
    if Environment.operatingSystem == .macOS {
        
        var deviceList: [String: String]?
        
        func runUnitTestsInXcode(enabledInConfiguration: Bool, buildOnly: Bool, operatingSystemName: String, deviceKey: String) {
            
            if enabledInConfiguration ∧ ¬buildOnly {
                // Manually launch the simulator to avoid timeouts.
                let _ = bash(["open", "-b", "com.apple.iphonesimulator"])
            }
            
            let devices = cachedResult(cache: &deviceList) {
                () -> [String: String] in
                
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
            
            return runUnitTests(enabledInConfiguration: enabledInConfiguration, buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: [
                "xcodebuild", (buildOnly ? "build" : "test"),
                "-scheme", Configuration.projectName,
                "-destination", "id=\(deviceID)"
                ])
        }
        
        runUnitTestsInXcode(enabledInConfiguration: Configuration.supportIOS, buildOnly: false, operatingSystemName: "iOS", deviceKey: "iPhone 7")
        runUnitTestsInXcode(enabledInConfiguration: Configuration.supportWatchOS, buildOnly: true, operatingSystemName: "watchOS", deviceKey: "Apple Watch Series 2 - 38mm")
        //runUnitTestsInXcode(enabledInConfiguration: Configuration.supportTVOS, buildOnly: false, operatingSystemName: "tvOS", platformKey: "tvOS", deviceKey: "Apple TV 1080p")
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
