/* Header */

internal struct SDG {
    internal func text(_ bool: Bool) -> String {
        if bool {
            return "Hello, World!"
        } else {
            return "Hello, World!"
            // The next line is not relevant to test coverage, but Xcode flags it.
        }
    }
    
    internal func untestable() {
        preconditionFailure()
    }
    
    internal func exempt() { // @exempt(from: tests)
        
    }
    
    internal func alsoExempt() {
        // customPreviousLineToken
    }
    
    internal func anotherExemption() { // customSameLineToken
        
    }

    internal func defineExample() { // @exempt(from: tests)
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
    internal func useExample() {} // @exempt(from: tests)

    // @documentation(someDocumentation)
    /// This is documentation.
    ///
    /// It contains interesting information.
    internal var defineDocumentation: Bool?

    // #documentation(someDocumentation)
    internal var instertDocumentation: Bool?

    // #documentation(someDocumentation)
    /// This is outdated documentation.
    internal var replaceDocumentation: Bool?
}
