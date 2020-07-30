import XCTest

import WSCrossPlatformTests
import WorkspaceLibraryTests

var tests = [XCTestCaseEntry]()
tests += WSCrossPlatformTests.__allTests()
tests += WorkspaceLibraryTests.__allTests()

XCTMain(tests)
