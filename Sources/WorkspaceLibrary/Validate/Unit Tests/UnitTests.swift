/*
 UnitTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct UnitTests {

    static func test(individualSuccess: @escaping (String) -> Void, individualFailure: @escaping (String) -> Void) {

        Xcode.temporarilyDisableProofreading()
        defer {
            Xcode.reEnableProofreading()
        }

        func printTestHeader(buildOnly: Bool, operatingSystemName: String, buildToolName: String? = nil) {

            let verbPhrase = buildOnly ? "Verifying build for" : "Running unit tests on"
            var configuration = operatingSystemName
            if let tool = buildToolName {
                configuration += " with \(tool)"
            }
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["\(verbPhrase) \(configuration)..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        }

        func runUnitTests(buildOnly: Bool, operatingSystemName: String, script: [String], buildToolName: String? = nil) {

            var configuration = operatingSystemName
            if let tool = buildToolName {
                configuration += " with \(tool)"
            }

            do {
                let log = try Shell.default.run(command: script)

                let phrase = buildOnly ? "Build succeeds for" : "Unit tests succeed on"
                individualSuccess("\(phrase) \(configuration).")

                if Configuration.prohibitCompilerWarnings {
                    if ¬log.contains(" warning: ") {
                        individualSuccess("There are no compiler warnings for \(configuration).")
                    } else {
                        individualFailure("There are compiler warnings for \(configuration). (See above for details.)")
                    }
                }
            } catch {
                let phrase = buildOnly ? "Build fails for" : "Unit tests fail on"
                individualFailure("\(phrase) \(configuration). (See above for details.)")
            }
        }

        func runUnitTestsInSwiftPackageManager(operatingSystemName: String, buildToolName: String? = nil) {
            printTestHeader(buildOnly: false, operatingSystemName: operatingSystemName, buildToolName: buildToolName)
            runUnitTests(buildOnly: false, operatingSystemName: operatingSystemName, script: ["swift", "test"], buildToolName: buildToolName)
        }

        var deviceList: [String: String]?

        func runUnitTestsInXcode(buildOnly: Bool, operatingSystem: OperatingSystem, sdk: String, simulatorSDK: String? = nil, deviceKey: String?, buildToolName: String? = nil) {
            let operatingSystemName = "\(operatingSystem)"

            var buildOnly = buildOnly
            if Configuration.skipSimulators ∧ operatingSystem ≠ .macOS {
                buildOnly = true
            }

            printTestHeader(buildOnly: buildOnly, operatingSystemName: operatingSystemName, buildToolName: buildToolName)

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

                let devices = cached(in: &deviceList) {
                    () -> [String: String] in

                    print(["Searching for simulator..."], in: nil, spaced: true)

                    guard let deviceManifest = try? Shell.default.run(command: ["instruments", "\u{2D}s", "devices"]) else {
                        fatalError(message: ["Failed to get list of simulators."])
                    }

                    var list: [String: (identifier: String, version: Version)] = [:]
                    for entry in deviceManifest.lines.map({ String($0.line) }) {

                        if let identifierSubSequence = entry.scalars.firstNestingLevel(startingWith: "[".scalars, endingWith: "]".scalars)?.contents.contents {
                            let identifier = String(identifierSubSequence)

                            var possibleName: String?
                            var possibleRemainder: String?
                            if entry.contains("+") {
                                if let nameRange = entry.scalars.firstNestingLevel(startingWith: "+ ".scalars, endingWith: " (".scalars)?.contents.range.clusters(in: entry.clusters) {
                                    possibleName = String(entry[nameRange])
                                    possibleRemainder = String(entry[nameRange.upperBound...])
                                }
                            } else {
                                if let nameEnd = entry.range(of: " (")?.lowerBound {
                                    possibleName = String(entry[..<nameEnd])
                                    possibleRemainder = String(entry[nameEnd...])
                                }
                            }

                            if let name = possibleName,
                                let remainder = possibleRemainder,
                                let versionString = remainder.scalars.firstNestingLevel(startingWith: "(".scalars, endingWith: ")".scalars)?.contents.contents,
                                let version = Version(String(versionString)) {

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

            // [_Workaround: The first attempt to use xcodebuild on an Xcode project generated by the Swift Package Manage hangs. This starts and kills that first hanging build opertaion. (Swift 3.1.0)_]
            _ = try? Shell(launchPath: "/bin/bash").run(command: generateScript(buildOnly: buildOnly) + ["&"], silently: true)
            sleep(10)
            _ = try? Shell.default.run(command: ["killall", "xcodebuild"], silently: true)

            let enforceCodeCoverage = ¬buildOnly ∧ Configuration.enforceCodeCoverage
            var possibleSettings: String?
            var possibleBuildDirectory: String?
            var possibleCoverageDirectory: String?
            if enforceCodeCoverage {
                guard let settings = try? Shell.default.run(command: [
                    "xcodebuild", "\u{2D}showBuildSettings",
                    "\u{2D}target", Configuration.primaryXcodeTarget,
                    "\u{2D}sdk", sdk
                    ], silently: true) else {
                        fatalError(message: [
                            "Failed to detect Xcode build settings.",
                            "This may indicate a bug in Workspace."
                            ])
                }
                possibleSettings = settings

                let buildDirectoryKey = (" BUILD_DIR = ", "\n")
                guard let buildDirectorySubSequence = settings.scalars.firstNestingLevel(startingWith: buildDirectoryKey.0.scalars, endingWith: buildDirectoryKey.1.scalars)?.contents.contents else {
                    fatalError(message: [
                        "Failed to find “\(buildDirectoryKey.0)” in Xcode build settings.",
                        "This may indicate a bug in Workspace."
                        ])
                }
                let buildDirectory = String(buildDirectorySubSequence)
                possibleBuildDirectory = buildDirectory

                let irrelevantPathComponents = "Products"
                guard let irrelevantRange = buildDirectory.range(of: irrelevantPathComponents) else {
                    fatalError(message: [
                        "Expected “\(irrelevantPathComponents)” at the end of the Xcode build directory path.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                let rootPath = String(buildDirectory[..<irrelevantRange.lowerBound])
                let coverageDirectory = rootPath + "ProfileData/"
                possibleCoverageDirectory = coverageDirectory

                try? FileManager.default.removeItem(atPath: coverageDirectory)
            }

            let script = generateScript(buildOnly: buildOnly)
            runUnitTests(buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: script, buildToolName: buildToolName)

            if enforceCodeCoverage,
                let settings = possibleSettings,
                let buildDirectory = possibleBuildDirectory,
                let coverageDirectory = possibleCoverageDirectory {

                // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
                printHeader(["Checking code coverage on \(operatingSystemName)..."])
                // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

                guard let uuid = (try? FileManager.default.contentsOfDirectory(atPath: coverageDirectory))?.first else {
                    individualFailure("Code coverage information is unavailable for \(operatingSystem).")
                    return
                }
                let coverageData = coverageDirectory + uuid + "/Coverage.profdata"

                let executableLocationKey = (" EXECUTABLE_PATH = \(Xcode.primaryProductName).", "\n")
                guard let executableLocationSuffix = settings.scalars.firstNestingLevel(startingWith: executableLocationKey.0.scalars, endingWith: executableLocationKey.1.scalars)?.contents.contents else {
                    fatalError(message: [
                        "Failed to find “\(executableLocationKey.0)” in Xcode build settings.",
                        "This may indicate a bug in Workspace."
                        ])
                }
                let relativeExecutableLocation = Xcode.primaryProductName + "." + String(executableLocationSuffix)
                let directorySuffix: String
                if let simulator = simulatorSDK {
                    directorySuffix = "\u{2D}" + simulator
                } else {
                    directorySuffix = ""
                }
                let executableLocation = buildDirectory + "/Debug" + directorySuffix + "/" + relativeExecutableLocation

                guard let coverageResults = try? Shell.default.run(command: [
                    "xcrun", "llvm\u{2D}cov", "show", "\u{2D}show\u{2D}regions",
                    "\u{2D}instr\u{2D}profile", coverageData,
                    executableLocation
                    ], silently: true) else {
                        individualFailure("Code coverage information is unavailable for \(operatingSystem).")
                        return
                }

                let nullCharacters = (CharacterSet.whitespacesAndNewlines ∪ CharacterSet.decimalDigits) ∪ ["|"]

                var overallCoverageSuccess = true
                var overallIndex = coverageResults.startIndex
                let fileMarker = ".swift:"
                while let range = coverageResults.scalars.firstMatch(for: fileMarker.scalars, in: (overallIndex ..< coverageResults.endIndex).sameRange(in: coverageResults.scalars))?.range.clusters(in: coverageResults.clusters) {
                    overallIndex = range.upperBound

                    let fileRange = coverageResults.lineRange(for: range)
                    let file = String(coverageResults[fileRange])

                    let end: String.Index
                    if let next = coverageResults.scalars.firstMatch(for: fileMarker.scalars, in: (fileRange.upperBound ..< coverageResults.endIndex).sameRange(in: coverageResults.scalars))?.range.clusters(in: coverageResults.clusters) {
                        let nextFileRange = coverageResults.lineRange(for: next)
                        end = nextFileRange.lowerBound
                    } else {
                        end = coverageResults.endIndex
                    }

                    var index = overallIndex
                    while let missingRange = coverageResults.scalars.firstMatch(for: "^0".scalars, in: (index ..< end).sameRange(in: coverageResults.scalars))?.range.clusters(in: coverageResults.clusters) {
                        index = missingRange.upperBound

                        let errorLineRange = coverageResults.lineRange(for: missingRange)
                        let errorLine = String(coverageResults[errorLineRange])

                        let previous = coverageResults.index(before: errorLineRange.lowerBound)
                        let sourceLineRange = coverageResults.lineRange(for: previous ..< previous)
                        let sourceLine = String(coverageResults[sourceLineRange])

                        let untestableTokensOnPreviousLine = [
                            "[_Exempt from Code Coverage_]",
                            "assert",
                            "precondition",
                            "fatalError"
                            ] + Configuration.codeCoverageExemptionTokensForSameLine
                        var noUntestableTokens = true
                        for token in untestableTokensOnPreviousLine {
                            if sourceLine.contains(token) {
                                noUntestableTokens = false
                                break
                            }
                        }

                        let next = coverageResults.index(after: errorLineRange.upperBound)
                        let nextLineRange = coverageResults.lineRange(for: next ..< next)
                        let nextLine = String(coverageResults[nextLineRange])
                        var sourceLines = sourceLine + nextLine
                        sourceLines.unicodeScalars = String.UnicodeScalarView(sourceLines.unicodeScalars.filter({ ¬nullCharacters.contains($0) }))

                        var isExecutable = true
                        if sourceLines.hasPrefix("}}") {
                            isExecutable = false
                        }

                        let untestableTokensOnFollowingLine = [
                            "assertionFailure",
                            "preconditionFailure",
                            "fatalError",
                            "primitiveMethod",
                            "unreachable"
                            ] + Configuration.codeCoverageExemptionTokensForPreviousLine
                        if noUntestableTokens {
                            for token in untestableTokensOnFollowingLine {
                                if nextLine.contains(token) {
                                    noUntestableTokens = false
                                    break
                                }
                            }
                        }

                        if noUntestableTokens ∧ isExecutable {
                            overallCoverageSuccess = false
                            print([
                                file
                                    + sourceLine
                                    + errorLine
                                ], in: .red, spaced: true)
                        }
                    }
                }

                if overallCoverageSuccess {
                    individualSuccess("Code coverage is complete for \(operatingSystemName).")
                } else {
                    individualFailure("Code coverage is incomplete for \(operatingSystemName). (See above for details.)")
                }
            }
        }

        if Environment.shouldDoMacOSJobs {

            // macOS

            if Configuration.projectType ≠ .application {
                runUnitTestsInSwiftPackageManager(operatingSystemName: "macOS", buildToolName: "the Swift Package Manager")
            }
            runUnitTestsInXcode(buildOnly: false, operatingSystem: .macOS, sdk: "macosx", deviceKey: nil, buildToolName: "Xcode")
        }

        if Environment.shouldDoLinuxJobs {

            // Linux

            runUnitTestsInSwiftPackageManager(operatingSystemName: "Linux")
        }

        if Environment.shouldDoIOSJobs {

            // iOS

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .iOS, sdk: "iphoneos", simulatorSDK: "iphonesimulator", deviceKey: "iPhone 8")
        }

        if Environment.shouldDoWatchOSJobs {

            // watchOS

            runUnitTestsInXcode(buildOnly: true, operatingSystem: .watchOS, sdk: "watchos", deviceKey: "Apple Watch Series 2 \u{2D} 38mm")
        }

        if Environment.shouldDoTVOSJobs {

            // tvOS

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .tvOS, sdk: "appletvos", simulatorSDK: "appletvsimulator", deviceKey: "Apple TV")
        }
    }
}
