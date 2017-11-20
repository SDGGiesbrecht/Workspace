/*
 WSRefresh.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

let instructionsAfterRefresh: String = {
    if Environment.operatingSystem == .macOS ∧ Configuration.manageXcode {
        return "Open “\(Xcode.projectFilename)” to work on the project."
    } else {
        return ""
    }
}()

func runRefresh(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: inout Command.Output) throws {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Refreshing \(try options.project.projectName(output: &output))...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Scripts
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try Workspace.Refresh.Scripts.command.execute(withArguments: arguments, options: options, output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating Workspace configuration...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    var newResponsibilities: [(option: Option, value: String, comment: [String]?)] = []

    for (option, automaticValue, documentationPage) in Option.automaticRepsonsibilities {

        if ¬Configuration.optionIsDefined(option) {

            if Configuration.automaticallyTakeOnNewResponsibilites {
                newResponsibilities.append((option: option, value: automaticValue, comment: [
                    "Workspace took responsibility for this automatically.",
                    "(Because “\(Option.automaticallyTakeOnNewResponsibilites.key)” is “\(Configuration.trueOptionValue)”)",
                    "For more information about “\(option.key)”, see:",
                    documentationPage.url
                    ]))
            } else {
                printWarning([
                    "The configuration option “\(option.key)” is now available.",
                    "For more information, see:",
                    documentationPage.url,
                    "(To silence this notice, set “\(option.key)” to “\(option.defaultValue)”)"
                    ])
            }
        }
    }

    if Configuration.automaticallyTakeOnNewResponsibilites {
        Configuration.addEntries(entries: newResponsibilities, output: &output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating Git configuration...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DGit.updateGitConfiguraiton(output: &output)

    if Configuration.manageReadMe {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating read‐me...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try ReadMe.refreshReadMe(output: &output)
    }

    if Configuration.manageLicence {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating licence...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Licence.refreshLicence(output: &output)
    }

    if Configuration.manageContributingInstructions {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating contributing instructions...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try ContributingInstructions.refreshContributingInstructions(output: &output)
    } else {
        ContributingInstructions.relinquishControl(output: &output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Continuous Integration
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.ContinuousIntegration.command.execute(withArguments: arguments, options: options, output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Resources
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.Resources.command.execute(withArguments: arguments, options: options, output: &output)

    if Configuration.manageFileHeaders {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating file headers...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try FileHeaders.refreshFileHeaders(output: &output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating examples...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    Examples.refreshExamples(output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating inherited documentation...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DocumentationInheritance.refreshDocumentation(output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Normalizing files...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    normalizeFiles(output: &output)

    if Configuration.manageXcode ∧ Environment.operatingSystem == .macOS {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Refreshing Xcode project...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Xcode.refreshXcodeProjects(output: &output)
    }
    if Environment.operatingSystem == .macOS {
        Xcode.enableProofreading(output: &output)
    }

    if shouldExit {

        succeed(message: [
            "\(try Repository.packageRepository.projectName(output: &output)) is refreshed and ready.",
            instructionsAfterRefresh
            ])
    }
}
