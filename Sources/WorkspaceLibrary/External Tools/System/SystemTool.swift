/*
 SystemTool.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

typealias SystemTool = _ExternalTool // Shared from SDGCommandLine.

extension SystemTool {

    internal func executeInCompatibilityMode(with arguments: [String], output: inout Command.Output, silently: Bool = false, autoquote: Bool = true) throws -> String {
        return try _executeInCompatibilityMode(with: arguments, output: &output, silently: silently, autoquote: autoquote) // Shared from SDGCommandLine.
    }
}
