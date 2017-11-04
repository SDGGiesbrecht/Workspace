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

func runRefresh(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: inout Command.Output) {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Refreshing \(Configuration.projectName)...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating Workspace commands...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    func write(scriptContents: String, to destination: String) {
        var script = File(possiblyAt: RelativePath(destination), executable: true)
        script.contents = scriptContents
        require() { try script.write(output: &output) }
    }

    // Refresh Workspace

    write(scriptContents: Resources.Scripts.refreshWorkspaceMacOS, to: "Refresh Workspace (macOS).command")

    if Configuration.supportLinux {
        // Checked into repository, so dependent on configuration.

        write(scriptContents: Resources.Scripts.refreshWorkspaceLinux, to: "Refresh Workspace (Linux).sh")
    }

    // Validate Changes

    write(scriptContents: Resources.Scripts.validateChangesMacOS, to: "Validate Changes (macOS).command")

    if Environment.operatingSystem == .linux {
        // Not checked into repository, so dependent on environment.

        write(scriptContents: Resources.Scripts.validateChangesLinux, to: "Validate Changes (Linux).sh")
    }

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

        ReadMe.refreshReadMe(output: &output)
    }

    if Configuration.manageLicence {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating licence...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        Licence.refreshLicence(output: &output)
    }

    if Configuration.manageContributingInstructions {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating contributing instructions...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContributingInstructions.refreshContributingInstructions(output: &output)
    } else {
        ContributingInstructions.relinquishControl(output: &output)
    }

    if Configuration.manageContinuousIntegration {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating continuous integration configuration...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContinuousIntegration.refreshContinuousIntegrationConfiguration(output: &output)
    } else {
        ContinuousIntegration.relinquishControl(output: &output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Resources
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    require() { try Workspace.Refresh.Resources.command.execute(withArguments: arguments, options: options, output: &output) }

    if Configuration.manageFileHeaders {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating file headers...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        FileHeaders.refreshFileHeaders(output: &output)
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

        Xcode.refreshXcodeProjects(output: &output)
    }
    if Environment.operatingSystem == .macOS {
        Xcode.enableProofreading(output: &output)
    }

    if shouldExit {

        succeed(message: [
            "\(Configuration.projectName) is refreshed and ready.",
            instructionsAfterRefresh
            ])
    }
}
