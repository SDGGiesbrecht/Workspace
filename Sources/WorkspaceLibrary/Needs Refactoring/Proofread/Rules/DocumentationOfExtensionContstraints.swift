/*
 DocumentationOfExtensionContstraints.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct DocumentationOfExtensionConstraints : Rule {

    static let name = "Documentation of Extension Constraints"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "extension ".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                let lineRange = file.contents.lineRange(for: range)
                let line = String(file.contents[lineRange])
                if line.contains(" where ") {

                    if lineRange.upperBound ≠ file.contents.endIndex {

                        let nextCharacterRange = lineRange.upperBound ..< file.contents.index(after: lineRange.upperBound)
                        let nextLineRange = file.contents.lineRange(for: nextCharacterRange)
                        let nextLine = String(file.contents[nextLineRange])

                        if ¬nextLine.contains("// MARK\u{3A} \u{2D} ") {
                            errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Add “// MARK\u{3A} \u{2D} where ...” on the next line for generated documentation.")
                        }
                    }
                }
            }
        }
    }
}
