/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct ColonSpacing: Rule {

    static let name = "Colon Spacing"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .swift {

            var index = file.contents.startIndex

            while let range = file.contents.range(of: ":", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                let line = file.contents.substring(with: file.contents.lineRange(for: range))
                let inWhereClause = line.contains("where ")
                if let preceding = file.contents.substring(to: range.lowerBound).characters.last {

                    if preceding == " " {
                        let precedingIndex = file.contents.index(before: range.lowerBound)
                        let errorRange = precedingIndex ..< range.upperBound

                        if ¬inWhereClause {
                            errorNotice(status: &status, file: file, range: errorRange, replacement: ":", message: "Colons should not be preceded by spaces.")
                        }
                    } else {

                        if inWhereClause {
                            errorNotice(status: &status, file: file, range: range, replacement: " :", message: "In where clauses, colons should be preceded by spaces.")
                        }
                    }

                }

                let following = file.contents.substring(from: range.upperBound)
                if let followingCharacter = file.contents.substring(from: range.upperBound).unicodeScalars.first {

                    if ¬CharacterSet.whitespacesAndNewlines.contains(followingCharacter) {

                        if ¬following.hasPrefix("\u{22}") /* End of string literal */
                            ∧ ¬following.hasPrefix("//") /* URL */ {
                            errorNotice(status: &status, file: file, range: range, replacement: ": ", message: "Colons should be followed by a space.")
                        }
                    }
                }
            }
        }
    }
}
