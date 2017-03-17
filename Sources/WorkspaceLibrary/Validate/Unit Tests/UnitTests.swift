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
                if Configuration.prohibitCompilerWarnings {
                    if let log = result.output {
                        if ¬log.contains(" warning: ") {
                            individualSuccess("There are no compiler warnings for \(operatingSystemName).")
                        } else {
                            individualFailure("There are compiler warnings for \(operatingSystemName). (See above for details.)")
                        }
                    } else {
                        fatalError(message: [
                            "No build log detected.",
                            "This may indicate a bug in Workspace."
                            ])
                    }
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

        func runUnitTestsInXcode(buildOnly: Bool, operatingSystem: OperatingSystem, sdk: String, simulatorSDK: String? = nil, deviceKey: String?) {
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

            if ¬buildOnly ∧ Configuration.enforceCodeCoverage {

                // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
                printHeader(["Checking code coverage on \(operatingSystemName)..."])
                // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

                // [_Warning: Should not be silent._]
                let settingsScriptResult = bash([
                    "xcodebuild", "\u{2D}showBuildSettings",
                    "\u{2D}target", Configuration.primaryXcodeTarget,
                    "\u{2D}sdk", sdk
                    ]/*, silent: true*/)
                guard settingsScriptResult.succeeded,
                    let settings = settingsScriptResult.output else {
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
                let directorySuffix: String
                if let simulator = simulatorSDK {
                    directorySuffix = "\u{2D}" + simulator
                } else {
                    directorySuffix = ""
                }
                let executableLocation = coverageDirectory + "Products/Debug" + directorySuffix + "/" + relativeExecutableLocation

                for path in [coverageData, executableLocation] {
                    // [_Warning: Only necessary for debugging._]
                    var url = URL(fileURLWithPath: path)
                    var urls = [url]
                    while ¬url.deletingLastPathComponent().path.contains("..") {
                        url = url.deletingLastPathComponent()
                        urls.append(url)
                    }

                    for url in urls.reversed() {
                        print([url.path], in: nil, spaced: true)

                        do {
                        print(join(lines: try FileManager.default.contentsOfDirectory(atPath: url.path)))
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }

                let shellResult = bash([
                    "xcrun", "llvm\u{2D}cov", "show", "\u{2D}show\u{2D}regions",
                    "\u{2D}instr\u{2D}profile", coverageData,
                    executableLocation
                    ], silent: true)
                guard shellResult.succeeded,
                    let coverageResults = shellResult.output else {
                        individualFailure("Code coverage information is unavailable for \(operatingSystem).")
                        return
                }

                let nullCharacters = CharacterSet.whitespacesAndNewlines.union(CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "|")))

                var overallCoverageSuccess = true
                var overallIndex = coverageResults.startIndex
                let fileMarker = ".swift:"
                while let range = coverageResults.range(of: fileMarker, in: overallIndex ..< coverageResults.endIndex) {
                    overallIndex = range.upperBound

                    let fileRange = coverageResults.lineRange(for: range)
                    let file = coverageResults.substring(with: fileRange)

                    let end: String.Index
                    if let next = coverageResults.range(of: fileMarker, in: fileRange.upperBound ..< coverageResults.endIndex) {
                        let nextFileRange = coverageResults.lineRange(for: next)
                        end = nextFileRange.lowerBound
                    } else {
                        end = coverageResults.endIndex
                    }

                    var index = overallIndex
                    while let missingRange = coverageResults.range(of: "^0", in: index ..< end) {
                        index = missingRange.upperBound

                        let errorLineRange = coverageResults.lineRange(for: missingRange)
                        let errorLine = coverageResults.substring(with: errorLineRange)

                        let previous = coverageResults.index(before: errorLineRange.lowerBound)
                        let sourceLineRange = coverageResults.lineRange(for: previous ..< previous)
                        let sourceLine = coverageResults.substring(with: sourceLineRange)

                        let untestableTokensOnPreviousLine = [
                            "[_Exempt from Code Coverage_]",
                            "assert",
                            "precondition"
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
                        let nextLine = coverageResults.substring(with: nextLineRange)
                        var sourceLines = sourceLine + nextLine
                        sourceLines.unicodeScalars = String.UnicodeScalarView(sourceLines.unicodeScalars.filter({ ¬nullCharacters.contains($0) }))

                        var isExecutable = true
                        if sourceLines == "}}" {
                            isExecutable = false
                        }

                        let untestableTokensOnFollowingLine = [
                            "assertionFailure",
                            "preconditionFailure",
                            "fatalError"
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

            if Configuration.enforceCodeCoverage {
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

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .iOS, sdk: "iphoneos", simulatorSDK: "iphonesimulator", deviceKey: "iPhone 7")
        }

        if Environment.shouldDoWatchOSJobs {

            // watchOS

            runUnitTestsInXcode(buildOnly: true, operatingSystem: .watchOS, sdk: "watchos", deviceKey: "Apple Watch Series 2 \u{2D} 38mm")
        }

        if Environment.shouldDoTVOSJobs {

            // tvOS

            runUnitTestsInXcode(buildOnly: false, operatingSystem: .tvOS, sdk: "appletvos", simulatorSDK: "appletvsimulator", deviceKey: "Apple TV 1080p")
        }
    }
}
