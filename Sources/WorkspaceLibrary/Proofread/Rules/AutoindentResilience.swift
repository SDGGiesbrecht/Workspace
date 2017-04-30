/*
 AutoindentResilience.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct AutoindentResilience : Rule {

    static let name = "Autoindent Resilience"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "/*\u{2A}", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                errorNotice(status: &status, file: file, range: range.lowerBound ..< file.contents.index(range.lowerBound, offsetBy: 3), replacement: nil, message: "This may not survive autoindent (⌃I). Use the “///” style instead.")
            }
        }
    }
}
