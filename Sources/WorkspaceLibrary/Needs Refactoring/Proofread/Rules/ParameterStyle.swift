/*
 ParameterStyle.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct ParametersStyle : Rule {

    static let name = "Parameter Style"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .swift {

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "/// \u{2D} Parameter ".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound

                errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Parameters should be grouped under a single callout.")
            }
        }
    }
}
