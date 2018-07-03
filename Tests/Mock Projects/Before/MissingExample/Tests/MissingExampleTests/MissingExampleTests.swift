import XCTest
@testable import MissingExample

final class MissingExampleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MissingExample().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
