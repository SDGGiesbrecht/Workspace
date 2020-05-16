import XCTest

@testable import DeutschTests

extension DeutschTests.DeutschTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testExample", testExample)
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += DeutschTests.DeutschTests.windowsTests

XCTMain(tests)
