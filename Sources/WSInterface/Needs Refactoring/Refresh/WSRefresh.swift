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
import WSGeneralImports
import WorkspaceConfiguration
import WSGitHub
import WSExamples

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
    if try options.project.configuration(output: output).provideWorkflowScripts {
        try Workspace.Refresh.Scripts.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Git
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.configuration(output: output).git.manage {
        try Workspace.Refresh.Git.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Read‐Me
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.configuration(output: output).documentation.readMe.manage {
        try Workspace.Refresh.ReadMe.command.execute(withArguments: arguments, options: options, output: output)
    }

    if try options.project.configuration(output: output).licence.manage {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        output.print("Updating licence...".formattedAsSectionHeader())
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try Licence.refreshLicence(output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // GitHub
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.configuration(output: output).gitHub.manage {
        try Workspace.Refresh.GitHub.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Continuous Integration
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    if try options.project.configuration(output: output).continuousIntegration.manage {
        try Workspace.Refresh.ContinuousIntegration.command.execute(withArguments: arguments, options: options, output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Resources
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.Resources.command.execute(withArguments: arguments, options: options, output: output)

    if try Repository.packageRepository.configuration(output: output).fileHeaders.manage {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        output.print("Updating file headers...".formattedAsSectionHeader())
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        try FileHeaders.refreshFileHeaders(output: output)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Examples
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    try Workspace.Refresh.Examples.command.execute(withArguments: arguments, options: options, output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    output.print("Updating inherited documentation...".formattedAsSectionHeader())
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try DocumentationInheritance.refreshDocumentation(output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Normalization
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try Workspace.Normalize.executeAsStep(options: options, output: output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Xcode
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    #if !os(Linux)
    if try options.project.configuration(output: output).xcode.manage {
        try Workspace.Refresh.Xcode.command.execute(withArguments: arguments, options: options, output: output)
    }
    #endif

    if shouldExit {

        succeed(message: [
            "\(try Repository.packageRepository.projectName()) is refreshed and ready.",
            try instructionsAfterRefresh()
            ])
    }
}
