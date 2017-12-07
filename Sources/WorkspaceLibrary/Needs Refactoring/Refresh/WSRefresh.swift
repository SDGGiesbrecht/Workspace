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

func instructionsAfterRefresh() throws -> String {
    #if os(Linux)
        return ""
    #else
        if let xcodeProject = try Repository.packageRepository.xcodeProjectFile()?.lastPathComponent {
            return "Open “\(xcodeProject)” to work on the project."
        } else {
            return ""
        }
    #endif
}

func runRefresh(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: inout Command.Output) throws {

    // [_Workaround: Prevents resolution from breaking JSON parsing. (SDGCommandLine 0.1.3)_]
    try Shell.default.run(command: ["swift", "package", "resolve"])

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

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Read‐Me
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.ReadMe.command.execute(withArguments: arguments, options: options, output: &output)

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

    try Examples.refreshExamples(output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating inherited documentation...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DocumentationInheritance.refreshDocumentation(output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Normalizing files...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    normalizeFiles(output: &output)

    #if !os(Linux)
        if Configuration.manageXcode ∧ Environment.operatingSystem == .macOS {

            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            print("Refreshing Xcode project...".formattedAsSectionHeader(), to: &output)
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

            try DXcode.refreshXcodeProjects(output: &output)
        }
        if Environment.operatingSystem == .macOS {
            try DXcode.enableProofreading(output: &output)
        }
    #endif

    if shouldExit {

        succeed(message: [
            "\(try Repository.packageRepository.projectName(output: &output)) is refreshed and ready.",
            try instructionsAfterRefresh()
            ])
    }
}
