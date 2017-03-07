/*
 Disjunction.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct Disjunction : Rule {

    static let name = "Disjunction"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var message = "Use “∨” instead."
            if fileType == .swift {
                message += " (Import SDGLogic.)"
            }

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "\u{7C}|", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "∨", message: message)
                }

                switch fileType {
                case .workspaceConfiguration, .json, .yaml, .gitignore, .shell, .html, .css, .javaScript:
                    throwError()

                case .swift:
                    if ¬isInAliasDefinition(for: "∨", at: range, in: file)
                        ∧ ¬isInConditionalCompilationStatement(at: range, in: file) {
                        throwError()
                    }

                case .markdown:
                    if ¬isInConditionalCompilationStatement(at: range, in: file) {
                        throwError()
                    }
                }
            }
        }
    }
}
