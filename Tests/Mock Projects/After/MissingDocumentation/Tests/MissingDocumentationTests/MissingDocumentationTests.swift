import XCTest
@testable import MissingDocumentation

final class MissingDocumentationTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MissingDocumentation().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
