/*
 SearchableCollection.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

extension Optional where Wrapped : SearchableCollection {
    // MARK: - where Wrapped : SearchableCollection

    internal func contains<C : SearchableCollection>(_ pattern: C) -> Bool where C.Element == Wrapped.Element {
        switch self {
        case .some(let wrapped):
            return wrapped.contains(LiteralPattern(pattern))
        case .none:
            return false
        }
    }
}
