/*
 PackageCLI.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGExportedCommandLineInterface

import WSProject

internal struct PackageCLI {

    // MARK: - Initialization

    internal init(tools: [URL], localizations: [LocalizationIdentifier]) {
        var commands: [StrictString: [LocalizationIdentifier: CommandInterface]] = [:]
        for tool in tools {
            for localization in localizations {
                if let interface = try? CommandInterface.loadInterface(of: tool, in: localization.code).get() {
                    commands[interface.identifier, default: [:]][localization] = interface
                }
            }
        }
        self.commands = commands
    }

    // MARK: - Properties

    let commands: [StrictString: [LocalizationIdentifier: CommandInterface]]
}
