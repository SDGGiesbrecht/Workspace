/*
 HyphenMinus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct HyphenMinus : Rule {

    static let name = "Hyphen/Minus"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            if ¬file.path.string.hasSuffix("/Numeric.swift"),
                ¬file.path.string.hasSuffix("/SignedNumeric.swift"),
                ¬file.path.string.hasSuffix("/Negatable.swift") {

                var index = file.contents.startIndex
                while let range = file.contents.scalars.firstMatch(for: "\u{2D}".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                    index = range.upperBound

                    func throwError() {
                        errorNotice(status: &status, file: file, range: range, replacement: "[‐/−/—/•/–]", message: "Use a hyphen (‐), minus sign (−), dash (—), bullet (•) or range (–) instead.")
                    }

                    let lineRange = file.contents.lineRange(for: range)
                    let line = String(file.contents[lineRange])

                    if ¬line.contains("http")
                        ∧ ¬file.contents[range.upperBound...].hasPrefix("=") /* “Subtract & Set” rule */ {
                        switch fileType {

                        case .json, .html, .css, .javaScript:
                            throwError()

                        case .swift, .swiftPackageManifest:
                            if ¬isInAliasDefinition(for: "−", at: range, in: file)
                                ∧ ¬file.contents[range.upperBound...].hasPrefix(">")
                                ∧ ¬file.contents[..<range.lowerBound].hasSuffix("// MARK\u{3A} ")
                                ∧ ¬file.contents[..<range.lowerBound].hasSuffix("/// ")
                                ∧ ¬file.contents[..<range.lowerBound].hasSuffix("///   ")
                                ∧ ¬file.contents[..<range.lowerBound].hasSuffix("///     ")
                                ∧ ¬line.contains("let ln2")
                                ∧ ¬line.contains("Swift.Numeric")
                                ∧ ¬line.contains("Swift.SignedNumeric")
                                ∧ ¬line.contains("jazzy \u{2D}\u{2D}")
                                ∧ ¬line.contains("[\u{5F}Define Example: Read‐Me:")
                                ∧ ¬line.contains("swift\u{2D}tools\u{2D}version") {
                                throwError()
                            }

                        case .shell, .gitignore:
                            if line.hasPrefix("#") {
                                throwError()
                            }

                        case .workspaceConfiguration:
                            let filePrefix = String(file.contents[..<range.lowerBound])
                            let fileSuffix = String(file.contents[range.upperBound...])

                            if ¬(filePrefix.contains("```shell") ∧ fileSuffix.contains("```")) /* Shell Script */
                                ∧ ¬(filePrefix.contains("[_Begin Feature List_]") ∧ fileSuffix.contains("[_End_]") ∧ filePrefix.hasSuffix("\n")) /* Feature List */
                                ∧ ¬(filePrefix.contains("[_Begin Other Read‐Me Content_]") ∧ fileSuffix.contains("[_End_]") ∧ filePrefix.hasSuffix("\n") ∨ filePrefix.hasSuffix("\n  ")) /* Other Read‐Me Content */
                                ∧ ¬(filePrefix.components(separatedBy: " ").last ?? "").contains("#")
                                ∧ ¬(line.hasPrefix("[_") ∧ line.hasSuffix("_]"))
                                ∧ ¬(filePrefix.contains("[_Begin Localizations_]") ∧ fileSuffix.contains("[_End_]")) {
                                throwError()
                            }

                        case .markdown:
                            if ¬String(file.contents[lineRange.lowerBound ..< range.lowerBound]).isWhitespace
                                ∧ ¬line.contains("<\u{21}\u{2D}\u{2D}")
                                ∧ ¬line.contains("\u{2D}\u{2D}>")
                                ∧ ¬((file.contents[..<range.lowerBound].contains("```shell") ∨ file.contents[..<range.lowerBound].contains("```swift")) ∧ file.contents[range.upperBound...].contains("```"))
                                ∧ ¬line.contains("](")
                                ∧ ¬line.contains("`") {
                                throwError()
                            }

                        case .yaml:
                            if ¬String(file.contents[lineRange.lowerBound ..< range.lowerBound]).isWhitespace
                                ∧ ¬file.path.string.hasSuffix(".travis.yml") {
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
}
