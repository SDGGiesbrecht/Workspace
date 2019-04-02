import XCTest
@testable import CustomTasks

final class CustomTasksTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CustomTasks().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
