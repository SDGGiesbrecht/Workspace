// Header

struct Conformance: Equatable { // This colon should trigger. It should be spaced.
    static func == (lhs : Conformance, rhs:Conformance) -> Bool { // These colons should trigger. They need respacing.
        return false
    }

    static let string = "English colon spacing must be allowed in strings:"
    static let chaîneDeCaractères = "Une espace doit être permise pour le français :"
    
    /// :nodoc: It must be possible to hide things from Jazzy.
    func hidden() {}
    
    let dictionary: [String: String] = [:] // Dictionary literals should be allowed.
    
    func variableTypes() {
        let xyz: Int = 1 + 2 // Variable types should be allowed.
        let _: Int = 1 + 2 // Dropped variable types should be allowed.
    }
}
