/*
 Mark.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct Mark : Rule {

    static let name = "Mark"

    static func check(file: File, status: inout Bool) {

        var index = file.contents.startIndex
        while let range = file.contents.range(of: "MARK\u{3A}", in: index ..< file.contents.endIndex) {
            index = range.upperBound

            let lineRange = file.contents.lineRange(for: range)
            let before = file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound)
            let after = file.contents.substring(with: range.upperBound ..< lineRange.upperBound)

            var errorExists = false

            var errorStart = range.lowerBound
            if ¬before.hasSuffix(" // ") ∧ before ≠ "// " {
                errorExists = true
                errorStart = lineRange.lowerBound
                file.contents.advance(&errorStart, past: CharacterSet.whitespaces)
            }
            var errorEnd = range.upperBound
            if ¬after.hasPrefix(" \u{2D} ") {
                errorExists = true
                file.contents.advance(&errorEnd, past: CharacterSet.whitespaces.union(CharacterSet(charactersIn: "\u{2D}")))
            }

            if errorExists {
                errorNotice(status: &status, file: file, range: errorStart ..< errorEnd, replacement: "// MARK\u{3A} \u{2D} ", message: "Use “// MARK\u{3A} \u{2D} ” instead.")
            }
        }
    }
}
