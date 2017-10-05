/*
 SyntaxColouring.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct SyntaxColouring : Rule {

    static let name = "Syntax Colouring"

    static func check(file: File, status: inout Bool) {

        var oddNumberedOccurrenceInformation: [String: Bool] = [:]

        var index = file.contents.startIndex
        while let range = file.contents.scalars.firstMatch(for: "```".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
            index = range.upperBound

            let lineRange = file.contents.lineRange(for: range)
            let linePrefix = String(file.contents[lineRange.lowerBound ..< range.lowerBound])

            var oddNumberedOccurrence: Bool
            if let information = oddNumberedOccurrenceInformation[linePrefix] {
                oddNumberedOccurrence = information
            } else {
                oddNumberedOccurrence = true
            }

            if oddNumberedOccurrence {
                if file.contents[range.upperBound...].hasPrefix("\n") {

                    errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Specify a language for syntax colouring, e.g. “```swift”.")
                }
            }
            oddNumberedOccurrenceInformation[linePrefix] = ¬oddNumberedOccurrence
        }
    }
}
