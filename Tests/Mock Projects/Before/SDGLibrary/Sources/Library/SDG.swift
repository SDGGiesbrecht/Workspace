/* Header */

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
    
    func exempt() { // @exempt(from: tests)
        
    }
    
    func alsoExempt() {
        // customPreviousLineToken
    }
    
    func anotherExemption() { // customSameLineToken
        
    }

    func defineExample() { // @exempt(from: tests)
        // @example(anExample)
        // This is source code.

        // And more after an empty line.
        // @endExample

        // @example(anotherExample )
        // ...
        // @endExample
    }

    // #example(1, anExample) #example(2, anotherExample)
    /// Uses an example.
    ///
    /// ```
    /// ```
    ///
    /// ```
    /// ```
    func useExample() {} // @exempt(from: tests)

    // @documentation(someDocumentation)
    /// This is documentation.
    ///
    /// It contains interesting information.
    var defineDocumentation: Bool?

    // #documentation(someDocumentation)
    var instertDocumentation: Bool?

    // #documentation(someDocumentation)
    /// This is outdated documentation.
    var replaceDocumentation: Bool?
}
