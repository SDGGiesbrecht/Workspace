/*
 NotEqual.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct NotEqual : Rule {

    static let name = "Not Equal"

    static func check(file: File, status: inout Bool) {

        var index = file.contents.startIndex
        while let range = file.contents.range(of: "!=", in: index ..< file.contents.endIndex) {
            index = range.upperBound

            errorNotice(status: &status, file: file, range: range, replacement: "≠", message: "Use “≠” instead. (Import SDGLogic.)")
        }
    }
}
