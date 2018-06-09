/*
 Option.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Warning: Remove this._]

import GeneralImports

enum Option : String, CustomStringConvertible {

    // MARK: - Initialization

    init?(key: String) {
        self.init(rawValue: key)
    }

    // MARK: - Cases

    // SDG
    case sdg = "SDG"

    // Testing Workspace
    case nestedTest = "Nested Test"
    case testOption = "Test Option"
    case testLongOption = "Test Long Option"

    // MARK: - Properties

    var key: String {
        return rawValue
    }

    var defaultValue: String {
        switch self {

        // SDG
        case .sdg:
            return String(Configuration.falseOptionValue)

        // Tests
        case .nestedTest:
            return String(Configuration.falseOptionValue)
        case .testOption:
            return "Default Value"
        case .testLongOption:
            return "Default\nValue"
        }
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return key
    }
}
