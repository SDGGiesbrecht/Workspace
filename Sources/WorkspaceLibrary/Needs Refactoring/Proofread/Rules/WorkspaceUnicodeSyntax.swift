/*
 WorkspaceUnicodeSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct WorkspaceUnicodeSyntax : Rule {

    static let name = "Syntax Colouring"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        if file.fileType == .workspaceConfiguration {

            // Manage Read‐Me & Read‐Me

            var index = file.contents.startIndex
            while let range = file.contents.scalars.firstMatch(for: "Read\u{22}Me".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                index = range.upperBound
                errorNotice(status: &status, file: file, range: range, replacement: "Manage Read‐Me", message: "Did you mean “Read‐Me”?")
            }
        }

        // Define Example: Read‐Me

        var index = file.contents.startIndex
        while let range = file.contents.scalars.firstMatch(for: "[\u{5F}Define Example: Read\u{22}Me_]".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
            index = range.upperBound
            errorNotice(status: &status, file: file, range: range, replacement: "[\u{5F}Define Example: Read‐Me_]", message: "Did you mean “[\u{5F}Define Example: Read‐Me_]”?")
        }
    }
}
