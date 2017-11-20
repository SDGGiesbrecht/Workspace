/*
 DeprecatedLinuxDocumentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct DeprecatedLinuxDocumentation : Rule {

    static let name = "Deprecated Linux Documentation"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        var index = file.contents.startIndex
        while let range = file.contents.scalars.firstMatch(for: "\u{4C}inuxDocs".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
            index = range.upperBound

            errorNotice(status: &status, file: file, range: range, replacement: nil, message: "Special compilation conditions are no longer necessary for Linux documentation.")
        }
    }
}
