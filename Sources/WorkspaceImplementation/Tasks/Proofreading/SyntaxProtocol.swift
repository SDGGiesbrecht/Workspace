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
