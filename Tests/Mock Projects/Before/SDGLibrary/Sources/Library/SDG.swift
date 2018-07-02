struct SDG {
    func text(_ bool: Bool) -> String {
        if bool {
            return "Hello, World!"
        } else {
            return "Hello, World!"
            // The next line is not relevant to test coverage, but Xcode flags it.
        }
    }
    
    func untestable() {
        preconditionFailure()
    }
    
    func exempt() { // [_Exempt from Test Coverage_]
        
    }
    
    func alsoExempt() {
        // customPreviousLineToken
    }
    
    func anotherExemption() { // customSameLineToken
        
    }

    func defineExample() {
        // @example(anExample)
        // This is source code.

        // And more after an empty line.
        // @endExample
    }

    // #example(1, anExample)
    /// Uses an example.
    ///
    /// ```
    /// ```
    func useExample() {}
}
