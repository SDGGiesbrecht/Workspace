import XCTest

import WorkspaceLibraryTests
import SDGXCTestUtilities

var tests = [XCTestCaseEntry]()
tests += WorkspaceLibraryTests.__allTests()
tests += SDGXCTestUtilities.__allTests()

XCTMain(tests)
