struct FailingTests {
    func text() -> String {
        let x = "Unused"
        return "Hello, World!"
    }
    func untested() -> String {
        return "???"
    }
}
