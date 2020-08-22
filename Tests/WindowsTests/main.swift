/*
 main.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

@testable import WSCrossPlatformTests
@testable import WorkspaceTests

import XCTest

extension WSCrossPlatformTests.CrossPlatformTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testCachePermissions", testCachePermissions),
      ("testGit", testGit),
      (
        "testReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyLongTestName",
        testReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyLongTestName
      ),
      ("testRepositoryPresence", testRepositoryPresence),
      ("testTemporaryDirectoryPermissions", testTemporaryDirectoryPermissions),
      ("testTests", testTests),
    ])
  ]
}

extension WorkspaceTests.APITests {
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

extension WorkspaceTests.InternalTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testGitIgnoreCoverage", testGitIgnoreCoverage),
      ("testPlatform", testPlatform),
      ("testXcodeProjectFormat", testXcodeProjectFormat),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += WSCrossPlatformTests.CrossPlatformTests.windowsTests
tests += WorkspaceTests.APITests.windowsTests
tests += WorkspaceTests.InternalTests.windowsTests

XCTMain(tests)
