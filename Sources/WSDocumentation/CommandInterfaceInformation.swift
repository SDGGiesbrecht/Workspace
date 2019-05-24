/*
 CommandInterfaceInformation.swift

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

internal struct CommandInterfaceInformation {

    // MARK: - Initialization

    internal init () {}

    // MARK: - Properties

    internal var interfaces: [LocalizationIdentifier: CommandInterface] = [:]
    internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]
}
