/*
 Trivia.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SwiftSyntax
import SDGSwiftSource

extension Trivia {

    func isEffectivelyEmpty() -> Bool {
        for piece in self {
            switch piece {
            case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds:
                break
            case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment, .garbageText:
                return false
            }
        }
        return true
    }
}
