// Header

struct Conformance: Equatable { // This colon should trigger. It should be spaced.

    static func == (lhs: Conformance, rhs: Conformance) -> Bool {
        return false
    }
}
