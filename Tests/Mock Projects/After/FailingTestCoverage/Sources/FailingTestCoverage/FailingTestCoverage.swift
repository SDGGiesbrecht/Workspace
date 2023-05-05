struct FailingTestCoverage {
  func text() -> String {
    let x = "Unused"
    return "Hello, World!"
  }
  func notCovered() -> String {
    return "???"
  }
}
