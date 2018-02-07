// Header

extension Equatable where Self : Comparable { // Undocumented; should trigger.

    // Only if comparable.
    public func conditional() {}
}
