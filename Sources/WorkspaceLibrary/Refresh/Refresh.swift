/*
 Refresh.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

let instructionsAfterRefresh: String = {
    if Environment.operatingSystem == .macOS ∧ Configuration.manageXcode {
        return "Open “\(Xcode.projectFilename)” to work on the project."
    } else {
        return ""
    }
}()

func runRefresh(andExit shouldExit: Bool) {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Refreshing \(Configuration.projectName)..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating Workspace commands..."])
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
    printHeader(["Updating Workspace configuration..."])
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
    printHeader(["Updating Git configuration..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    Git.updateGitConfiguraiton()

    if Configuration.manageReadMe {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating read‐me..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ReadMe.refreshReadMe()
    }

    if Configuration.manageLicence {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating licence..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        Licence.refreshLicence()
    }

    if Configuration.manageContributingInstructions {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating contributing instructions..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContributingInstructions.refreshContributingInstructions()
    } else {
        ContributingInstructions.relinquishControl()
    }

    if Configuration.manageContinuousIntegration {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating continuous integration configuration..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        ContinuousIntegration.refreshContinuousIntegrationConfiguration()
    } else {
        ContinuousIntegration.relinquishControl()
    }

    if Configuration.manageFileHeaders {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating file headers..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        FileHeaders.refreshFileHeaders()
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating examples..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    Examples.refreshExamples()

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating inherited documentation..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DocumentationInheritance.refreshDocumentation()

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Normalizing files..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    normalizeFiles()

    if Configuration.manageXcode ∧ Environment.operatingSystem == .macOS {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Refreshing Xcode project..."])
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
