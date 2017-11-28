/*
 WSValidate.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

func runValidate(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: inout Command.Output) throws {

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
            validationStatus.passStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Workspace configuration validates."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Workspace configuration fails validation. (See above for details.)"
                }
            }))
        }

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Proofreading...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        if try runProofread(andExit: false, arguments: arguments, options: options, output: &output) {
            validationStatus.passStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Code passes proofreading."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Code fails proofreading. (See above for details.)"
                }
            }))
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Running unit tests...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try UnitTests.test(options: options, validationStatus: &validationStatus, output: &output)

    #if !os(Linux)

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Generating documentation...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Workspace.Document.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Checking documentation coverage...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Workspace.Validate.DocumentationCoverage.executeAsStep(options: options, validationStatus: &validationStatus, output: &output)

    #endif

    if Environment.isInContinuousIntegration {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Validating project state...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        requireBash(["git", "add", ".", "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"], silent: true)
        if (try? Shell.default.run(command: ["git", "diff", "\u{2D}\u{2D}exit\u{2D}code", "\u{2D}\u{2D}", ".", "':(exclude)*.dsidx'"])) ≠ nil {
            validationStatus.passStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "The project is up to date."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacingText({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "The project is out of date. (Please run “Validate” before committing.)"
                }
            }))
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Summary".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if let update = try Workspace.CheckForUpdates.checkForUpdates(output: &output) {
        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
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
