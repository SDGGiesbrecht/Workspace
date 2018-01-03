/*
 DocumentationOfCompilationConditions.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct DocumentationOfCompilationConditions : Rule {

    static let name = "Documentation of Compilation Conditions"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "\u{23}if".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                let lineRange = file.contents.lineRange(for: range)
                let line = String(file.contents[lineRange])

                if ¬line.contains("MARK"),
                    lineRange.upperBound ≠ file.contents.endIndex,
                    String(file.contents.suffix(from: lineRange.upperBound)).scalars.prefix(upTo: "#".scalars)?.contents.contains("public".scalars) ?? false {

                    let nextCharacterRange = lineRange.upperBound ..< file.contents.index(after: lineRange.upperBound)
                    let nextLineRange = file.contents.lineRange(for: nextCharacterRange)
                    let nextLine = String(file.contents[nextLineRange])

                    if ¬nextLine.contains("// MARK\u{3A} \u{2D} ") {
                        errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Add “// MARK\u{3A} \u{2D} \u{23}if ...” on the next line for generated documentation.")
                    }
                }
            }

            index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "\u{23}else".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                let lineRange = file.contents.lineRange(for: range)
                let line = String(file.contents[lineRange])

                if ¬line.contains("MARK"),
                    lineRange.upperBound ≠ file.contents.endIndex,
                    String(file.contents.suffix(from: lineRange.upperBound)).scalars.prefix(upTo: "#".scalars)?.contents.contains("public".scalars) ?? false {

                    let nextCharacterRange = lineRange.upperBound ..< file.contents.index(after: lineRange.upperBound)
                    let nextLineRange = file.contents.lineRange(for: nextCharacterRange)
                    let nextLine = String(file.contents[nextLineRange])

                    if ¬nextLine.contains("// MARK\u{3A} \u{2D} ") {
                        errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Add “// MARK\u{3A} \u{2D} \u{23}if ...” on the next line for generated documentation.")
                    }
                }
            }
        }
    }
}
