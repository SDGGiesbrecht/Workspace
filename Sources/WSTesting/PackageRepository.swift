/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGExternalProcess

import SDGXcode

import WSValidation
import WSContinuousIntegration
import WSProofreading

extension PackageRepository {

    // MARK: - Testing

    public func build(for job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking build for " + job.englishName + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {
            let buildCommand: (Command.Output) throws -> Bool
            switch job {
            case .macOSSwiftPackageManager, .linux:
                buildCommand = { output in
                    let log = try self.build(releaseConfiguration: false, staticallyLinkStandardLibrary: false, reportProgress: { output.print($0) })
                    return ¬SwiftCompiler.warningsOccurred(during: log)
                }
            case .macOSXcode, .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
                buildCommand = { output in
                    let log = try self.build(for: job.buildSDK) { report in
                        if let relevant = Xcode.abbreviate(output: report) {
                            output.print(relevant)
                        }
                    }
                    return ¬Xcode.warningsOccurred(during: log)
                }
            case .miscellaneous, .deployment:
                unreachable()
            }

            if try buildCommand(output) {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "There are no compiler warnings for " + job.englishName + "."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "There are compiler warnings for " + job.englishName + "." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            // @exempt(from: tests) Unreachable on Linux.
            var description = StrictString(error.localizedDescription)
            if let noXcode = error as? Xcode.Error,
                noXcode == .noXcodeProject {
                description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
            }
            output.print(description.formattedAsError())

            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                switch localization {
                case .englishCanada: // @exempt(from: tests)
                    return "Build failed for " + job.englishName + "." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    public func test(on job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                var name = job.englishTargetOperatingSystemName
                if let tool = job.englishTargetBuildSystemName {
                    name += " with " + tool // @exempt(from: tests) Unreachable from Linux.
                }
                return "Testing on " + job.englishName + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        #if TEST_SHIMS
        if job == .macOSSwiftPackageManager,
            ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil {
            // “swift test” gets confused inside Xcode’s test sandbox. This skips it while testing Workspace.
            output.print("Skipping due to sandbox...")
            return
        }
        #endif

        let testCommand: (Command.Output) -> Bool
        switch job {
        case .macOSSwiftPackageManager, .linux:
            // @exempt(from: tests) Tested separately.
            testCommand = { output in
                do {
                    try self.test(reportProgress: { output.print($0) })
                    return true
                } catch {
                    return false
                }
            }
        case .macOSXcode, .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
            testCommand = { output in
                do {
                    try self.test(on: job.testSDK) { report in
                        if let relevant = Xcode.abbreviate(output: report) {
                            output.print(relevant)
                        }
                    }
                    return true
                } catch {
                    var description = StrictString(error.localizedDescription)
                    if error as? ExternalProcess.Error == nil { // ← Description would be redundant.
                        if let noXcode = error as? Xcode.Error,
                            noXcode == .noXcodeProject {
                            description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
                        }
                        output.print(description.formattedAsError())
                    }
                    return false
                }
            }
        case .miscellaneous, .deployment:
            unreachable()
        }

        if testCommand(output) {
            validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Tests pass on " + job.englishName + "."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Tests fail on " + job.englishName + "." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    public func validateCodeCoverage(on job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                let name = job.englishTargetOperatingSystemName
                return "Checking test coverage on \(name)..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        func failStepWithError(message: StrictString) {
            // @exempt(from: tests) Difficult to reach consistently.

            output.print(message.formattedAsError())

            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                switch localization {
                case .englishCanada: // @exempt(from: tests)
                    let name = job.englishTargetOperatingSystemName
                    return "Test coverage could not be determined on \(name)." + section.crossReference.resolved(for: localization)
                }
            }))
        }

        do {
            let report: TestCoverageReport
            switch job {
            case .macOSSwiftPackageManager, .linux:
                guard let fromPackageManager = try codeCoverageReport(ignoreCoveredRegions: true, reportProgress: { output.print($0) }) else { // @exempt(from: tests) Untestable in Xcode due to interference.
                    failStepWithError(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return "The package manager has not produced a test coverage report."
                        }
                    }).resolved())
                    return
                }
                report = fromPackageManager // @exempt(from: tests)
            case .macOSXcode, .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
                guard let fromXcode = try codeCoverageReport(on: job.testSDK, ignoreCoveredRegions: true, reportProgress: { output.print($0) }) else {
                    failStepWithError(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return "Xcode has not produced a test coverage report."
                        }
                    }).resolved())
                    return
                }
                report = fromXcode
            case .miscellaneous, .deployment:
                unreachable()
            }

            var irrelevantFiles: Set<URL> = []
            for target in try package().targets {
                switch target.type {
                case .library, .systemModule:
                break // Coverage matters.
                case .executable:
                    // Not testable.
                    for path in target.sources.paths {
                        irrelevantFiles.insert(URL(fileURLWithPath: path.pathString).resolvingSymlinksInPath())
                    }
                case .test:
                    // Coverage unimportant.
                    for path in target.sources.paths {
                        irrelevantFiles.insert(URL(fileURLWithPath: path.pathString).resolvingSymlinksInPath())
                    }
                }
            }
            let exemptPaths = try configuration(output: output).testing.exemptPaths.map({ location.appendingPathComponent($0).resolvingSymlinksInPath() })

            let sameLineTokens = try configuration(output: output).testing.exemptionTokens.map { StrictString($0.token) }
            let previousLineTokens = try configuration(output: output).testing.exemptionTokens.filter({ $0.scope == .previousLine }).map { StrictString($0.token) }

            var passing = true
            files: for file in report.files {
                let resolved = file.file.resolvingSymlinksInPath()
                if resolved ∈ irrelevantFiles {
                    continue files
                }
                for path in exemptPaths where resolved.is(in: path) {
                    continue files
                }

                CommandLineProofreadingReporter.default.reportParsing(file: file.file.path(relativeTo: location), to: output)
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
                        return "Test coverage is complete on \(name)."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                    switch localization {
                    case .englishCanada: // @exempt(from: tests)
                        let name = job.englishTargetOperatingSystemName
                        return "Test coverage is incomplete on \(name)." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            // @exempt(from: tests) Unreachable on Linux.
            var description = StrictString(error.localizedDescription)
            if let noXcode = error as? Xcode.Error,
                noXcode == .noXcodeProject {
                description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
            }
            failStepWithError(message: description)
        }
    }
}
