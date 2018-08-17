/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

public enum Workspace {

    private static let projectName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "project"
        }
    })
    private static let projectDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "The location of the target project if it is not at the current working directory."
        }
    })
    internal static let projectOption = Option(name: projectName, description: projectDescription, type: ArgumentType.path)

    internal static let standardOptions: [AnyOption] = [projectOption]

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "workspace"
        }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "automates management of Swift projects."
        }
    })

    public static let command = Command(name: name, description: description, subcommands: [

        // Primary Workflow
        Workspace.Refresh.command,
        Workspace.Validate.command,
        Workspace.Document.command,

        // Xcode Build Phase
        Workspace.Proofread.command,

        // Individual Steps
        Workspace.Normalize.command,
        Workspace.Test.command,

        // Other
        Workspace.CheckForUpdates.command
        ])
}
