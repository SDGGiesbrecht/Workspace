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

@testable import WSAndroidTests
@testable import WSWindowsTests
@testable import WorkspaceLibraryTests

#if os(macOS)
  import Foundation

  typealias XCTestCaseClosure = (XCTestCase) throws -> Void
  typealias XCTestCaseEntry = (
    testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)]
  )

  func test<T: XCTestCase>(
    _ testFunc: @escaping (T) -> () throws -> Void
  ) -> XCTestCaseClosure {
    return { try testFunc($0 as! T)() }
  }

  func testCase<T: XCTestCase>(
    _ allTests: [(String, (T) -> () throws -> Void)]
  ) -> XCTestCaseEntry {
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

extension WSAndroidTests.AndroidTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testTemporaryDirectoryPermissions", testTemporaryDirectoryPermissions),
      ("testCachePermissions", testCachePermissions),
    ])
  ]
}

extension WSWindowsTests.WindowsTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testTests", testTests),
    ])
  ]
}

extension WorkspaceLibraryTests.APITests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testAllDisabled", testAllDisabled),
      ("testAllTasks", testAllTasks),
      ("testArray", testArray),
      ("testBadStyle", testBadStyle),
      ("testBrokenExample", testBrokenExample),
      ("testBrokenTests", testBrokenTests),
      ("testCheckedInDocumentation", testCheckedInDocumentation),
      ("testCheckForUpdates", testCheckForUpdates),
      ("testConfiguration", testConfiguration),
      ("testConfiguartionContext", testConfiguartionContext),
      ("testContinuousIntegrationWithoutScripts", testContinuousIntegrationWithoutScripts),
      ("testCustomProofread", testCustomProofread),
      ("testCustomReadMe", testCustomReadMe),
      ("testCustomTasks", testCustomTasks),
      ("testDefaults", testDefaults),
      ("testDeutsch", testDeutsch),
      ("testExecutable", testExecutable),
      ("testFailingCustomTasks", testFailingCustomTasks),
      ("testFailingCustomValidation", testFailingCustomValidation),
      ("testFailingDocumentationCoverage", testFailingDocumentationCoverage),
      ("testFailingTests", testFailingTests),
      ("testHeaders", testHeaders),
      ("testHelp", testHelp),
      ("testInvalidResourceDirectory", testInvalidResourceDirectory),
      ("testInvalidTarget", testInvalidTarget),
      ("testIssueTemplate", testIssueTemplate),
      ("testLazyOption", testLazyOption),
      ("testLicence", testLicence),
      ("testLocalizationIdentifier", testLocalizationIdentifier),
      ("testMissingDocumentation", testMissingDocumentation),
      ("testMissingExample", testMissingExample),
      ("testMissingReadMeLocalization", testMissingReadMeLocalization),
      ("testMultipleProducts", testMultipleProducts),
      ("testNoLibraries", testNoLibraries),
      ("testNoLocalizations", testNoLocalizations),
      ("testNurDeutsch", testNurDeutsch),
      ("testOneLocalization", testOneLocalization),
      ("testOneProductMultipleModules", testOneProductMultipleModules),
      ("testOnlyBritish", testOnlyBritish),
      ("testPartialReadMe", testPartialReadMe),
      ("testProofreadingRule", testProofreadingRule),
      ("testRelatedProject", testRelatedProject),
      ("testSDGLibrary", testSDGLibrary),
      ("testSDGTool", testSDGTool),
      ("testSelfSpecificScripts", testSelfSpecificScripts),
      ("testTestCoverageExemptionToken", testTestCoverageExemptionToken),
      ("testUnicodeRuleScope", testUnicodeRuleScope),
    ])
  ]
}

extension WorkspaceLibraryTests.InternalTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testGitIgnoreCoverage", testGitIgnoreCoverage),
      ("testPlatform", testPlatform),
      ("testXcodeProjectFormat", testXcodeProjectFormat),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += WSAndroidTests.AndroidTests.windowsTests
tests += WSWindowsTests.WindowsTests.windowsTests
tests += WorkspaceLibraryTests.APITests.windowsTests
tests += WorkspaceLibraryTests.InternalTests.windowsTests

XCTMain(tests)
