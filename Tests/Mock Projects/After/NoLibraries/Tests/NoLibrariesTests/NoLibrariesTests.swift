import XCTest
@testable import NoLibraries

final class NoLibrariesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NoLibraries().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
