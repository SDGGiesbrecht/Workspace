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

let latestStableWorkspaceVersion = Version(0, 1, 0)
private let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

public func run() { // [_Exempt from Code Coverage_]
    SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.Workspace", version: thisVersion, packageURL: URL(string: "https://github.com/SDGGiesbrecht/Workspace"))
    Workspace.command.executeAsMain()
}
