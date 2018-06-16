/*
 RepositoryConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to the project repository.
public struct RepositoryConfiguration: Codable {

    /// A set of file extensions which source operations should ignore.
    ///
    /// These will not receive headers or be proofread.
    ///
    /// Workspace automatically skips files it does not understand, but it prints a warning first. These warnings can be silenced by adding the file type to this list. For standard file types related to Swift projects, please [request that support be added](https://github.com/SDGGiesbrecht/Workspace/issues).
    public var ignoredFileTypes: Set<String> = [
        "dsidx",
        "DS_Store",
        "nojekyll",
        "plist",
        "pins",
        "png",
        "resolved",
        "svg",
        "testspec",
        "tgz",
        "txt"
    ]
}
