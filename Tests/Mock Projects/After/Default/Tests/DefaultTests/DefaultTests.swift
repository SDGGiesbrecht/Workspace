import XCTest
@testable import Default

class DefaultTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(Default().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
