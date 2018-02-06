struct SDG {
    func text() -> String {
        return "Hello, World!"
    }

    func untestable() {
        preconditionFailure()
    }

    func exempt() { // [_Exempt from Test Coverage_]

    }
}
