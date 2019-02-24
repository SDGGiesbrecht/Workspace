/*
 TriviaPiece.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftSource

extension TriviaPiece {

    // #workaround(SDGSwift 0.4.6, Belongs in SDGSwiftSource)
    internal var isNewLine: Bool {
        switch self {
        case .spaces, .tabs, .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment, .garbageText:
            return false // @exempt(from: tests)
        case .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds:
            return true
        }
    }
}
