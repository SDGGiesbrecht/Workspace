import XCTest
@testable import OnlyBritish

final class OnlyBritishTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(OnlyBritish().text, "Hello, World!")
  }

  static var allTests = [
    ("testExample", testExample)
  ]
}
