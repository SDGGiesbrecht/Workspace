struct UnicodeSource {
    var text = "Hello, World!"
}

/// ...
infix operator ≠

/// ...
infix operator ¬

extension Bool {

    /// ...
    public static func ≠(lhs: Bool, rhs: Bool) -> Bool {
        return true
    }

    /// ...
    public static func ¬(lhs: Bool, rhs: Bool) -> Bool {
        return true
    }

    /// ...
    public static func אבג() {}
}
