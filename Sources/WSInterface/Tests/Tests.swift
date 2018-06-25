/*
 Tests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGXcode

import WSValidation
import WSContinuousIntegration

struct Tests {

    static let coverageJobs: Set<ContinuousIntegrationJob> = [
        .macOSXcode,
        .iOS,
        .tvOS
    ]
    static let testJobs: Set<ContinuousIntegrationJob> = coverageJobs ∪ [
        .macOSSwiftPackageManager,
        .linux
    ]
    static let buildJobs: Set<ContinuousIntegrationJob> = testJobs ∪ [
        .watchOS
    ]

    private static func englishName(for job: ContinuousIntegrationJob) -> StrictString {
        var result = job.englishTargetOperatingSystemName
        if let tool = job.englishTargetBuildSystemName {
            result += " with " + tool
        }
        return result
    }

    private static func buildSDK(for job: ContinuousIntegrationJob) -> Xcode.SDK {
        switch job {
        case .macOSXcode:
            return .macOS
        case .iOS:
            return .iOS(simulator: false)
        case .watchOS:
            return .watchOS
        case .tvOS:
            return .tvOS(simulator: false)
        case .macOSSwiftPackageManager, .linux, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }

    private static func testSDK(for job: ContinuousIntegrationJob) -> Xcode.SDK {
        switch job {
        case .macOSXcode:
            return .macOS
        case .iOS:
            // [_Exempt from Test Coverage_] Tested separately.
            return .iOS(simulator: true)
        case .tvOS:
            // [_Exempt from Test Coverage_] Tested separately.
            return .tvOS(simulator: true)
        case .macOSSwiftPackageManager, .linux, .watchOS, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }

    static func build(_ project: PackageRepository, for job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking build for " + englishName(for: job) + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {
            #if !os(Linux)
            setenv(DXcode.skipProofreadingEnvironmentVariable, "YES", 1 /* overwrite */)
            defer {
                unsetenv(DXcode.skipProofreadingEnvironmentVariable)
            }
            #endif

            let buildCommand: (Command.Output) throws -> Bool
            switch job {
            case .macOSSwiftPackageManager, .linux:
                buildCommand = { output in
                    let log = try project.build(releaseConfiguration: false, staticallyLinkStandardLibrary: false, reportProgress: { output.print($0) })
                    return ¬SwiftCompiler.warningsOccurred(during: log)
                }
            case .macOSXcode, .iOS, .watchOS, .tvOS:
                buildCommand = { output in
                    let log = try project.build(for: buildSDK(for: job)) { report in
                        if let relevant = Xcode.abbreviate(output: report) {
                            output.print(relevant)
                        }
                    }
                    return ¬Xcode.warningsOccurred(during: log)
                }
            case .miscellaneous, .documentation, .deployment:
                unreachable()
            }

            if try buildCommand(output) {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "There are no compiler warnings for " + englishName(for: job) + "."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "There are compiler warnings for " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
                switch localization {
                case .englishCanada: // [_Exempt from Test Coverage_]
                    return "Build failed for " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    static func test(_ project: PackageRepository, on job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                var name = job.englishTargetOperatingSystemName
                if let tool = job.englishTargetBuildSystemName {
                    name += " with " + tool
                }
                return "Testing on " + englishName(for: job) + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        if BuildConfiguration.current == .debug,
            job == .macOSSwiftPackageManager,
            ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil {
            // “swift test” gets confused inside Xcode’s test sandbox. This skips it while testing Workspace.
            output.print("Skipping due to sandbox...")
            return
        }

        #if !os(Linux)
        setenv(DXcode.skipProofreadingEnvironmentVariable, "YES", 1 /* overwrite */)
        defer {
            unsetenv(DXcode.skipProofreadingEnvironmentVariable)
        }
        #endif

        let testCommand: (Command.Output) -> Bool
        switch job {
        case .macOSSwiftPackageManager, .linux:
            // [_Exempt from Test Coverage_] Tested separately.
            testCommand = { output in
                do {
                    try project.test(reportProgress: { output.print($0) })
                    return true
                } catch {
                    return false
                }
            }
        case .macOSXcode, .iOS, .watchOS, .tvOS:
            testCommand = { output in
                do {
                    try project.test(on: testSDK(for: job)) { report in
                        if let relevant = Xcode.abbreviate(output: report) {
                            output.print(relevant)
                        }
                    }
                    return true
                } catch {
                    return false
                }
            }
        case .miscellaneous, .documentation, .deployment:
            unreachable()
        }

        if testCommand(output) {
            validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Tests pass on " + englishName(for: job) + "."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Tests fail on " + englishName(for: job) + "." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    static func validateCodeCoverage(for project: PackageRepository, on job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                let name = job.englishTargetOperatingSystemName
                return StrictString("Checking test coverage on \(name)...") + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        func failStepWithError(message: StrictString) {
            // [_Exempt from Test Coverage_] Difficult to reach consistently.

            output.print(message.formattedAsError())

            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
                switch localization {
                case .englishCanada: // [_Exempt from Test Coverage_]
                    let name = job.englishTargetOperatingSystemName
                    return StrictString("Test coverage could not be determined on \(name).") + section.crossReference.resolved(for: localization)
                }
            }))
        }

        do {
            guard let report = try project.codeCoverageReport(on: testSDK(for: job), ignoreCoveredRegions: true, reportProgress: { output.print($0) }) else {
                failStepWithError(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Xcode has not produced a test coverage report."
                    }
                }).resolved())
                return
            }

            var irrelevantFiles: Set<URL> = []
            for target in try project.package().targets {
                switch target.type {
                case .library, .systemModule:
                break // Coverage matters.
                case .executable:
                    // Not testable.
                    for path in target.sources.paths {
                        irrelevantFiles.insert(URL(fileURLWithPath: path.asString).resolvingSymlinksInPath())
                    }
                case .test:
                    // Coverage unimportant.
                    for path in target.sources.paths {
                        irrelevantFiles.insert(URL(fileURLWithPath: path.asString).resolvingSymlinksInPath())
                    }
                }
            }

            let sameLineTokens = try project.configuration(output: output).testing.testCoverageExemptions.map { StrictString($0.token) }
            let previousLineTokens = try project.configuration(output: output).testing.testCoverageExemptions.filter({ $0.scope == .previousLine }).map { StrictString($0.token) }

            var passing = true
            for file in report.files where file.file.resolvingSymlinksInPath() ∉ irrelevantFiles ∧ ¬file.file.path.contains("/Needs Refactoring/") { // [_Workaround: “Needs Refactoring” is a temporary measure._]
                CommandLineProofreadingReporter.default.reportParsing(file: file.file.path(relativeTo: project.location), to: output)
                try autoreleasepool {
                    let sourceFile = try String(from: file.file)
                    regionLoop: for region in file.regions {
                        let startLineIndex = region.region.lowerBound.line(in: sourceFile.lines)
                        let startLine = sourceFile.lines[startLineIndex].line
                        for token in sameLineTokens where startLine.contains(token.scalars) {
                            continue regionLoop // Ignore and move on.
                        }
                        let nextLineIndex = sourceFile.lines.index(after: startLineIndex)
                        if nextLineIndex ≠ sourceFile.lines.endIndex {
                            let nextLine = sourceFile.lines[nextLineIndex].line
                            for token in previousLineTokens where nextLine.contains(token.scalars) {
                                continue regionLoop // Ignore and move on.
                            }
                        }
                        // No ignore tokens.

                        CommandLineProofreadingReporter.default.report(violation: region.region, in: sourceFile, to: output)
                        passing = false
                    }
                }
            }

            if passing {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        let name = job.englishTargetOperatingSystemName
                        return StrictString("Test coverage is complete on \(name).")
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
                    switch localization {
                    case .englishCanada: // [_Exempt from Test Coverage_]
                        let name = job.englishTargetOperatingSystemName
                        return StrictString("Test coverage is incomplete on \(name).") + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            failStepWithError(message: StrictString(error.localizedDescription))
        }
    }
}
