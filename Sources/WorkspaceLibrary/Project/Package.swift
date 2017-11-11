/*
 Package.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

typealias Package = _Package // Shared from SDGCommandLine.
extension Package {

    // MARK: - Initialization

    init(url: URL) {
        self.init(_url: url) // Shared from SDGCommandLine.
    }

    // MARK: - Properties

    func latestVersion(output: inout Command.Output) throws -> Version? {
        return try versions(output: &output).sorted().last
    }

    func versions(output: inout Command.Output) throws -> Set<Version> {
        return try Git.default.versions(of: self, output: &output)
    }
}
