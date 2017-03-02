/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct ColonSpacing : Rule {

    static let name = "Colon Spacing"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .swift {

            var index = file.contents.startIndex

            while let range = file.contents.range(of: ":", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                let lineRange = file.contents.lineRange(for: range)
                let line = file.contents.substring(with: lineRange)
                let linePrefix = file.contents.substring(with: lineRange.lowerBound ..< range.lowerBound)
                let lineSuffix = file.contents.substring(with: range.upperBound ..< lineRange.upperBound)

                if ¬(linePrefix.contains("\u{22}") ∧ lineSuffix.contains("\u{22}")) /* String Literal */
                    ∧ ¬linePrefix.contains("//") /* Comment */
                    ∧ ¬line.contains(":nodoc:") {

                    let protocolOrSuperclass: Bool

                    if linePrefix.contains("[") ∧ lineSuffix.contains("]") /* Dictionary Literal */ {
                        protocolOrSuperclass = false
                    } else if let startOfPreviousIdentifier = linePrefix.components(separatedBy: CharacterSet.whitespaces.union(CharacterSet.punctuationCharacters).union(CharacterSet.symbols)).filter({ ¬$0.isEmpty }).last?.unicodeScalars.first {
                        protocolOrSuperclass = CharacterSet.uppercaseLetters.contains(startOfPreviousIdentifier)
                    } else {
                        protocolOrSuperclass = false
                    }

                    if let preceding = file.contents.substring(to: range.lowerBound).characters.last {

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

                    if let followingCharacter = file.contents.substring(from: range.upperBound).unicodeScalars.first {

                        if ¬CharacterSet.whitespacesAndNewlines.contains(followingCharacter) {

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
