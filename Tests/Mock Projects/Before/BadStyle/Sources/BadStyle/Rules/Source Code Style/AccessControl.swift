struct Structure {} // Should warn; no access control.

class Class {} // Should warn; no access control.

enum Enumeration {} // Should warn; no access control.

typealias TypeAlias = Structure // Should warn; no access control.

protocol Protocol {} // Should warn; no access control.

func function() {} // Should warn; no access control.

public struct Context {

  init() {} // Should warn; no access control.

  var variable: Int // Should warn; no access control.

  subscript(_ index: Bool) -> Bool {  // Should warn; no access control.
    get { return index }
    set {}
  }
}

public extension Context {}  // Should warn; should not have access control.

func localScope() {
  let local = 0 // Should not warn; local scope.
}
