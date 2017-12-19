import XCTest
@testable import SDG

class SDGTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SDG().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
