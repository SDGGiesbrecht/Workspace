/*
 Division.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct Division : Rule {

    static let name = "Division"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var message = "Use “÷” instead."
            if fileType == .swift {
                message = "Use “÷” or “dividedAccordingToEuclid(by:)” instead. (Import SDGCornerstone.)"
            }

            var index = file.contents.startIndex
            while let range = file.contents.range(of: " \u{2F} ", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: " ÷ ", message: message)
                }

                switch fileType {
                case .workspaceConfiguration, .markdown, .json, .yaml, .gitignore, .shell, .html, .css, .javaScript:
                    throwError()

                case .swift, .swiftPackageManifest:
                    if ¬isInAliasDefinition(for: "÷", at: range, in: file)
                        ∧ ¬isInAliasDefinition(for: "dividedAccordingToEuclid", at: range, in: file) {
                        throwError()
                    }
                }
            }
        }
    }
}
