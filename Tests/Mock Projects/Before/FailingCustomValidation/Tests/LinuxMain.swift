import XCTest

import FailingCustomValidationTests

var tests = [XCTestCaseEntry]()
tests += FailingCustomValidationTests.allTests()
XCTMain(tests)
