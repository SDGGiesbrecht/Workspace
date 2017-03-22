/*
 ExitCode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

typealias ExitCode = Int32

extension ExitCode {
    static let succeeded: Int32 = EXIT_SUCCESS
    static let failed: Int32 = EXIT_FAILURE
    static let testsFailed: Int32 = 2
}
