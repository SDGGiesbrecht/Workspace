/*
 SDGCornerstone.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */


// [_Workaround: Everything in this file should be in moved to SDGCornerstone. (SDGCornerstone 0.7.3)_]

extension Optional where Wrapped : Collection, Wrapped.Element : Equatable {
    // MARK: - where Wrapped : Collection, Wrapped.Element : Equatable

    public func contains<C : Collection>(_ pattern: C) -> Bool where C.Element == Wrapped.Element {
        switch self {
        case .some(let wrapped):
            return wrapped.contains(LiteralPattern(pattern))
        case .none:
            return false
        }
    }
}
