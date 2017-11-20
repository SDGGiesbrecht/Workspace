/*
 CompatibilityCharacters.swift

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

struct CompatibilityCharacters : Rule {

    static let name = "Compatibility Characters"

    static func check(file: File, status: inout Bool, output: inout Command.Output) {

        var index = file.contents.startIndex
        while index ≠ file.contents.endIndex {
            let next = file.contents.index(after: index)

            let characterRange = index ..< next
            let character = String(file.contents[characterRange])
            let normalized = character.decomposedStringWithCompatibilityMapping
            if character ≠ normalized {
                errorNotice(status: &status, file: file, range: characterRange, replacement: normalized, message: "“\(character)” may be lost in normalization; use “\(normalized)” instead.")
            }

            index = next
        }
    }
}
