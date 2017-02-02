// Unit Tests.swift
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

struct UnitTests {
    
    static func test(individualSuccess: @escaping (String) -> (), individualFailure: @escaping (String) -> ()) {
        
        func printTestHeader(buildOnly: Bool, operatingSystemName: String) {
            
            let verbPhrase = buildOnly ? "Verifying build for" : "Running unit tests on"
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["\(verbPhrase) \(operatingSystemName)..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        }
        
        func runUnitTests(buildOnly: Bool, operatingSystemName: String, script: [String]) {
            
            if bash(script).succeeded {
                let phrase = buildOnly ? "Build succeeds for" : "Unit tests succeed on"
                individualSuccess("\(phrase) \(operatingSystemName).")
            } else {
                let phrase = buildOnly ? "Build fails for" : "Unit tests fail on"
                individualFailure("\(phrase) \(operatingSystemName). (See above for details.)")
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
            
            func runUnitTestsInXcode(buildOnly: Bool, operatingSystemName: String, sdk: String, deviceKey: String) {
                
                var buildOnly = buildOnly
                // [_Workaround: Commented for testing._]
                //if Environment.isInContinuousIntegration {
                    // [_Workaround: Travis CI cannot start the simulator this way._]
                    buildOnly = true
                //}
                
                printTestHeader(buildOnly: buildOnly, operatingSystemName: operatingSystemName)
                
                let flag: String
                let flagValue: String
                if buildOnly {
                    flag = "-sdk"
                    flagValue = sdk
                } else {
                    // Test
                    
                    let devices = cachedResult(cache: &deviceList) {
                        () -> [String: String] in
                        
                        print(["Searching for simulator..."], in: nil, spaced: true)
                        
                        guard let deviceManifest = bash(["instruments", "-s", "devices"]).output else {
                            fatalError(message: ["Failed to get list of simulators."])
                        }
                        
                        var list: [String: (identifier: String, version: Version)] = [:]
                        for entry in deviceManifest.lines {
                            
                            if let identifier = entry.contents(of: ("[", "]")) {
                                
                                var possibleName: String?
                                var possibleRemainder: String?
                                if entry.contains("+") {
                                    if let nameRange = entry.rangeOfContents(of: ("+ ", " (")) {
                                        possibleName = entry[nameRange]
                                        possibleRemainder = entry.substring(from: nameRange.upperBound)
                                    }
                                } else {
                                    if let nameEnd = entry.range(of: " (")?.lowerBound {
                                        possibleName = entry.substring(to: nameEnd)
                                        possibleRemainder = entry.substring(from: nameEnd)
                                    }
                                }
                                
                                if let name = possibleName,
                                    let remainder = possibleRemainder,
                                    let versionString = remainder.contents(of: ("(", ")")),
                                    let version = Version(versionString) {
                                    
                                    let oldVersion: Version
                                    if let existing = list[name] {
                                        oldVersion = existing.version
                                    } else {
                                        oldVersion = Version(0, 0, 0)
                                    }
                                    
                                    if version > oldVersion {
                                        list[name] = (identifier: identifier, version: version)
                                    }
                                }
                            }
                        }
                        
                        var result: [String: String] = [:]
                        for (name, information) in list {
                            result[name] = information.identifier
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
                    
                    // [_Workaround: ↓ Manually launch the simulator to avoid timeouts._]
                    
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
                    
                    // [_Workaround: ↑ Manually launch the simulator to avoid timeouts._]
                    
                    flag = "-destination"
                    flagValue = "id=\(deviceID)"
                }
                
                func generateScript(buildOnly: Bool) -> [String] {
                    return [
                        "xcodebuild", (buildOnly ? "build" : "test"),
                        "-scheme", Configuration.projectName,
                        flag, flagValue
                    ]
                }
                
                // [_Workaround: xcodebuild hangs on first attempt for iOS._]
                if operatingSystemName == "iphoneos" {
                    let _ = bash(generateScript(buildOnly: true), silent: true, triggerOnly: true)
                    sleep(10)
                }
                
                return runUnitTests(buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: generateScript(buildOnly: buildOnly))
            }
            
            if Configuration.supportIOS {
                
                // iOS
                
                // [_Workaround: xcodebuild hangs on first attempt for iOS._]
                runUnitTestsInXcode(buildOnly: false, operatingSystemName: "iOS", sdk: "iphonesimulator", deviceKey: "iPhone 7")
            }
            
            if Configuration.supportWatchOS {
                
                // watchOS
                
                runUnitTestsInXcode(buildOnly: true, operatingSystemName: "watchOS", sdk: "watchos", deviceKey: "Apple Watch Series 2 - 38mm")
            }
            
            if Configuration.supportTVOS {
                
                // tvOS
                
                runUnitTestsInXcode(buildOnly: false, operatingSystemName: "tvOS", sdk: "appletvos", deviceKey: "Apple TV 1080p")
            }
        }
    }
}
