/*
 main.swift


 ©[Current Date]

 This software is subject to copyright law.
 It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s).
 */

import XCTest

@testable import AllTasksTests

extension AllTasksTests.AllTasksTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testExample", testExample)
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += AllTasksTests.AllTasksTests.windowsTests

XCTMain(tests)
