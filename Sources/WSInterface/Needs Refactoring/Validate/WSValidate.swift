/*
 WSValidate.swift

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

import SDGExternalProcess

import WorkspaceProjectConfiguration
import WSProject
import WSContinuousIntegration

func runValidate(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: Command.Output) throws {

    var validationStatus = ValidationStatus()

    if ¬ProcessInfo.isInContinuousIntegration {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Refreshing
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try runRefresh(andExit: false, arguments: arguments, options: options, output: output)

    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Validating \(try Repository.packageRepository.projectName())...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if options.job == .miscellaneous ∨ options.job == nil {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Proofreading...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Workspace.Proofread.executeAsStep(normalizingFirst: false, options: options, validationStatus: &validationStatus, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Running unit tests...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if try options.project.configuration().testing.prohibitCompilerWarnings {
        try Workspace.Validate.Build.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
    }
#if os(Linux)
        // Coverage irrelevant.
        try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: output)
#else
    if try options.project.configuration().testing.enforceCoverage {
        if let job = options.job,
            job ∉ Tests.coverageJobs {
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

    #if !os(Linux)
        if options.job.includes(job: .documentation) {
            if try options.project.configuration().documentation.api.enforceCoverage {
                try Workspace.Validate.DocumentationCoverage.executeAsStepDocumentingFirst(options: options, validationStatus: &validationStatus, output: output)
            } else if try options.project.configuration().documentation.api.generate
                ∧ (try options.project.configuration().documentation.api.encryptedTravisCIDeploymentKey == nil) {
                try Workspace.Document.executeAsStep(outputDirectory: Documentation.defaultDocumentationDirectory(for: options.project), options: options, validationStatus: &validationStatus, output: output)
            }
        }

        if try options.job.includes(job: .deployment)
            ∧ (try options.project.configuration().documentation.api.generate) {
            try Workspace.Document.executeAsStep(outputDirectory: Documentation.defaultDocumentationDirectory(for: options.project), options: options, validationStatus: &validationStatus, output: output)
        }
    #endif

    if ProcessInfo.isInContinuousIntegration ∧ ProcessInfo.isPullRequest {

        if options.job ≠ ContinuousIntegrationJob.deployment {

            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            output.print("Validating project state...".formattedAsSectionHeader())
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

            requireBash(["git", "add", ".", "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"], silent: true)
            if (try? Shell.default.run(command: ["git", "diff", "\u{2D}\u{2D}exit\u{2D}code", "\u{2D}\u{2D}", ".", "\u{27}:(exclude)*.dsidx\u{27}"], reportProgress: { output.print($0) })) ≠ nil {
                validationStatus.passStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "The project is up to date."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "The project is out of date. (Please run “Validate” before committing.)"
                    }
                }))
            }
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Summary".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if let update = try Workspace.CheckForUpdates.checkForUpdates(output: output) {
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return [
                    StrictString("This validation used Workspace \(Metadata.latestStableVersion.string()), which is no longer up to date."),
                    "To update the version used by this project, run:",
                    StrictString("$ workspace refresh scripts •use‐version \(update.string)"),
                    "(This requires a full installation. See the following link.)",
                    StrictString("\(DocumentationLink.installation.url.in(Underline.underlined))")
                    ].joinedAsLines()
            }
        }).resolved().formattedAsWarning().separated())
    }

    try validationStatus.reportOutcome(projectName: try options.project.projectName(), output: output)
}
