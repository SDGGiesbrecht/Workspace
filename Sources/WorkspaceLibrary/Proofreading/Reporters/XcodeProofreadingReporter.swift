/*
 XcodeProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

class XcodeProofreadingReporter : ProofreadingReporter {

    // MARK: - Static Properties

    static let `default` = XcodeProofreadingReporter()

    // MARK: - Initialization

    private init() {

    }

    // MARK: - ProofreadingReporter

    func reportParsing(file: String, to output: Command.Output) {
        // Unneeded.
    }

    func report(violation: StyleViolation, to output: Command.Output) {

        let file = violation.file.contents
        let lines = file.lines

        let path = violation.file.location.path

        let lineIndex = violation.range.lowerBound.line(in: lines)
        let lineNumber: Int = lines.distance(from: lines.startIndex, to: lineIndex) + 1

        let utf16LineStart = lineIndex.samePosition(in: file.clusters).samePosition(in: file.utf16)!
        let utf16ViolationStart = violation.range.lowerBound.samePosition(in: file.utf16)!
        let column: Int = file.utf16.distance(from: utf16LineStart, to: utf16ViolationStart) + 1

        output.print("\(path):\(lineNumber):\(column): warning: \(violation.message.resolved()) (\(violation.ruleIdentifier.resolved()))")
    }
}
