/*
 WindowsMain.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

@testable import WSWindowsTests

#if os(macOS)
  import Foundation

  typealias XCTestCaseClosure = (XCTestCase) throws -> Void
  typealias XCTestCaseEntry = (
    testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)]
  )

  func test<T: XCTestCase>(_ testFunc: @escaping (T) -> () throws -> Void) -> XCTestCaseClosure {
    return { testCaseType in
      try testFunc(testCaseType as! T)()
    }
  }
  func testCase<T: XCTestCase>(_ allTests: [(String, (T) -> () throws -> Void)]) -> XCTestCaseEntry
  {
    let tests: [(String, XCTestCaseClosure)] = allTests.map { ($0.0, test($0.1)) }
    return (T.self, tests)
  }
  func XCTMain(_ testCases: [XCTestCaseEntry]) -> Never {
    for testGroup in testCases {
      let testClass = testGroup.testCaseClass.init()
      print(type(of: testClass))
      for test in testGroup.allTests {
        print(test.0)
        do {
          try test.1(testClass)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    exit(EXIT_SUCCESS)
  }
#endif

extension WindowsTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testTests", testTests),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += WindowsTests.windowsTests

XCTMain(tests)
