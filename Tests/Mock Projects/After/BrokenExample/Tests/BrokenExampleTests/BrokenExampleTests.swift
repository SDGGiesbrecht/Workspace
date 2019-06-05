import XCTest
@testable import BrokenExample

final class BrokenExampleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BrokenExample().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
