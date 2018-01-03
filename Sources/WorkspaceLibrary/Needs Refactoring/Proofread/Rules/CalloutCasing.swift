/*
 CalloutCasing.swift

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

struct CalloutCasing : Rule {

    static let name = "Callout Casing"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "/// \u{2D} ".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                if range.upperBound ≠ file.contents.endIndex {
                    let nextIndex: String.ScalarView.Index = range.upperBound.samePosition(in: file.contents.unicodeScalars)
                    let nextCharacter = file.contents.unicodeScalars[nextIndex]
                    if nextCharacter ∈ CharacterSet.lowercaseLetters {

                        var scalar: String.ScalarView.Index = range.upperBound.samePosition(in: file.contents.scalars)
                        file.contents.scalars.advance(&scalar, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.letters })))
                        let index = scalar.cluster(in: file.contents.clusters)

                        let afterWord = file.contents.clusters[index]
                        if afterWord == ":" {

                            let replacement = String(nextCharacter).uppercased()
                            errorNotice(status: &status, file: file, range: range.upperBound ..< file.contents.index(after: range.upperBound), replacement: replacement, message: "Callouts should be capitalized.")
                        }
                    }
                }
            }
        }
    }
}
