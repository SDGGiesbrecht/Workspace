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

        let scheme = try Xcode.default.scheme(output: &output)

        let allTargets = try project.targets(output: &output).map({ $0.name })
        // [_Workaround: The list of libraries (product or otherwise) should be retrieved from the package manager directly instead. (SDGCommandLine 0.1.4)_]
        let executables = Set(try project.executableTargets(output: &output))
        let validTargets = allTargets.filter { ¬$0.scalars.contains("Tests".scalars) ∧ $0 ∉ executables }

        for target in validTargets {

            let section = validationStatus.newSection()

            print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    let name = job.englishTargetOperatingSystemName
                    return StrictString("Checking code coverage for “\(target)” on \(name)...") + section.anchor
                }
            }).resolved().formattedAsSectionHeader(), to: &output)

            let report = try Xcode.default.coverageData(for: target, of: scheme, on: testSDK(for: job), output: &output)
            if try validate(coverageReport: report, for: project, output: &output) {
                validationStatus.passStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        let name = job.englishTargetOperatingSystemName
                        return StrictString("Test coverage is complete for “\(target)” on \(name).")
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        let name = job.englishTargetOperatingSystemName
                        return StrictString("Test coverage is incomplete for “\(target)” on \(name).") + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }

    private static func untestableSameLineTokens(for project: PackageRepository) throws -> [StrictString] {
        return [
            "[_Exempt from Test Coverage_]",
            "assert",
            "precondition",
            "fatalError"
            ] + (try project.configuration.testCoverageExemptionTokensForSameLine().map({ StrictString($0) }))
    }
    private static func untestablePreviousLineTokens(for project: PackageRepository) throws -> [StrictString] {
        return [
            "assertionFailure",
            "preconditionFailure",
            "fatalError",
            "primitiveMethod",
            "unreachable"
            ] + (try project.configuration.testCoverageExemptionTokensForPreviousLine().map({ StrictString($0) }))
    }

    private static let nullCharacters = (CharacterSet.whitespacesAndNewlines ∪ CharacterSet.decimalDigits) ∪ ["|"]

    private static func validate(coverageReport: String, for project: PackageRepository, output: inout Command.Output) throws -> Bool {

        let sameLineTokens = try untestableSameLineTokens(for: project)
        let previousLineTokens = try untestablePreviousLineTokens(for: project)

        var overallCoverageSuccess = true

        for fileReport in coverageReport.scalars.components(separatedBy: ".swift\u{3A}".scalars) {
            let fileLine = fileReport.range.lowerBound.line(in: coverageReport.lines)
            let file = String(coverageReport.lines[fileLine].line)

            if file.scalars.contains("Needs Refactoring".scalars) {
                continue // [_Workaround: A temporary measure until refactoring is complete._]
            }

            hits: for untested in fileReport.contents.matches(for: "^0".scalars) {
                let errorLineIndex = untested.range.lowerBound.line(in: coverageReport.lines)
                let errorLine = String(coverageReport.lines[errorLineIndex].line)
                let sourceLineIndex = coverageReport.lines.index(before: errorLineIndex)
                let sourceLine = String(coverageReport.lines[sourceLineIndex].line)

                for token in sameLineTokens where sourceLine.scalars.contains(token.scalars) {
                    continue hits
                }

                let nextLineIndex = coverageReport.lines.index(after: errorLineIndex)
                let nextLine = String(coverageReport.lines[nextLineIndex].line)
                let sourceLines = String((sourceLine + nextLine).scalars.replacingMatches(for: ConditionalPattern(condition: { $0 ∈ nullCharacters }), with: "".scalars))

                for token in previousLineTokens where sourceLines.scalars.contains(token.scalars) {
                    continue hits
                }

                if sourceLines.scalars.hasPrefix("}}".scalars) {
                    continue hits
                }

                overallCoverageSuccess = false
                print([
                    URL(fileURLWithPath: file).path(relativeTo: project.location),
                    sourceLine,
                    errorLine
                    ].joinAsLines().formattedAsError().separated(), to: &output)
            }
        }

        return overallCoverageSuccess
    }

    /*

    static func test(options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        #if !os(Linux)
            try DXcode.temporarilyDisableProofreading(output: &output)
            defer {
                (try? DXcode.reEnableProofreading(output: &output))!
        }
        #endif
    }
    */
}
