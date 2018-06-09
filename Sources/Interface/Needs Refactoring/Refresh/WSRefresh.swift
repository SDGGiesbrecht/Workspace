/*
 WSRefresh.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import GeneralImports
import WorkspaceConfiguration

func instructionsAfterRefresh() throws -> String {
    if let xcodeProject = try Repository.packageRepository.xcodeProject()?.lastPathComponent {
        return "Open “\(xcodeProject)” to work on the project."
    } else {
        return ""
    }
}

func runRefresh(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: Command.Output) throws {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Refreshing \(try options.project.projectName())...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Scripts
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.cachedConfiguration().provideWorkflowScripts {
        try Workspace.Refresh.Scripts.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Updating Git configuration...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try DGit.updateGitConfiguraiton(output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Read‐Me
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.cachedConfiguration().documentation.readMe.manage {
        try Workspace.Refresh.ReadMe.command.execute(withArguments: arguments, options: options, output: output)
    }

    if try options.project.cachedConfiguration().licence.manage {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        output.print("Updating licence...".formattedAsSectionHeader())
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Licence.refreshLicence(output: output)
    }

    if try options.project.cachedConfiguration().gitHub.manage {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        output.print("Updating contributing instructions...".formattedAsSectionHeader())
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try ContributingInstructions.refreshContributingInstructions(output: output)
    } else {
        ContributingInstructions.relinquishControl(output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Continuous Integration
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.configuration.shouldManageContinuousIntegration() {
        try Workspace.Refresh.ContinuousIntegration.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Resources
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.Resources.command.execute(withArguments: arguments, options: options, output: output)

    if try Repository.packageRepository.cachedConfiguration().fileHeaders.manage {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        output.print("Updating file headers...".formattedAsSectionHeader())
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try FileHeaders.refreshFileHeaders(output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Updating examples...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try Examples.refreshExamples(output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Updating inherited documentation...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    DocumentationInheritance.refreshDocumentation(output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Normalization
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try Workspace.Normalize.executeAsStep(options: options, output: output)

    #if !os(Linux)
        if try Repository.packageRepository.cachedConfiguration().xcode.manage {

            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            output.print("Refreshing Xcode project...".formattedAsSectionHeader())
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

            try DXcode.refreshXcodeProjects(output: output)
        }
        if Environment.operatingSystem == .macOS {
            try DXcode.enableProofreading(output: output)
        }
    #endif

    if shouldExit {

        succeed(message: [
            "\(try Repository.packageRepository.projectName()) is refreshed and ready.",
            try instructionsAfterRefresh()
            ])
    }
}
