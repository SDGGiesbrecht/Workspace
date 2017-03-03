/*
 HyphenMinus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct HyphenMinus : Rule {

    static let name = "Hyphen/Minus"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "\u{2D}", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "[‐/−/—/•/–]", message: "Use a hyphen (‐), minus sign (−), dash (—), bullet (•) or range (–) instead.")
                }

                let lineRange = file.contents.lineRange(for: range)
                let line = file.contents.substring(with: lineRange)

                if ¬line.contains("http") {
                    switch fileType {
                    case .markdown, .yaml, .gitignore:
                        throwError()

                    case .swift:
                        if ¬isInAliasDefinition(for: "−", at: range, in: file) {
                            throwError()
                        }

                    case .shell:
                        if line.hasPrefix("#") {
                            throwError()
                        }

                    case .workspaceConfiguration:
                        if ¬(file.contents.substring(with: file.contents.startIndex ..< range.lowerBound).contains("```shell")
                            ∧ file.contents.substring(with: range.upperBound ..< file.contents.endIndex).contains("```")) {
                                throwError()
                        }
                    }
                }
            }
        }
    }
}
