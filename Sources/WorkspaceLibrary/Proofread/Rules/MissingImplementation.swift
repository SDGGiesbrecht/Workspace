/*
 MissingImplementation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct MissingImplementation : Rule {

    static let name = "Missing Implementation"

    static func check(file: File, status: inout Bool) {

        var index = file.contents.startIndex
        while let range = file.contents.scalars.firstMatch(for: "\u{6E}otImplementedYet".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
            index = range.upperBound

            if ¬file.contents.substring(to: range.lowerBound).hasSuffix("func ") {
                errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Missing implementation.")
            }
        }
    }
}
