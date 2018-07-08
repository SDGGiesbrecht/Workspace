/*
 ValidateAll.swift

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

import WorkspaceProjectConfiguration
import WSValidation
import WSContinuousIntegration

extension Workspace.Validate {

    enum All {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "all"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "performs all configured validation checks."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [
            ContinuousIntegrationJob.option
            ], execution: { (arguments: DirectArguments, options: Options, output: Command.Output) throws in

                var validationStatus = ValidationStatus()

                if options.job == .deployment {
                    try TravisCI.keepAlive { // [_Exempt from Test Coverage_]
                        try executeAsStep(validationStatus: &validationStatus, arguments: arguments, options: options, output: output)
                    }
                } else {
                    try executeAsStep(validationStatus: &validationStatus, arguments: arguments, options: options, output: output)
                }
        })

        static func executeAsStep(validationStatus: inout ValidationStatus, arguments: DirectArguments, options: Options, output: Command.Output) throws {

            if ¬ProcessInfo.isInContinuousIntegration {
                try Workspace.Refresh.All.executeAsStep(withArguments: arguments, options: options, output: output) // [_Exempt from Test Coverage_]
            }

            let projectName = StrictString(try options.project.projectName())
            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Validating “" + projectName + "”..."
                }
            }).resolved().formattedAsSectionHeader())

            // Proofread
            if options.job == .miscellaneous ∨ options.job == nil {
                try Workspace.Proofread.executeAsStep(normalizingFirst: false, options: options, validationStatus: &validationStatus, output: output)
            }

            // Build
            if try options.project.configuration(output: output).testing.prohibitCompilerWarnings {
                try Workspace.Validate.Build.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
            }

            // Test
            #if os(Linux)
            // Coverage irrelevant.
            try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
            #else
            if try options.project.configuration(output: output).testing.enforceCoverage {
                if let job = options.job,
                    job ∉ ContinuousIntegrationJob.coverageJobs {
                    // Coverage impossible to check.
                    try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
                } else {
                    // Check coverage.
                    try Workspace.Validate.TestCoverage.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
                }
            } else {
                // Coverage irrelevant.
                try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
            }
            #endif

            // Document
            #if !os(Linux)
            if options.job.includes(job: .documentation) {
                if try options.project.configuration(output: output).documentation.api.enforceCoverage {
                    try Workspace.Validate.DocumentationCoverage.executeAsStepDocumentingFirst(options: options, validationStatus: &validationStatus, output: output)
                } else if try options.project.configuration(output: output).documentation.api.generate
                    ∧ (try options.project.configuration(output: output).documentation.api.encryptedTravisCIDeploymentKey == nil) {
                    try Workspace.Document.executeAsStep(outputDirectory: options.project.defaultDocumentationDirectory, options: options, validationStatus: &validationStatus, output: output)
                }
            }

            if try options.job.includes(job: .deployment)
                ∧ (try options.project.configuration(output: output).documentation.api.generate) {
                try Workspace.Document.executeAsStep(outputDirectory: options.project.defaultDocumentationDirectory, options: options, validationStatus: &validationStatus, output: output)
            }
            #endif

            // State
            if ProcessInfo.isInContinuousIntegration ∧ ProcessInfo.isPullRequest { // [_Exempt from Test Coverage_] Only reachable during pull request.
                // [_Exempt from Test Coverage_]

                let state = validationStatus.newSection()

                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Validating project state..." + state.anchor
                    }
                }).resolved().formattedAsSectionHeader())

                let difference = try options.project.uncommittedChanges(excluding: ["*.dsidx"])
                if ¬difference.isEmpty {
                    output.print(difference.separated())

                    validationStatus.failStep(message: UserFacing({ localization in
                        switch localization {
                        case .englishCanada:
                            return "The project is out of date. Please validate before committing." + state.crossReference.resolved(for: localization)
                        }
                    }))
                } else {
                    validationStatus.passStep(message: UserFacing({ localization in
                        switch localization {
                        case .englishCanada:
                            return "The project is up to date."
                        }
                    }))
                }
            }

            output.print("Summary".formattedAsSectionHeader())

            // Workspace
            if let update = try Workspace.CheckForUpdates.checkForUpdates(output: output) {
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_] Determined externally.
                    switch localization {
                    case .englishCanada:
                        let url = URL(string: "#installation", relativeTo: Metadata.packageURL)!
                        return [
                            StrictString("This validation used Workspace \(Metadata.latestStableVersion.string()), which is no longer up to date."),
                            "To update the version used by this project, run:",
                            StrictString("$ workspace refresh scripts •use‐version \(update.string)"),
                            "(This requires a full installation. See the following link.)",
                            StrictString("\(url.absoluteString.in(Underline.underlined))")
                            ].joinedAsLines()
                    }
                }).resolved().formattedAsWarning().separated())
            }

            try validationStatus.reportOutcome(project: options.project, output: output)
        }
    }
}
