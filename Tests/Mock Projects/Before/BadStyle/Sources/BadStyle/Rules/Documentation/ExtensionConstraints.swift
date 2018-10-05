// Header

extension Equatable where Self : Comparable { // Okay.

    // Only if comparable.
    public func conditional() {}
}

extension Equatable where Self : Comparable {
    // MARK: - where Self : Comparable (Warn. The heading is no longer necessary.)

    // Only if comparable.
    public func alsoConditional() {}
}
