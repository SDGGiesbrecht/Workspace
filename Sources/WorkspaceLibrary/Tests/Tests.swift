/*
 Tests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct Tests {

    static let coverageJobs: Set<ContinuousIntegration.Job> = [
        .macOSXcode,
        .iOS,
        .tvOS
    ]
    static let testJobs: Set<ContinuousIntegration.Job> = coverageJobs ∪ [
        .macOSSwiftPackageManager,
        .linux,
    ]
    static let buildJobs: Set<ContinuousIntegration.Job> = testJobs ∪ [
        .watchOS
    ]

    static let simulatorJobs: Set<ContinuousIntegration.Job> = [
        .iOS,
        .tvOS
    ]

    private static func englishName(for job: ContinuousIntegration.Job) -> StrictString {
        var result = job.englishTargetOperatingSystemName
        if let tool = job.englishTargetBuildSystemName {
            result += " with " + tool
        }
        return result
    }

    private static func buildSDK(for job: ContinuousIntegration.Job) -> Xcode.SDK {
        switch job {
        case .macOSXcode:
            return .macOS
        case .iOS:
            return .iOS
        case .watchOS:
            return .watchOS
        case .tvOS:
            return .tvOS
        case .macOSSwiftPackageManager, .linux, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }

    private static func testSDK(for job: ContinuousIntegration.Job) -> Xcode.SDK {
        switch job {
        case .macOSXcode:
            return .macOS
        case .iOS:
            return .iOSSimulator
        case .tvOS:
            return .tvOSSimulator
        case .macOSSwiftPackageManager, .linux, .watchOS, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }

    static func build(_ project: PackageRepository, for job: ContinuousIntegration.Job, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let section = validationStatus.newSection()

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "Checking build for " + englishName(for: job) + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        try FileManager.default.do(in: project.location) {
            do {

                let buildCommand: (inout Command.Output) throws -> Bool
                switch job {
                case .macOSSwiftPackageManager, .linux:
                    buildCommand = SwiftTool.default.build
                case .macOSXcode, .iOS, .watchOS, .tvOS:
                    let scheme = try Xcode.default.scheme(output: &output)
                    buildCommand = { output in
                        return try Xcode.default.build(scheme: scheme, for: buildSDK(for: job), output: &output)
                    }
                case .miscellaneous, .documentation, .deployment:
                    unreachable()
                }

                if try buildCommand(&output) {
                    validationStatus.passStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                        switch localization {
                        case .englishCanada:
                            return "There are no compiler warnings for " + englishName(for: job) + "."
                        }
                    }))
                } else {
                    validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                        switch localization {
                        case .englishCanada:
                            return "There are compiler warnings for " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                        }
                    }))
                }
            } catch {
                validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Build failed for " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }

    static func test(_ project: PackageRepository, on job: ContinuousIntegration.Job, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let section = validationStatus.newSection()

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                var name = job.englishTargetOperatingSystemName
                if let tool = job.englishTargetBuildSystemName {
                    name += " with " + tool
                }
                return "Testing on " + englishName(for: job) + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        try FileManager.default.do(in: project.location) {

            let testCommand: (inout Command.Output) -> Bool
            switch job {
            case .macOSSwiftPackageManager, .linux:
                testCommand = SwiftTool.default.test
            case .macOSXcode, .iOS, .watchOS, .tvOS:
                let scheme = try Xcode.default.scheme(output: &output)
                testCommand = { output in
                    return Xcode.default.test(scheme: scheme, on: testSDK(for: job), output: &output)
                }
            case .miscellaneous, .documentation, .deployment:
                unreachable()
            }

            if testCommand(&output) {
                validationStatus.passStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Tests pass on " + englishName(for: job) + "."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Tests fail on " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }

    static func validateCodeCoverage(for project: PackageRepository, on job: ContinuousIntegration.Job, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let section = validationStatus.newSection()

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                let name = job.englishTargetOperatingSystemName
                return StrictString("Checking code coverage for \(name)...") + section.anchor
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        notImplementedYet()
    }

    /*

    static func test(options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let allTargets = try Repository.packageRepository.targets(output: &output).map { $0.name }
        let primaryProductName = allTargets.first(where: { $0.scalars.first! ∈ CharacterSet.uppercaseLetters ∧ ¬$0.hasSuffix("Tests") })!
        let primaryXcodeTarget = primaryProductName

        #if !os(Linux)
            try DXcode.temporarilyDisableProofreading(output: &output)
            defer {
                (try? DXcode.reEnableProofreading(output: &output))!
        }
        #endif

        var deviceList: [String: String]?

        #if !os(Linux)
            func runUnitTestsInXcode(buildOnly: Bool, operatingSystem: OperatingSystem, sdk: String, simulatorSDK: String? = nil, deviceKey: String?, buildToolName: String? = nil) throws {
                let operatingSystemName = "\(operatingSystem)"

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

                func generateScript(buildOnly: Bool) throws -> [String] {
                    return [
                        "xcodebuild", (buildOnly ? "build" : "test"),
                        "\u{2D}scheme", try Repository.packageRepository.xcodeScheme(output: &output),
                        flag, flagValue
                    ]
                }

                let enforceCodeCoverage = ¬buildOnly ∧ Configuration.enforceCodeCoverage
                var possibleSettings: String?
                var possibleBuildDirectory: String?
                var possibleCoverageDirectory: String?
                if enforceCodeCoverage {
                    guard let settings = try? Shell.default.run(command: [
                        "xcodebuild", "\u{2D}showBuildSettings",
                        "\u{2D}target", primaryXcodeTarget,
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

                let script = try generateScript(buildOnly: buildOnly)
                runUnitTests(buildOnly: buildOnly, operatingSystemName: operatingSystemName, script: script, buildToolName: buildToolName)

                if enforceCodeCoverage,
                    let settings = possibleSettings,
                    let buildDirectory = possibleBuildDirectory,
                    let coverageDirectory = possibleCoverageDirectory {

                    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
                    print("Checking code coverage on \(operatingSystemName)...".formattedAsSectionHeader(), to: &output)
                    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

                    guard let uuid = (try? FileManager.default.contentsOfDirectory(atPath: coverageDirectory))?.first else {
                        validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ _, _ in StrictString("Code coverage information is unavailable for \(operatingSystem).") }))
                        return
                    }
                    let coverageData = coverageDirectory + uuid + "/Coverage.profdata"

                    let executableLocationKey = (" EXECUTABLE_PATH = \(primaryProductName).", "\n")
                    guard let executableLocationSuffix = settings.scalars.firstNestingLevel(startingWith: executableLocationKey.0.scalars, endingWith: executableLocationKey.1.scalars)?.contents.contents else {
                        fatalError(message: [
                            "Failed to find “\(executableLocationKey.0)” in Xcode build settings.",
                            "This may indicate a bug in Workspace."
                            ])
                    }
                    let relativeExecutableLocation = primaryProductName + "." + String(executableLocationSuffix)
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
                            validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ _, _ in StrictString("Code coverage information is unavailable for \(operatingSystem).") }))
                            return
                    }

                    let nullCharacters = (CharacterSet.whitespacesAndNewlines ∪ CharacterSet.decimalDigits) ∪ ["|"]

                    var overallCoverageSuccess = true
                    var overallIndex = coverageResults.startIndex
                    let fileMarker = ".swift\u{3A}"
                    while let range = coverageResults.scalars.firstMatch(for: fileMarker.scalars, in: (overallIndex ..< coverageResults.endIndex).sameRange(in: coverageResults.scalars))?.range.clusters(in: coverageResults.clusters) {
                        overallIndex = range.upperBound

                        let fileRange = coverageResults.lineRange(for: range)
                        let file = String(coverageResults[fileRange])
                        if ¬file.contains("Needs Refactoring") ∧ ¬file.contains("case .swift:") {
                            // [_Workaround: A temporary measure until refactoring is complete._]

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
                    }

                    if overallCoverageSuccess {
                        validationStatus.passStep(message: UserFacingText<InterfaceLocalization, Void>({ _, _ in StrictString("Code coverage is complete for \(operatingSystemName).") }))
                    } else {
                        validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ _, _ in StrictString("Code coverage is incomplete for \(operatingSystemName). (See above for details.)") }))
                    }
                }
            }
        #endif

        #if os(macOS)
            if try options.job.includes(job: .macOSSwiftPackageManager)
                ∧ (try options.project.configuration.supports(.macOS)) {

                if (try? Repository.packageRepository.configuration.projectType())! ≠ .application {
                    runUnitTestsInSwiftPackageManager(operatingSystemName: "macOS", buildToolName: "the Swift Package Manager")
                }
            }
            if try options.job.includes(job: .macOSXcode)
                ∧ (try options.project.configuration.supports(.macOS)) {
                try runUnitTestsInXcode(buildOnly: false, operatingSystem: .macOS, sdk: "macosx", deviceKey: nil, buildToolName: "Xcode")
            }
        #endif

        #if os(Linux)
            if try options.job.includes(job: .linux)
                ∧ (try options.project.configuration.supports(.linux)) {
                runUnitTestsInSwiftPackageManager(operatingSystemName: "Linux")
            }
        #endif

        #if os(macOS)
            if try options.job.includes(job: .iOS)
                ∧ (try options.project.configuration.supports(.iOS)) {
                try runUnitTestsInXcode(buildOnly: false, operatingSystem: .iOS, sdk: "iphoneos", simulatorSDK: "iphonesimulator", deviceKey: "iPhone 8")
            }

            if try options.job.includes(job: .watchOS)
                ∧ (try options.project.configuration.supports(.watchOS)) {
                try runUnitTestsInXcode(buildOnly: true, operatingSystem: .watchOS, sdk: "watchos", deviceKey: "Apple Watch Series 2 \u{2D} 38mm")
            }

            if try options.job.includes(job: .tvOS)
                ∧ (try options.project.configuration.supports(.tvOS)) {
                try runUnitTestsInXcode(buildOnly: false, operatingSystem: .tvOS, sdk: "appletvos", simulatorSDK: "appletvsimulator", deviceKey: "Apple TV 4K")
            }
        #endif
    }
    */
}
