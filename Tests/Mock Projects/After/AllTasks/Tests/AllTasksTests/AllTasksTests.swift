/*
 AllTasksTests.swift

 This source file is part of the AllTasks open source project.

 Copyright ©2019 the AllTasks project contributors.

 This software is subject to copyright law.
 It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s).
 */

import XCTest
@testable import AllTasks

final class AllTasksTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AllTasks().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
