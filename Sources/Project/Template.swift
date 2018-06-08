/*
 Template.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

// [_Warning: Do these need to be public?_]
public struct Template {

    // MARK: - Initialization

    public init(source: StrictString) {
        text = source
    }

    // MARK: - Properties

    public var text: StrictString

    // MARK: - Usage

    private static func element(named name: StrictString) -> StrictString {
        return "[_" + name + "_]"
    }

    public mutating func insert(_ string: StrictString, for element: UserFacing<StrictString, InterfaceLocalization>) {
        for localization in InterfaceLocalization.cases {
            text.replaceMatches(for: Template.element(named: element.resolved(for: localization)), with: string)
        }
    }

    public mutating func insert(resultOf closure: () throws -> StrictString, for element: UserFacing<StrictString, InterfaceLocalization>) rethrows {
        // [_Warning: Deprecated._]
        for localization in InterfaceLocalization.cases {
            if text.contains(Template.element(named: element.resolved(for: localization))) {
                insert(try closure(), for: element)
            }
        }
    }
}
