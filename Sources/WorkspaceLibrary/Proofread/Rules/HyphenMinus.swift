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

                    case .swift:
                        if ¬isInAliasDefinition(for: "−", at: range, in: file)
                            ∧ ¬file.contents.substring(from: range.upperBound).hasPrefix(">")
                            ∧ ¬file.contents.substring(to: range.lowerBound).hasSuffix("// MARK: ")
                            ∧ ¬file.contents.substring(to: range.lowerBound).hasSuffix("/// ")
                            ∧ ¬file.contents.substring(to: range.lowerBound).hasSuffix("///     ") {
                            throwError()
                        }

                    case .shell, .gitignore:
                        if line.hasPrefix("#") {
                            throwError()
                        }

                    case .workspaceConfiguration:
                        if ¬(file.contents.substring(with: file.contents.startIndex ..< range.lowerBound).contains("```shell")
                            ∧ file.contents.substring(with: range.upperBound ..< file.contents.endIndex).contains("```")) {
                            throwError()
                        }

                    case .markdown:
                        if ¬file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound).isWhitespace
                            ∧ ¬line.contains("<\u{21}\u{2D}\u{2D}")
                            ∧ ¬line.contains("\u{2D}\u{2D}>")
                            ∧ ¬((file.contents.substring(to: range.lowerBound).contains("```shell") ∨ file.contents.substring(to: range.lowerBound).contains("```swift")) ∧ file.contents.substring(from: range.upperBound).contains("```"))
                            ∧ ¬line.contains("](")
                            ∧ ¬line.contains("`") {
                            throwError()
                        }

                    case .yaml:
                        if ¬file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound).isWhitespace
                            ∧ ¬file.path.string.hasSuffix(".travis.yml") {
                            throwError()
                        }
                    }
                }
            }
        }
    }
}
