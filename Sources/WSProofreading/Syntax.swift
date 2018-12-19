/*
 Syntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGSwift 0.4.0, These belong in SDGSwiftSource.)

import SDGSwiftSource

extension Syntax {

    internal func firstToken() -> TokenSyntax {
        if let token = self as? TokenSyntax {
            return token
        }
        return children.first(where: { _ in true})!.firstToken()
    }

    internal func lastToken() -> TokenSyntax {
        if let token = self as? TokenSyntax {
            return token
        }
        var lastChild: Syntax?
        for child in children {
            lastChild = child
        }
        return lastChild!.lastToken()
    }

    private var parentRelationship: (parent: Syntax, index: Int)? {
        guard let parent = self.parent else {
            return nil // @exempt(from: tests)
        }
        return (parent, indexInParent)
    }

    internal func ancestorRelationships() -> AnySequence<(parent: Syntax, index: Int)> {
        if let parentRelationship = self.parentRelationship {
            return AnySequence(sequence(first: parentRelationship, next: { $0.parent.parentRelationship }))
        } else { // @exempt(from: tests)
            return AnySequence([]) // @exempt(from: tests)
        }
    }
}
