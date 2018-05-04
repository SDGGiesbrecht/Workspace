/*
 Template.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */


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

    mutating func insert(_ string: StrictString, for element: UserFacingText<InterfaceLocalization>) {
        for localization in InterfaceLocalization.cases {
            text.replaceMatches(for: Template.element(named: element.resolved(for: localization)), with: string)
        }
    }

    mutating func insert(resultOf closure: () throws -> StrictString, for element: UserFacingText<InterfaceLocalization>) rethrows {
        for localization in InterfaceLocalization.cases {
            if text.contains(Template.element(named: element.resolved(for: localization))) {
                insert(try closure(), for: element)
            }
        }

    }
}
