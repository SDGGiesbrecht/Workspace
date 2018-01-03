/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct ColonSpacing : Rule {

    static let name = "Colon Spacing"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .swift {

            var index = file.contents.startIndex

            while let range = file.contents.scalars.firstMatch(for: ":".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                let lineRange = file.contents.lineRange(for: range)
                let line = String(file.contents[lineRange])
                let linePrefix = String(file.contents[lineRange.lowerBound ..< range.lowerBound])
                let lineSuffix = String(file.contents[range.upperBound ..< lineRange.upperBound])

                if ¬(linePrefix.contains("\u{22}") ∧ lineSuffix.contains("\u{22}")) /* String Literal */
                    ∧ ¬linePrefix.contains("//") /* Comment */
                    ∧ ¬line.contains(":nodoc:") {

                    let protocolOrSuperclass: Bool

                    if linePrefix.contains("[") ∧ lineSuffix.contains("]") /* Dictionary Literal */ {
                        protocolOrSuperclass = false
                    } else if linePrefix.hasSuffix("_") {
                        protocolOrSuperclass = false
                    } else if let startOfPreviousIdentifier = linePrefix.components(separatedBy: (CharacterSet.whitespaces ∪ CharacterSet.punctuationCharacters) ∪ CharacterSet.symbols).filter({ ¬$0.isEmpty }).last?.unicodeScalars.first {
                        protocolOrSuperclass = startOfPreviousIdentifier ∈ CharacterSet.uppercaseLetters
                    } else {
                        protocolOrSuperclass = false
                    }

                    if let preceding = String(file.contents[..<range.lowerBound]).clusters.last {

                        if preceding == " " {
                            if ¬linePrefix.contains(" ? ") /* Ternary Conditional Operator */ {
                                let precedingIndex = file.contents.index(before: range.lowerBound)
                                let errorRange = precedingIndex ..< range.upperBound

                                if ¬protocolOrSuperclass {
                                    errorNotice(status: &status, file: file, range: errorRange, replacement: ":", message: "Colons should not be preceded by spaces.")
                                }
                            }
                        } else {

                            if protocolOrSuperclass {
                                errorNotice(status: &status, file: file, range: range, replacement: " :", message: "Colons should be preceded by spaces when denoting protocols or superclasses.")
                            }
                        }

                    }

                    if let followingCharacter = String(file.contents[range.upperBound...]).unicodeScalars.first {

                        if followingCharacter ∉ CharacterSet.whitespacesAndNewlines {

                            if ¬lineSuffix.hasPrefix("]") /* Empty Dictionary Literal */
                                ∧ ¬lineSuffix.hasPrefix("//") /* URL */ {
                                errorNotice(status: &status, file: file, range: range, replacement: ": ", message: "Colons should be followed by a space.")
                            }
                        }
                    }
                }
            }
        }
    }
}
