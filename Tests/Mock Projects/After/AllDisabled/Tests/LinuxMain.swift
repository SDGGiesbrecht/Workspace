import XCTest

import AllDisabledTests

var tests = [XCTestCaseEntry]()
tests += AllDisabledTests.allTests()
XCTMain(tests)