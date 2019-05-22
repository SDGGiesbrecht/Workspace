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
            case .macOS, .linux:
                buildCommand = { output in
                    let log = try self.build(releaseConfiguration: false, staticallyLinkStandardLibrary: false, reportProgress: { output.print($0) }).get()
                    return ¬SwiftCompiler.warningsOccurred(during: log)
                }
            case .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
                buildCommand = { output in
                    let log = try self.build(for: job.buildSDK, reportProgress: { report in
                        if let relevant = Xcode.abbreviate(output: report) {
                            output.print(relevant)
                        }
                    }).get()
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
            if let schemeError = error as? Xcode.SchemeError {
                switch schemeError {
                case .foundationError, .noPackageScheme, .xcodeError: // @exempt(from: tests)
                    break
                case .noXcodeProject:
                    description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
                }
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

        try updateTestManifests(job: job, validationStatus: &validationStatus, output: output)

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Testing on " + job.englishName + "..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        #if TEST_SHIMS
        if job == .macOS,
            ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil {
            // “swift test” gets confused inside Xcode’s test sandbox. This skips it while testing Workspace.
            output.print("Skipping due to sandbox...")
            return
        }
        #endif

        let testCommand: (Command.Output) -> Bool
        switch job {
        case .macOS, .linux:
            // @exempt(from: tests) Tested separately.
            testCommand = { output in
                do {
                    _ = try self.test(reportProgress: { output.print($0) }).get()
                    return true
                } catch {
                    return false
                }
            }
        case .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
            testCommand = { output in
                switch self.test(on: job.testSDK, reportProgress: { report in
                    if let relevant = Xcode.abbreviate(output: report) {
                        output.print(relevant)
                    }
                }) {
                case .failure(let error):
                    var description = StrictString(error.localizedDescription)
                    switch error {
                    case .foundationError, .noPackageScheme, .xcodeError:
                        break
                    case .noXcodeProject:
                        description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
                    }
                    output.print(description.formattedAsError())
                    return false
                case .success:
                    return true
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

    private func updateTestManifests(
        job: ContinuousIntegrationJob,
        validationStatus: inout ValidationStatus,
        output: Command.Output) throws {

        let configuration = try self.configuration(output: output)
        if configuration.supportedPlatforms.contains(where: { ¬$0.supportsObjectiveC }),
            job == .macOS { // @exempt(from: tests) Unreachable on Linux.

            let section = validationStatus.newSection()

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Updating test manifests..." + section.anchor
                }
            }).resolved().formattedAsSectionHeader())

            #if TEST_SHIMS
            if job == .macOS,
                ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ≠ nil {
                // “swift test” gets confused inside Xcode’s test sandbox. This skips it while testing Workspace.
                output.print("Skipping due to sandbox...")
                return
            }
            #endif

            do {
                switch regenerateTestLists(reportProgress: { output.print($0) }) {
                case .failure(let error):
                    switch error {
                    case .executionError(let processError):
                        switch processError {
                        case .foundationError: // @exempt(from: tests)
                            throw error
                        case .processError(code: _, output: let regenerationOutput):
                            if regenerationOutput.contains("___llvm_profile_") {
                                SwiftCompiler.runCustomSubcommand(["package", "clean"])
                                _ = try regenerateTestLists(reportProgress: { output.print($0) }).get()
                            } else {
                                throw error
                            }
                        }
                    case .locationError: // @exempt(from: tests)
                        throw error
                    }
                case .success:
                    break
                }
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Updated test manifests."
                    }
                }))
            } catch {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Failed to update test manifests." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }

    public func validateCodeCoverage(on job: ContinuousIntegrationJob, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking test coverage on \(job.englishName)..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        func failStepWithError(message: StrictString) {
            // @exempt(from: tests) Difficult to reach consistently.

            output.print(message.formattedAsError())

            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                switch localization {
                case .englishCanada: // @exempt(from: tests)
                    return "Test coverage could not be determined on \(job.englishName)." + section.crossReference.resolved(for: localization)
                }
            }))
        }

        do {
            let report: TestCoverageReport
            switch job {
            case .macOS, .linux:
                guard let fromPackageManager = try codeCoverageReport(ignoreCoveredRegions: true, reportProgress: { output.print($0) }).get() else { // @exempt(from: tests) Untestable in Xcode due to interference.
                    failStepWithError(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return "The package manager has not produced a test coverage report."
                        }
                    }).resolved())
                    return
                }
                report = fromPackageManager // @exempt(from: tests)
            case .iOS, .watchOS, .tvOS: // @exempt(from: tests) Unreachable from Linux.
                guard let fromXcode = try codeCoverageReport(on: job.testSDK, ignoreCoveredRegions: true, reportProgress: { output.print($0) }).get() else {
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
            for target in try package().get().targets {
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
                        return "Test coverage is complete on \(job.englishName)."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                    switch localization {
                    case .englishCanada: // @exempt(from: tests)
                        return "Test coverage is incomplete on \(job.englishName)." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            // @exempt(from: tests) Unreachable on Linux.
            var description = StrictString(error.localizedDescription)
            if let coverageError = error as? Xcode.CoverageReportingError {
                switch coverageError {
                case .buildDirectoryError(let directoryError):
                    switch directoryError {
                    case .noBuildDirectory:
                        break
                    case .schemeError(let schemeError):
                        switch schemeError {
                        case .foundationError, .noPackageScheme, .xcodeError:
                            break
                        case .noXcodeProject:
                            description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
                        }
                    }
                case .corruptTestCoverageReport, .foundationError, .hostDestinationError, .xcodeError:
                    break
                }
            }
            failStepWithError(message: description)
        }
    }
}
