/*
 Test.swift

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

import WSValidation
import WSContinuousIntegration

extension Workspace {

    enum Test {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "test"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "runs the project’s test targets."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: Workspace.standardOptions + [ContinuousIntegrationJob.option], execution: { (_, options: Options, output: Command.Output) throws in

            #if !os(Linux)
            if try options.project.configuration(output: output).xcode.manage {
                try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
            }
            #endif

            try Validate.Build.validate(job: options.job, against: ContinuousIntegrationJob.testJobs, for: options.project, output: output)

            var validationStatus = ValidationStatus()

            try executeAsStep(options: options, validationStatus: &validationStatus, output: output)

            try validationStatus.reportOutcome(project: options.project, output: output)
        })

        static func executeAsStep(options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {

            for job in ContinuousIntegrationJob.cases
                where try options.job.includes(job: job) ∧ (try Validate.Build.job(job, isRelevantTo: options.project, andAvailableJobs: ContinuousIntegrationJob.testJobs, output: output)) {
                    try autoreleasepool {

                        if  try options.project.configuration(output: output).continuousIntegration.skipSimulatorOutsideContinuousIntegration,
                            options.job == nil, // Not in continuous integration.
                            job ∈ ContinuousIntegrationJob.simulatorJobs {
                             // @exempt(from: tests) Tested separately.
                            return // and continue loop.
                        }

                        if BuildConfiguration.current == .debug,
                            job ∈ ContinuousIntegrationJob.simulatorJobs,
                            ProcessInfo.processInfo.environment["SIMULATOR_UNAVAILABLE_FOR_TESTING"] ≠ nil { // Simulators are not available to all CI jobs and must be tested separately.
                            return // and continue loop.
                        }

                        try options.project.test(on: job, validationStatus: &validationStatus, output: output)
                    }
            }
        }
    }
}
