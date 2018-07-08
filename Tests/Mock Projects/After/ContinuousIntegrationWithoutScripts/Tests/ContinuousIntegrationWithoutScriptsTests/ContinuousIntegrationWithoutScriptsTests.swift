/*
 ContinuousIntegrationWithoutScriptsTests.swift

 This source file is part of the ContinuousIntegrationWithoutScripts open source project.

 Copyright ©2018 the ContinuousIntegrationWithoutScripts project contributors.

 Licensed under the MIT Licence.
 See https://opensource.org/licenses/MIT for licence information.
 */

import XCTest
@testable import ContinuousIntegrationWithoutScripts

final class ContinuousIntegrationWithoutScriptsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ContinuousIntegrationWithoutScripts().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
