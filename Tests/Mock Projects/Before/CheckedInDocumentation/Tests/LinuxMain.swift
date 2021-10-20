import XCTest

import CheckedInDocumentationTests

var tests = [XCTestCaseEntry]()
tests += CheckedInDocumentationTests.allTests()
XCTMain(tests)