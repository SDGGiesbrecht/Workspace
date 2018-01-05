import XCTest
@testable import NoQuotationSource

class NoQuotationSourceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NoQuotationSource().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
