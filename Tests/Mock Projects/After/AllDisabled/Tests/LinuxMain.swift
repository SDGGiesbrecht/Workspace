import XCTest

import AllDisabledTests

var tests = [XCTestCaseEntry]()
tests += AllDisabledTests.__allTests()

XCTMain(tests)
