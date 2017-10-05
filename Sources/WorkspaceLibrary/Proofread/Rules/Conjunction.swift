/*
 Conjunction.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct Conjunction : Rule {

    static let name = "Conjunction"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var message = "Use “∧” instead."
            if fileType == .swift {
                message += " (Import SDGCornerstone.)"
            }

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "&\u{26}".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "∧", message: message)
                }

                switch fileType {
                case .workspaceConfiguration, .json, .yaml, .gitignore, .html, .css, .javaScript:
                    throwError()

                case .swift, .swiftPackageManifest:
                    if ¬isInAliasDefinition(for: "∧", at: range, in: file)
                        ∧ ¬isInConditionalCompilationStatement(at: range, in: file) {
                        throwError()
                    }

                case .markdown:
                    if ¬isInConditionalCompilationStatement(at: range, in: file) {
                        throwError()
                    }

                case .shell:
                    if ¬file.contents[file.contents.lineRange(for: range)].contains("REPOSITORY=") {
                        throwError()
                    }
                }
            }
        }
    }
}
