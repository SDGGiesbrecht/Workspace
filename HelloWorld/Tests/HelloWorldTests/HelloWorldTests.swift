import XCTest
@testable import HelloWorld

final class HelloWorldTests: XCTestCase {

  func testExample() {
    XCTAssertEqual(HelloWorld().text, "Hello, World!")
  }
}
