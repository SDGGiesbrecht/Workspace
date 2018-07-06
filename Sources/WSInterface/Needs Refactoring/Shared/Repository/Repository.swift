/*
 Repository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

public struct Repository {

    // MARK: - Constants

    private static let fileManager = FileManager.default
    static let repositoryPath: AbsolutePath = AbsolutePath(fileManager.currentDirectoryPath)

    // MARK: - Files

    static func unsupportedPathType() -> Never {
        fatalError([
            "Unsupported path type.",
            "This may indicate a bug in Workspace."
            ].joinedAsLines())
    }

    static func absolute<P : Path>(_ path: P) -> AbsolutePath {
        if let absolute = path as? AbsolutePath {
            return absolute
        } else if let relative = path as? RelativePath {
            return repositoryPath.subfolderOrFile(relative.string)
        } else {
            unsupportedPathType()
        }
    }
}
