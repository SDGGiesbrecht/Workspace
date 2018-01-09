/*
 Rule.swift

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

extension Rule {

    static func isInAliasDefinition(for alias: String, at location: Range<String.Index>, in file: File) -> Bool {

        let lineRange = file.contents.lineRange(for: location)

        if lineRange.lowerBound ≠ file.contents.startIndex,
            file.contents[file.contents.lineRange(for: file.contents.index(before: lineRange.lowerBound) ..< lineRange.lowerBound)].contains("func " + alias) {
            return true
        } else if file.contents[lineRange].contains("RecommendedOver") {
            return true
        } else {
            return false
        }
    }

    static func isInConditionalCompilationStatement(at location: Range<String.Index>, in file: File) -> Bool {
        let lineRange = file.contents.lineRange(for: location)
        let line = String(file.contents[lineRange])
        return line.contains("\u{23}if") ∨ line.contains("\u{23}elseif")
    }
}
