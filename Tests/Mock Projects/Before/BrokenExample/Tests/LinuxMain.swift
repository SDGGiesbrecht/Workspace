import XCTest

import BrokenExampleTests

var tests = [XCTestCaseEntry]()
tests += BrokenExampleTests.allTests()
XCTMain(tests)
