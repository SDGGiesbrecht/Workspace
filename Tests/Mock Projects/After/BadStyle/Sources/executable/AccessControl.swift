internal struct ShouldNot {}  // Should warn; should not have access control.
fileprivate struct Allowed {}  // Should not warn; private is allowed.
