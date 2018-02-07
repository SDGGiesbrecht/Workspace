struct SDG {
    func text(_ bool: Bool) -> String {
        if true {
            return "Hello, World!"
        } else {
            return "Hello, World!"
         /* The end of this line is not relevant to test coverage, but Xcode flags it. */ }
    }
    
    func untestable() {
        preconditionFailure()
    }
    
    func exempt() { // [_Exempt from Test Coverage_]
        
    }
}
