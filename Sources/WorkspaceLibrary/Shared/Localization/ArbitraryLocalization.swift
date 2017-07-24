/*
 ArbitraryLocalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A localization indicated by user content. Workspace may not directly support these localizations, but it can reference them independently.
enum ArbitraryLocalization : Hashable {

    // MARK: - Initialization

    init(code: String) {
        if let result = CompatibleLocalization(exactly: code) {
            self = .compatible(result)
        } else {
            self = .unrecognized(code)
        }
    }

    // MARK: - Cases

    case compatible(CompatibleLocalization)
    case unrecognized(String)

    // MARK: - Properties

    var code: String {
        switch self {
        case .compatible(let localization):
            return localization.code
        case .unrecognized(let code):
            return code
        }
    }

    var icon: StrictString {
        return compatible?.icon ?? StrictString(code)
    }

    var compatible: CompatibleLocalization? {
        switch self {
        case .compatible(let result):
            return result
        case .unrecognized:
            return nil
        }
    }

    // MARK: - Equatable

    static func == (lhs: ArbitraryLocalization, rhs: ArbitraryLocalization) -> Bool {
        return lhs.code == rhs.code
    }

    // MARK: - Hashable

    var hashValue: Int {
        return code.hashValue
    }
}
