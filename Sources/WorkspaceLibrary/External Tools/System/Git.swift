/*
 Git.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

typealias Git = _Git // Shared from SDGCommandLine.
extension Git {

    // MARK: - Static Properties

    static let `default` = _default // Shared from SDGCommandLine.

    // MARK: - Usage

    func versions(of package: Package, output: inout Command.Output) throws -> Set<Version> {
        return try _versions(of: package, output: &output) // Shared from SDGCommandLine.
    }

    func ignoredFiles(output: inout Command.Output) throws -> [URL] {
        return try _ignoredFiles(output: &output) // Shared from SDGCommandLine.
    }
}
