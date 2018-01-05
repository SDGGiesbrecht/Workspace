/*
 SubtractAndSet.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct SubtractAndSet : Rule {

    static let name = "Subtract & Set"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if ¬file.path.string.hasSuffix("/Numeric.swift") {

            if let fileType = file.fileType {

                var message = "Use “−=” instead."
                if fileType == .swift {
                    message += " (Import SDGCornerstone.)"
                }

                var index = file.contents.startIndex
                while let range = file.contents.scalars.firstMatch(for: "\u{2D}=".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                    index = range.upperBound

                    func throwError() {
                        errorNotice(status: &status, file: file, range: range, replacement: "−=", message: message)
                    }

                    let lineRange = file.contents.lineRange(for: range)
                    let line = String(file.contents[lineRange])

                    switch fileType {
                    case .workspaceConfiguration, .markdown, .json, .yaml, .gitignore, .shell, .html, .css, .javaScript:
                        throwError()

                    case .swift, .swiftPackageManifest:
                        if ¬isInAliasDefinition(for: "−=", at: range, in: file)
                            ∧ ¬isInAliasDefinition(for: "subtractAndAssignAsFloatingPoint", at: range, in: file)
                            ∧ ¬line.contains("Swift.Numeric") {
                            throwError()
                        }

                    case .xcodeProject:
                        break
                    }
                }
            }
        }
    }
}
