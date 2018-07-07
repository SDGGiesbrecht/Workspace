/*
 CustomProofreadTests.swift

 This source file is part of the CustomProofread open source project.

 Copyright ©2018 the CustomProofread project contributors.

 Licensed under the GNU General Public Licence, Version 3.0.
 See http://www.gnu.org/licenses/ for licence information.
 */

import XCTest
@testable import CustomProofread

class CustomProofreadTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CustomProofread().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
