/*
 NotEqual.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct NotEqual : Rule {

    static let name = "Not Equal"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var message = "Use “≠” instead."
            if fileType == .swift {
                message += " (Import SDGLogic.)"
            }

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "\u{21}\u{3D}", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "≠", message: message)
                }

                switch fileType {
                case .workspaceConfiguration, .markdown, .yaml, .gitignore:
                    throwError()

                case .swift:
                    if ¬isInAliasDefinition(for: "≠", at: range, in: file) {
                        throwError()
                    }

                case .shell:
                    let lineRange = file.contents.lineRange(for: range)
                    let linePrefix = file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound)
                    let lineSuffix = file.contents.substring(with: range.upperBound ..< lineRange.upperBound)

                    if ¬(linePrefix.contains("[") ∧ lineSuffix.contains("]")) {
                        throwError()
                    }

                }
            }
        }
    }
}
