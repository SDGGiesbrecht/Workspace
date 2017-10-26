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

    func copy(script: String) {
        let origin = Workspace.resources.subfolderOrFile("Scripts/\(script)")

        let updated = require() { try File(at: origin) }
        if ¬updated.isExecutable {
            fatalError(message: [
                "\(script) is not executable.",
                "There may be a bug in Workspace."
                ])
        }
        var inRepository = File(possiblyAt: RelativePath(script), executable: true)

        inRepository.contents = updated.contents
        require() { try inRepository.write() }
    }

    // Refresh Workspace

    copy(script: "Refresh Workspace (macOS).command")

    if Configuration.supportLinux {
        // Checked into repository, so dependent on configuration.

        copy(script: "Refresh Workspace (Linux).sh")
    }

    // Validate Changes

    copy(script: "Validate Changes (macOS).command")

    if Environment.operatingSystem == .linux {
        // Not checked into repository, so dependent on environment.

        copy(script: "Validate Changes (Linux).sh")
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
        Configuration.addEntries(entries: newResponsibilities)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating Git configuration...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DGit.updateGitConfiguraiton()

    if Configuration.manageReadMe {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating read‐me...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ReadMe.refreshReadMe()
    }

    if Configuration.manageLicence {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating licence...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        Licence.refreshLicence()
    }

    if Configuration.manageContributingInstructions {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating contributing instructions...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContributingInstructions.refreshContributingInstructions()
    } else {
        ContributingInstructions.relinquishControl(output: &output)
    }

    if Configuration.manageContinuousIntegration {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Updating continuous integration configuration...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContinuousIntegration.refreshContinuousIntegrationConfiguration()
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

        FileHeaders.refreshFileHeaders()
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating examples...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    Examples.refreshExamples()

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Updating inherited documentation...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DocumentationInheritance.refreshDocumentation()

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Normalizing files...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    normalizeFiles()

    if Configuration.manageXcode ∧ Environment.operatingSystem == .macOS {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        print("Refreshing Xcode project...".formattedAsSectionHeader(), to: &output)
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        Xcode.refreshXcodeProjects()
    }
    if Environment.operatingSystem == .macOS {
        Xcode.enableProofreading()
    }

    if shouldExit {

        succeed(message: [
            "\(Configuration.projectName) is refreshed and ready.",
            instructionsAfterRefresh
            ])
    }
}
