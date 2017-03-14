/*
 UnitTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCaching

import SDGLogic

struct UnitTests {

    static func test(individualSuccess: @escaping (String) -> Void, individualFailure: @escaping (String) -> Void) {

        Xcode.temporarilyDisableProofreading()
        defer {
            Xcode.reEnableProofreading()
        }

        func printTestHeader(buildOnly: Bool, operatingSystemName: String) {

            let verbPhrase = buildOnly ? "Verifying build for" : "Running unit tests on"
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["\(verbPhrase) \(operatingSystemName)..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        }

        func runUnitTests(buildOnly: Bool, operatingSystemName: String, script: [String]) {

            let result = bash(script)

            if result.succeeded {
                if let log = result.output {
                    if ¬log.contains(" warning: ") {
                        individualSuccess("Build triggers no warnings for \(operatingSystemName).")
                    } else {
                        individualFailure("Build triggers warnings for \(operatingSystemName). (See above for details.)")
                    }
                } else {
                    fatalError(message: [
                        "No build log detected.",
                        "This may indicate a bug in Workspace."
                        ])
                }
            }

            if result.succeeded {
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

        var deviceList: [String: String]?

        func runUnitTestsInXcode(buildOnly: Bool, operatingSystem: OperatingSystem, sdk: String, deviceKey: String?) {
            let operatingSystemName = "\(operatingSystem)"

            var buildOnly = buildOnly
            if Configuration.skipSimulators ∧ operatingSystem ≠ .macOS {
                buildOnly = true
            }

            printTestHeader(buildOnly: buildOnly, operatingSystemName: operatingSystemName)

            let flag: String
            let flagValue: String
            if buildOnly ∨ operatingSystem == .macOS {
                flag = "\u{2D}sdk"
                flagValue = sdk
            } else {
                // Simulator
                guard let requiredDeviceKey = deviceKey else {
                    fatalError(message: [
                        "A device key is required for the simulator.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                let devices = cachedResult(cache: &deviceList) {
                    () -> [String: String] in

                    print(["Searching for simulator..."], in: nil, spaced: true)

                    guard let deviceManifest = bash(["instruments", "\u{2D}s", "devices"]).output else {
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

                guard let deviceID = devices[requiredDeviceKey] else {
                    fatalError(message: [
                        "Unable to find device:",
                        "",
                        requiredDeviceKey
                        ])
                }

                flag = "\u{2D}destination"
                flagValue = "id=\(deviceID)"
            }

            func generateScript(buildOnly: Bool) -> [String] {
                return [
                    "xcodebuild", (buildOnly ? "build" : "test"),
                    "\u{2D}scheme", Configuration.xcodeSchemeName,
                    flag, flagValue
                ]
            }

            // [_Workaround: The first attempt to use xcodebuild on an Xcode project generated by the Swift Package Manage hangs. This starts and kills that first hanging build opertaion. (Swift 3.0.2)_]
            let _ = bash(generateScript(buildOnly: buildOnly) + ["&"], silent: true)
            sleep(10)
            let _ = bash(["killall", "xcodebuild"], silent: true)

            let script = generateScript(buildOnly: buildOnly)
            runUnitTests(buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: script)

            if ¬buildOnly ∧ true/* Code Coverage */ {

                guard let settings = bash(script + ["\u{2D}showBuildSettings"], silent: true).output else {
                    fatalError(message: [
                        "Failed to detect Xcode build settings.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                let buildDirectoryKey = (" BUILD_DIR = ", "\n")
                guard let buildDirectory = settings.contents(of: buildDirectoryKey) else {
                    fatalError(message: [
                        "Failed to find “\(buildDirectoryKey.0)” in Xcode build settings.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                let irrelevantPathComponents = "Products"
                guard let irrelevantRange = buildDirectory.range(of: irrelevantPathComponents) else {
                    fatalError(message: [
                        "Expected “\(irrelevantPathComponents)” at the end of the Xcode build directory path.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                let rootPath = buildDirectory.substring(to: irrelevantRange.lowerBound)
                let coverageDirectory = rootPath + "Intermediates/CodeCoverage/"
                let coverageData = coverageDirectory + "Coverage.profdata"

                let executableLocationKey = (" EXECUTABLE_PATH = \(Xcode.primaryProductName).", "\n")
                guard let executableLocationSuffix = settings.contents(of: executableLocationKey) else {
                    fatalError(message: [
                        "Failed to find “\(buildDirectoryKey.0)” in Xcode build settings.",
                        "This may indicate a bug in Workspace."
                        ])
                }
                let relativeExecutableLocation = Xcode.primaryProductName + "." + executableLocationSuffix
                let executableLocation = coverageDirectory + "Products/Debug/" + relativeExecutableLocation

                print(coverageData)
                print(executableLocation)
            }
        }

        if Environment.shouldDoMacOSJobs {

            // macOS

            if true/* Code Coverage */ {
                runUnitTestsInXcode(buildOnly: false, operatingSystem: .macOS, sdk: "macosx", deviceKey: nil)
            } else {
                runUnitTestsInSwiftPackageManager(operatingSystemName: "macOS")
            }
        }

        if Environment.shouldDoLinuxJobs {

            // Linux

            runUnitTestsInSwiftPackageManager(operatingSystemName: "Linux")
        }

        if Environment.shouldDoIOSJobs {

            // iOS

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .iOS, sdk: "iphoneos", deviceKey: "iPhone 7")
        }

        if Environment.shouldDoWatchOSJobs {

            // watchOS

            runUnitTestsInXcode(buildOnly: true, operatingSystem: .watchOS, sdk: "watchos", deviceKey: "Apple Watch Series 2 \u{2D} 38mm")
        }

        if Environment.shouldDoTVOSJobs {

            // tvOS

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .tvOS, sdk: "appletvos", deviceKey: "Apple TV 1080p")
        }
    }
}
