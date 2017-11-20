/*
 Xcode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

typealias Xcode = _Xcode // Shared from SDGCommandLine.
extension Xcode {

    // MARK: - Static Properties

    static let `default` = Xcode(version: Version(9, 0))

    // MARK: - Initialization

    convenience init(version: Version) {
        self.init(_version: version)
    }

    // MARK: - Usage

    func projectFile() throws -> URL? {
        let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: FileManager.default.currentDirectoryPath), includingPropertiesForKeys: [], options: [])

        for file in files where file.pathExtension == "xcodeproj" {
            return file
        }

        return nil
    }
}
