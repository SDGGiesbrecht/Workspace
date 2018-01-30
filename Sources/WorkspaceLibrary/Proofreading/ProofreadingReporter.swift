/*
 ProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

protocol ProofreadingReporter {

    func reportParsing(file: String, to output: inout Command.Output)
    func report(violation: StyleViolation, to output: inout Command.Output)
}
