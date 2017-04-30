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

struct WorkspaceUnicodeSyntax : Rule {

    static let name = "Syntax Colouring"

    static func check(file: File, status: inout Bool) {

        if file.fileType == .workspaceConfiguration {

            // Manage Read‐Me & Read‐Me

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "Read\u{22}Me", in: index ..< file.contents.endIndex) {
                index = range.upperBound
                errorNotice(status: &status, file: file, range: range, replacement: "Manage Read‐Me", message: "Did you mean “Read‐Me”?")
            }
        }

        // Define Example: Read‐Me

        var index = file.contents.startIndex
        while let range = file.contents.range(of: "[\u{5F}Define Example: Read\u{22}Me_]", in: index ..< file.contents.endIndex) {
            index = range.upperBound
            errorNotice(status: &status, file: file, range: range, replacement: "[\u{5F}Define Example: Read‐Me_]", message: "Did you mean “[\u{5F}Define Example: Read‐Me_]”?")
        }
    }
}
