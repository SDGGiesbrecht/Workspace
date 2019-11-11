import XCTest
@testable import FailingCustomTasks

final class FailingCustomTasksTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(FailingCustomTasks().text, "Hello, World!")
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
