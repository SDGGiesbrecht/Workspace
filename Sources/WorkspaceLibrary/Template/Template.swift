/*
 Template.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct Template {

    // MARK: - Initialization

    init(source: StrictString) {
        text = source
    }

    // MARK: - Properties

    var text: StrictString

    // MARK: - Usage

    private static func element(named name: StrictString) -> StrictString {
        return "[_" + name + "_]"
    }

    mutating func insert(_ string: StrictString, for element: StrictString) {
        text.replaceMatches(for: Template.element(named: element), with: string)
    }

    mutating func insert(resultOf closure: () throws -> StrictString, for element: StrictString) rethrows {
        if text.contains(Template.element(named: element)) {
            insert(try closure(), for: element)
        }
    }
}
