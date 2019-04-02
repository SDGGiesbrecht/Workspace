import XCTest

import FailingCustomTasksTests

var tests = [XCTestCaseEntry]()
tests += FailingCustomTasksTests.allTests()
XCTMain(tests)
