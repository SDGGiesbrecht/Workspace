import XCTest
@testable import AllDisabled

final class AllDisabledTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AllDisabled().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
