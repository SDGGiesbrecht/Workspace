/*
 HeadersTests.swift

 This source file is part of the Headers open source project.

 Copyright ©2020 the Headers project contributors.
 */

import XCTest
@testable import Headers

final class HeadersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Headers().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
