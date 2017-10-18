/*
 Program.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

public func run() {
    SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.Workspace", version: nil, packageURL: URL(string: "https://github.com/SDGGiesbrecht/Workspace"))
    Workspace.command.executeAsMain()
}
