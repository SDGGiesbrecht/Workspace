/*
 SyntaxProtocol.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SwiftSyntax

extension SyntaxProtocol {

  internal func parent<S>(as type: S.Type, ifIsChildAt child: KeyPath<S, Self>) -> S?
  where S: SyntaxProtocol {
    if let parent = self.parent,
      let expectedParent = parent.as(S.self) {
      let foundChild = expectedParent[keyPath: child]
      if self.indexInParent == foundChild.indexInParent {
        return expectedParent
      }
    }
    return nil
  }

  internal func parent<S>(as type: S.Type, ifIsChildAt child: KeyPath<S, Self?>) -> S?
  where S: SyntaxProtocol {
    if let parent = self.parent,
      let expectedParent = parent.as(S.self) {
      let foundChild = expectedParent[keyPath: child]
      if self.indexInParent == foundChild?.indexInParent {
        return expectedParent
      }
    }
    return nil
  }
}

#endif
