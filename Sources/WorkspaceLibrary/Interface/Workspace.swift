/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

public enum Workspace {

    private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
        switch localization {
        case .englishCanada:
            return "workspace"
        }
    })

    private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
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

        // New Projects
        Workspace.Initialize.command,

        // Xcode Build Phase
        Workspace.Proofread.command,

        // Other
        Workspace.CheckForUpdates.command
        ])
}
