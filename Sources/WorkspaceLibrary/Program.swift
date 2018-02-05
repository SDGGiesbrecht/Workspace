/*
 Program.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

// Do not forget to increment the version in “.Workspace Configuration.txt” as well.
let latestStableWorkspaceVersion = Version(0, 4, 4)
private let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

let workspacePackageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!

public func run() { // [_Exempt from Test Coverage_]

    // [_Workaround: Make sure the correct repository gets loaded before moving into any other directory._]
    _ = Repository.packageRepository

    SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.Workspace", version: thisVersion, packageURL: workspacePackageURL)
    Workspace.command.executeAsMain()
}
