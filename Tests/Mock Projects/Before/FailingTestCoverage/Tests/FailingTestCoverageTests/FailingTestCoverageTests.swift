import XCTest
@testable import FailingTestCoverage

class FailingTestsTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(FailingTestCoverage().text(), "Hello, World!")
  }
}
