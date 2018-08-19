/*
 TextDirection.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal enum TextDirection {

    // MARK: - Cases

    case rightToLeft
    case leftToRight

    // MARK: - Properties

    internal var htmlAttribute: String {
        switch self {
        case .rightToLeft:
            return "rtl"
        case .leftToRight:
            return "ltr"
        }
    }
}

extension Optional where Wrapped == TextDirection {

    internal var htmlAttribute: String {
        switch self {
        case .some(let direction):
            return direction.htmlAttribute
        case .none:
            return "auto"
        }
    }

}
