/*
 CustomReadMeTests.swift

 This source file is part of the CustomReadMe open source project.

 Copyright ©2020 the CustomReadMe project contributors.

 Dedicated to the public domain.
 See http://unlicense.org/ for more information.
 */

import XCTest
@testable import CustomReadMe

class CustomReadMeTests : XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CustomReadMe().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
