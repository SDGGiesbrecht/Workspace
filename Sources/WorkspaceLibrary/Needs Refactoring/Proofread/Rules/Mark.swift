/*
 Mark.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct Mark : Rule {

    static let name = "Mark"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        var index = file.contents.startIndex
        while let range = file.contents.scalars.firstMatch(for: "MARK\u{3A}".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
            index = range.upperBound

            let lineRange = file.contents.lineRange(for: range)
            let before = String(file.contents[lineRange.lowerBound ..< range.lowerBound])
            let after = String(file.contents[range.upperBound ..< lineRange.upperBound])

            var errorExists = false

            var errorStart = range.lowerBound
            if ¬before.hasSuffix(" // ") ∧ before ≠ "// " {
                errorExists = true
                errorStart = lineRange.lowerBound

                var scalar: String.ScalarView.Index = errorStart.samePosition(in: file.contents.scalars)
                file.contents.scalars.advance(&scalar, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
                errorStart = scalar.cluster(in: file.contents.clusters)
            }
            var errorEnd = range.upperBound
            if ¬after.hasPrefix(" \u{2D} ") {
                errorExists = true

                var scalar: String.ScalarView.Index = errorEnd.samePosition(in: file.contents.scalars)
                file.contents.scalars.advance(&scalar, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces ∪ ["\u{2D}"] })))
                errorEnd = scalar.cluster(in: file.contents.clusters)
            }

            if errorExists {
                errorNotice(status: &status, file: file, range: errorStart ..< errorEnd, replacement: "// MARK\u{3A} \u{2D} ", message: "Use “// MARK\u{3A} \u{2D} ” instead.")
            }
        }
    }
}
