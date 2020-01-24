import XCTest

@testable import DeutschTests

extension DeutschTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testExample", testExample),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += DeutschTests.windowsTests

XCTMain(tests)
