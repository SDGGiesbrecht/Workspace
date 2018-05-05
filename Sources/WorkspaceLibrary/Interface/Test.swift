/*
 Test.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

extension Workspace {

    enum Test {

        private static let name = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "test"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "runs the project’s test targets."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [ContinuousIntegration.Job.option], execution: { (_, options: Options, output: Command.Output) throws in

            try Validate.Build.validate(job: options.job, against: Tests.testJobs, for: options.project, output: &output)

            var validationStatus = ValidationStatus()

            try executeAsStep(options: options, validationStatus: &validationStatus, output: &output)

            try validationStatus.reportOutcome(projectName: try options.project.projectName(output: &output), output: &output)
        })

        static func executeAsStep(options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {

            for job in ContinuousIntegration.Job.cases
                where try options.job.includes(job: job) ∧ (try Validate.Build.job(job, isRelevantTo: options.project, andAvailableJobs: Tests.testJobs, output: &output)) {
                    try autoreleasepool {

                        if try options.project.configuration.shouldSkipSimulator(),
                            options.job == nil, // Not in continuous integration.
                            job ∈ Tests.simulatorJobs { // [_Exempt from Test Coverage_] Tested separately.
                            return // and continue loop.
                        }

                        if BuildConfiguration.current == .debug,
                            job ∈ Tests.simulatorJobs,
                            ProcessInfo.processInfo.environment["SIMULATOR_UNAVAILABLE_FOR_TESTING"] ≠ nil { // Simulators are not available to all CI jobs and must be tested separately.
                            return // and continue loop.
                        }

                        try Tests.test(options.project, on: job, validationStatus: &validationStatus, output: &output)
                    }
            }
        }
    }
}
