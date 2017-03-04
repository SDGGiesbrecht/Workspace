/*
 AutoindentResilience.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct AutoindentResilience : Rule {

    static let name = "Autoindent Resilience"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .swift {var index = file.contents.startIndex

            while let range = file.contents.range(of: ("/**", "*/"), in: index ..< file.contents.endIndex) {
                index = range.upperBound

                let firstLineRange = file.contents.lineRange(for: range.lowerBound ..< range.lowerBound)
                let indent = file.contents.substring(with: firstLineRange.lowerBound ..< range.lowerBound) + " "

                var lines = file.contents.substring(with: range).linesArray
                if lines.count > 1 {
                    lines.removeFirst()

                    for line in lines {
                        var indentEnd = line.startIndex
                        if line.advance(&indentEnd, past: indent) {

                            let commentLine = line.substring(from: indentEnd)
                            if commentLine.hasPrefix(" ") {
                                errorNotice(status: &status, file: file, range: range.lowerBound ..< file.contents.index(range.lowerBound, offsetBy: 3), replacement: nil, message: "This will not survive autoindent (⌃I). Use the “///” style instead.")
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
