/*
 QuotationMarks.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct QuotationMarks : Rule {

    static let name = "Quotation Marks"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {
            var index = file.contents.startIndex
            while let range = file.contents.range(of: "\u{22}", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "[“/”/„/«/»/′′/״]", message: "Use quotation marks (“, ”, „, «, »), double prime (′′) or gershayim (״) instead.")
                }

                let filePrefix = file.contents.substring(to: range.lowerBound)
                let fileSuffix = file.contents.substring(from: range.upperBound)

                let lineRange = file.contents.lineRange(for: range)
                let linePrefix = file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound)
                let lineSuffix = file.contents.substring(with: range.upperBound ..< lineRange.upperBound)

                var linePrefixWithoutIndentation = linePrefix
                while let first = linePrefixWithoutIndentation.unicodeScalars.first,
                    CharacterSet.whitespaces.contains(first) {
                        linePrefixWithoutIndentation.unicodeScalars.removeFirst()
                }

                switch fileType {
                case .markdown, .workspaceConfiguration:
                    if ¬(filePrefix.contains("```") ∧ fileSuffix.contains("```")) /* Sample Code */
                    ∧ ¬(linePrefix.contains("`") ∧ lineSuffix.contains("`")) {
                        throwError()
                    }
                case .swift:
                    if linePrefix.hasSuffix("\u{5C}") // String Literal */
                        ∨ (linePrefixWithoutIndentation.hasPrefix("//") /* Comment */
                            ∧ ¬(filePrefix.contains("```") ∧ fileSuffix.contains("```")) /* Sample Code */) {
                        throwError()
                    }
                case .shell, .yaml:
                    if linePrefix.contains("#") /* Comment */ {
                        throwError()
                    }
                case .gitignore:
                    throwError()
                }

            }
        }
    }
}
