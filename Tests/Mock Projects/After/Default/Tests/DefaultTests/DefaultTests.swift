import XCTest
@testable import Default

final class DefaultTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Default().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
