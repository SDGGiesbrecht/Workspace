/*
 ValidateBuild.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject
import WSValidation
import WSTesting
import WSContinuousIntegration

extension Workspace.Validate {

    enum Build {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "build"
            case .deutschDeutschland:
                return "erstellung"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "validates the build, checking that it triggers no compiler warnings."
            case .deutschDeutschland:
                return "prüft die Erstellung, dass keine Übersetzungswarnungen auftreten."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: Workspace.standardOptions + [ContinuousIntegrationJob.option], execution: { (_, options: Options, output: Command.Output) throws in

            try validate(job: options.job, against: ContinuousIntegrationJob.buildJobs, for: options.project, output: output)

            #if !os(Linux)
            if try options.project.configuration(output: output).xcode.manage {
                try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
            }
            #endif

            var validationStatus = ValidationStatus()

            try executeAsStep(options: options, validationStatus: &validationStatus, output: output)

            try validationStatus.reportOutcome(project: options.project, output: output)
        })

        static func job(_ job: ContinuousIntegrationJob, isRelevantTo project: PackageRepository, andAvailableJobs validJobs: Set<ContinuousIntegrationJob>, output: Command.Output) throws -> Bool {
            return try job ∈ validJobs
                ∧ ((try job.isRequired(by: project, output: output))
                    ∧ job.platform == Platform.current)
        }

        static func validate(job: ContinuousIntegrationJob?, against validJobs: Set<ContinuousIntegrationJob>, for project: PackageRepository, output: Command.Output) throws {
            if let specified = job,
                ¬(try Build.job(specified, isRelevantTo: project, andAvailableJobs: validJobs, output: output)) {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Invalid job."
                    case .deutschDeutschland:
                        return "Ungültige Aufgabe."
                    }
                }))
            }
        }

        static func executeAsStep(options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {

            for job in ContinuousIntegrationJob.allCases
                where try options.job.includes(job: job) ∧ (try Build.job(job, isRelevantTo: options.project, andAvailableJobs: ContinuousIntegrationJob.buildJobs, output: output)) {
                    try autoreleasepool {

                        try options.project.build(for: job, validationStatus: &validationStatus, output: output)
                    }
            }
        }
    }
}
