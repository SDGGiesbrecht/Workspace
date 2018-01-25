import XCTest
@testable import NoLocalizations

class NoLocalizationsTests : XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NoLocalizations().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
