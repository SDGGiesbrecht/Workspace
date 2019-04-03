import XCTest
@testable import FailingCustomValidation

final class FailingCustomValidationTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FailingCustomValidation().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
