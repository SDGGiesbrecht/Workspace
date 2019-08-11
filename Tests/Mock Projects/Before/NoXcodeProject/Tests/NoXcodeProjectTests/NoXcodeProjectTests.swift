import XCTest
@testable import NoXcodeProject

final class NoXcodeProjectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NoXcodeProject().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
