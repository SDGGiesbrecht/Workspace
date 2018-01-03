/*
 SwiftTool.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

typealias SwiftTool = _Swift // Shared from SDGCommandLine.
extension SwiftTool {

    // MARK: - Static Properties

    static let `default` = _default // Shared from SDGCommandLine.

    // MARK: - Usage

    func packageStructure(output: inout Command.Output) throws -> (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)]) {
        return try _packageStructure(output: &output) // Shared from SDGCommandLine.
    }
}
