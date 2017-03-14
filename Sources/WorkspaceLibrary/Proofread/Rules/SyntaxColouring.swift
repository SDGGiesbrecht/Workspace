/*
 SyntaxColouring.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct SyntaxColouring : Rule {

    static let name = "Syntax Colouring"

    static func check(file: File, status: inout Bool) {

        var oddNumberedOccurrance = true

        var index = file.contents.startIndex
        while let range = file.contents.range(of: "```", in: index ..< file.contents.endIndex) {
            index = range.upperBound

            if oddNumberedOccurrance {
                if file.contents.substring(from: range.upperBound).hasPrefix("\n") {

                    errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Specify a language for syntax colouring, e.g. “```swift”.")
                }
            }
            oddNumberedOccurrance = ¬oddNumberedOccurrance
        }
    }
}
