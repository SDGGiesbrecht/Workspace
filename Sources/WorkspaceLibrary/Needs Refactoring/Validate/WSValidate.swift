/*
 WSValidate.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

func runValidate(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: Command.Output) throws {

    var validationStatus = ValidationStatus()

    if ¬Environment.isInContinuousIntegration {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Refreshing
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try runRefresh(andExit: false, arguments: arguments, options: options, output: &output)

    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Validating \(try Repository.packageRepository.projectName(output: &output))...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if options.job == .miscellaneous ∨ options.job == nil {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Validating Workspace configuration...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        if Configuration.validate() {
            validationStatus.passStep(message: UserFacingText({ localization in
                switch localization {
                case .englishCanada:
                    return "Workspace configuration validates."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacingText({ localization in
                switch localization {
                case .englishCanada:
                    return "Workspace configuration fails validation. (See above for details.)"
                }
            }))
        }

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Proofreading...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Workspace.Proofread.executeAsStep(normalizingFirst: false, options: options, validationStatus: &validationStatus, output: &output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Running unit tests...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if try options.project.configuration.shouldProhibitCompilerWarnings() {
        try Workspace.Validate.Build.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)
    }
#if os(Linux)
        // Coverage irrelevant.
        try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)
#else
    if try options.project.configuration.shouldEnforceTestCoverage() {
        if let job = options.job,
            job ∉ Tests.coverageJobs {
            // Coverage impossible to check.
            try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)
        } else {
            // Check coverage.
            try Workspace.Validate.TestCoverage.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)
        }
    } else {
        // Coverage irrelevant.
        try Workspace.Test.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)
    }
#endif

    #if !os(Linux)
        if options.job.includes(job: .documentation) {
            if try options.project.configuration.shouldEnforceDocumentationCoverage() {
                try Workspace.Validate.DocumentationCoverage.executeAsStepDocumentingFirst(options: options, validationStatus: &validationStatus, output: &output)
            } else if try options.project.configuration.shouldGenerateDocumentation()
                ∧ (try options.project.configuration.encryptedTravisDeploymentKey() == nil) {
                try Workspace.Document.executeAsStep(outputDirectory: Documentation.defaultDocumentationDirectory(for: options.project), options: options, validationStatus: &validationStatus, output: &output)
            }
        }

        if try options.job.includes(job: .deployment)
            ∧ (try options.project.configuration.shouldGenerateDocumentation()) {
            try Workspace.Document.executeAsStep(outputDirectory: Documentation.defaultDocumentationDirectory(for: options.project), options: options, validationStatus: &validationStatus, output: &output)
        }
    #endif

    if Environment.isInContinuousIntegration {

        if options.job ≠ ContinuousIntegration.Job.deployment {

            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            print("Validating project state...".formattedAsSectionHeader(), to: &output)
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

            var allowedDifferences: [String] = []
            for localization in try options.project.configuration.localizations() {
                var relatedProjects = ReadMe.relatedProjectsLocation(for: options.project, localization: localization).lastPathComponent
                allowedDifferences.append(relatedProjects)
                relatedProjects.scalars.replaceMatches(for: ".md".scalars, with: ".html".scalars)
                relatedProjects.scalars.replaceMatches(for: " ".scalars, with: "\u{2D}".scalars)
                relatedProjects.scalars.replaceMatches(for: ConditionalPattern({ $0 ∉
                    (CharacterSet(charactersIn: Unicode.Scalar(0x00) ..< Unicode.Scalar(0x80))
                        ∩ CharacterSet.alphanumerics)
                    ∪ ["\u{2D}", "."]
                }), with: "".scalars)
                allowedDifferences.append(relatedProjects.lowercased())
            }
            allowedDifferences = allowedDifferences.map { "\u{27}:(exclude)*\($0.components(separatedBy: " ").last!)\u{27}" }

            requireBash(["git", "add", ".", "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"], silent: true)
            if (try? Shell.default.run(command: ["git", "diff", "\u{2D}\u{2D}exit\u{2D}code", "\u{2D}\u{2D}", ".", "\u{27}:(exclude)*.dsidx\u{27}"] + allowedDifferences, reportProgress: { print($0, to: &output) })) ≠ nil {
                validationStatus.passStep(message: UserFacingText({ localization in
                    switch localization {
                    case .englishCanada:
                        return "The project is up to date."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacingText({ localization in
                    switch localization {
                    case .englishCanada:
                        return "The project is out of date. (Please run “Validate” before committing.)"
                    }
                }))
            }
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Summary".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if let update = try Workspace.CheckForUpdates.checkForUpdates(output: &output) {
        print(UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return [
                    StrictString("This validation used Workspace \(latestStableWorkspaceVersion.string), which is no longer up to date."),
                    "To update the version used by this project, run:",
                    StrictString("$ workspace refresh scripts •use‐version \(update.string)"),
                    "(This requires a full installation. See the following link.)",
                    StrictString("\(DocumentationLink.installation.url.in(Underline.underlined))")
                    ].joinAsLines()
            }
        }).resolved().formattedAsWarning().separated(), to: &output)
    }

    try validationStatus.reportOutcome(projectName: try options.project.projectName(output: &output), output: &output)
}
