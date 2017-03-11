/*
 CalloutCasing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct CalloutCasing : Rule {

    static let name = "Callout Casing"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "/// \u{2D} ", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                if range.upperBound ≠ file.contents.endIndex {
                    let nextIndex = range.upperBound.samePosition(in: file.contents.unicodeScalars)
                    let nextCharacter = file.contents.unicodeScalars[nextIndex]
                    if CharacterSet.lowercaseLetters.contains(nextCharacter) {
                        let replacement = String(nextCharacter).uppercased()
                        errorNotice(status: &status, file: file, range: range.upperBound ..< file.contents.index(after: range.upperBound), replacement: replacement, message: "Callouts should be capitalized.")
                    }
                }
            }
        }
    }
}
