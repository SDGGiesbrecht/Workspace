/*
 LicenceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to file headers.
public struct FileHeaderConfiguration: Codable {

    /// Whether or not to manage the project file headers.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// The entire contents of the file header.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    public var contents: Lazy<String> = Lazy<String>() { configuration in
        // [_Warning: Not documented yet._]
        // [_Warning: Not implemented yet._]
        return ""
    }
}
