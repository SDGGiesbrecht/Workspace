/*
 ValidateAll.swift

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

        static let command = Command(name: name, description: description, directArguments: [], options: Workspace.standardOptions + [
            ContinuousIntegrationJob.option
            ], execution: { (arguments: DirectArguments, options: Options, output: Command.Output) throws in

                var validationStatus = ValidationStatus()

                if options.job == .deployment {
                    try TravisCI.keepAlive { // @exempt(from: tests)
                        try executeAsStep(validationStatus: &validationStatus, arguments: arguments, options: options, output: output)
                    }
                } else {
                    try executeAsStep(validationStatus: &validationStatus, arguments: arguments, options: options, output: output)
                }
        })

        static func executeAsStep(validationStatus: inout ValidationStatus, arguments: DirectArguments, options: Options, output: Command.Output) throws {

            if ¬ProcessInfo.isInContinuousIntegration {
                try Workspace.Refresh.All.executeAsStep(withArguments: arguments, options: options, output: output) // @exempt(from: tests)
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

            // Document
            if options.job.includes(job: .miscellaneous) {
                if (try ¬options.project.configuration(output: output).documentation.api.generate
                    ∨ options.project.configuration(output: output).documentation.api.encryptedTravisCIDeploymentKey ≠ nil),
                    try options.project.configuration(output: output).documentation.api.enforceCoverage {
                    try Workspace.Validate.DocumentationCoverage.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
                } else if try options.project.configuration(output: output).documentation.api.generate {
                    try Workspace.Document.executeAsStep(outputDirectory: options.project.defaultDocumentationDirectory, options: options, validationStatus: &validationStatus, output: output)
                }
            }

            if options.job.includes(job: .deployment),
                try options.project.configuration(output: output).documentation.api.generate {
                try Workspace.Document.executeAsStep(outputDirectory: options.project.defaultDocumentationDirectory, options: options, validationStatus: &validationStatus, output: output)
            }

            // Custom
            for task in try options.project.configuration(output: output).customValidationTasks {
                let state = validationStatus.newSection()
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Executing custom validation: “" + task.executable + "”..." + state.anchor
                    }
                }).resolved().formattedAsSectionHeader())
                do {
                    try task.execute(output: output)
                    validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return "Custom validation passes: “" + task.executable + "”"
                        }
                    }))
                } catch {
                    validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return "Custom validation fails: “" + task.executable + "”" + state.crossReference.resolved(for: localization)
                        }
                    }))
                }
            }

            // State
            if ProcessInfo.isInContinuousIntegration ∧ ProcessInfo.isPullRequest ∧ ¬_isDuringSpecificationTest { // @exempt(from: tests) Only reachable during pull request.
                // @exempt(from: tests)

                let state = validationStatus.newSection()

                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
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
                    validationStatus.passStep(message: UserFacing({ localization in // @exempt(from: tests)
                        switch localization {
                        case .englishCanada:
                            return "The project is up to date."
                        }
                    }))
                }
            }

            output.print("Summary".formattedAsSectionHeader())

            // Workspace
            if ¬_isDuringSpecificationTest,
                let update = try Workspace.CheckForUpdates.checkForUpdates(output: output) { // @exempt(from: tests) Determined externally.
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
                    switch localization {
                    case .englishCanada:
                        let url = URL(string: "#installation", relativeTo: Metadata.packageURL)!
                        return [
                            "This validation used Workspace \(Metadata.latestStableVersion.string()), which is no longer up to date.",
                            "To update the version used by this project, run:",
                            "$ workspace refresh scripts •use‐version \(update.string())",
                            "(This requires a full installation. See the following link.)",
                            "\(url.absoluteString.in(Underline.underlined))"
                            ].joinedAsLines()
                    }
                }).resolved().formattedAsWarning().separated())
            }

            try validationStatus.reportOutcome(project: options.project, output: output)
        }
    }
}

internal var _isDuringSpecificationTest: Bool = false
