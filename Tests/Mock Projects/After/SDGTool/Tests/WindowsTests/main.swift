/*
 main.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©[Current Date] John Doe and the SDG project contributors.
 Urheberrecht ©[Current Date] John Doe und die Mitwirkenden des SDG‐Projekts.
 ©[Current Date]

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

@testable import SDGTests

extension SDGTests.SDGTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testExample", testExample)
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += SDGTests.SDGTests.windowsTests

XCTMain(tests)
