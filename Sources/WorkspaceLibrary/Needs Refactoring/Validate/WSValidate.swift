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

    var overallSuccess = true

    var summary: [(result: Bool, message: String)] = []
    func individualSuccess(message: String) {
        summary.append((result: true, message: message))
    }
    func individualFailure(message: String) {
        summary.append((result: false, message: message))
        overallSuccess = false
    }

    if ¬Environment.isInContinuousIntegration {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Refreshing
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try runRefresh(andExit: false, arguments: arguments, options: options, output: &output)

    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Validating \(Configuration.projectName)...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if options.job == .miscellaneous ∨ options.job == nil {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Validating Workspace configuration...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        if Configuration.validate() {
            individualSuccess(message: "Workspace configuration validates.")
        } else {
            individualFailure(message: "Workspace configuration fails validation. (See above for details.)")
        }

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        // Proofreading...
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        if try runProofread(andExit: false, arguments: arguments, options: options, output: &output) {
            individualSuccess(message: "Code passes proofreading.")
        } else {
            individualFailure(message: "Code fails proofreading. (See above for details.)")
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Running unit tests...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try UnitTests.test(options: options, individualSuccess: individualSuccess, individualFailure: individualFailure, output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Generating documentation...
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if try options.project.configuration.shouldGenerateDocumentation() ∧ Environment.operatingSystem == .macOS {

        WSDocumentation.generate(job: options.job, individualSuccess: individualSuccess, individualFailure: individualFailure, output: &output)
    }

    if Environment.isInContinuousIntegration {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Validating project state...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        requireBash(["git", "add", ".", "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"], silent: true)
        if (try? Shell.default.run(command: ["git", "diff", "\u{2D}\u{2D}exit\u{2D}code", "\u{2D}\u{2D}", ".", "':(exclude)*.dsidx'"])) ≠ nil {
            individualSuccess(message: "The project is up to date.")
        } else {
            individualFailure(message: "The project is out of date. (Please run “Validate” before committing.)")
        }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Summary".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    for (result, message) in summary {
        if result {
            print(["✓ " + message], in: .green)
        } else {
            print(["✗ " + message], in: .red)
        }
    }

    if let update = try Workspace.CheckForUpdates.checkForUpdates(output: &output) {
        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return StrictString(join(lines: [
                    "This validation used Workspace \(latestStableWorkspaceVersion.string), which is no longer up to date.",
                    "To update the version used by this project, run:",
                    "$ workspace refresh scripts •use‐version \(update.string)",
                    "(This requires a full installation. See the following link.)",
                    "\(DocumentationLink.installation.url)"
                    ]))
            }
        }).resolved().formattedAsWarning().separated(), to: &output)
    }

    if shouldExit {
        if overallSuccess {
            succeed(message: ["It looks like this is ready for a pull request."])
        } else {
            failTests(message: ["It looks like there are a few things left to fix."])
        }

    }
}
