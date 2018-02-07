import XCTest
@testable import FailingTests

class FailingTestsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FailingTests().text(), "!!!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
