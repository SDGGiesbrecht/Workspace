/*
 Metadata.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

public enum Metadata {
    // [_Warning: These are now duplicates._]

    // Do not forget to increment the version in “.Workspace Configuration.txt” as well.
    public static let latestStableVersion = Version(0, 7, 3)
    public static let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

    public static let packageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!
}
