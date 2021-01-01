/*
 main.swift


 ©[Current Date]

 Licensed under the MIT Licence.
 See https://opensource.org/licenses/MIT for licence information.
 */

import XCTest

@testable import ContinuousIntegrationWithoutScriptsTests

extension ContinuousIntegrationWithoutScriptsTests.ContinuousIntegrationWithoutScriptsTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testExample", testExample)
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests +=
  ContinuousIntegrationWithoutScriptsTests.ContinuousIntegrationWithoutScriptsTests.windowsTests

XCTMain(tests)
