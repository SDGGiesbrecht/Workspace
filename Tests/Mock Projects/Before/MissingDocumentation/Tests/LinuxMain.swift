import XCTest

import MissingDocumentationTests

var tests = [XCTestCaseEntry]()
tests += MissingDocumentationTests.allTests()
XCTMain(tests)