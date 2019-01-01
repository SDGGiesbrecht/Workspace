/*
 XCTestManifests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

extension APITests {
    static let __allTests = [
        ("testAllDisabled", testAllDisabled),
        ("testAllTasks", testAllTasks),
        ("testBadStyle", testBadStyle),
        ("testCheckForUpdates", testCheckForUpdates),
        ("testContinuousIntegrationWithoutScripts", testContinuousIntegrationWithoutScripts),
        ("testCustomProofread", testCustomProofread),
        ("testCustomReadMe", testCustomReadMe),
        ("testDefaults", testDefaults),
        ("testExecutable", testExecutable),
        ("testFailingDocumentationCoverage", testFailingDocumentationCoverage),
        ("testFailingTests", testFailingTests),
        ("testHelp", testHelp),
        ("testHeaders", testHeaders),
        ("testInvalidResourceDirectory", testInvalidResourceDirectory),
        ("testInvalidTarget", testInvalidTarget),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testLocalizationIdentifier", testLocalizationIdentifier),
        ("testMissingExample", testMissingExample),
        ("testMissingReadMeLocalization", testMissingReadMeLocalization),
        ("testMultipleProducts", testMultipleProducts),
        ("testNoLibraries", testNoLibraries),
        ("testNoLocalizations", testNoLocalizations),
        ("testOneProductMultipleModules", testOneProductMultipleModules),
        ("testPartialReadMe", testPartialReadMe),
        ("testSDGLibrary", testSDGLibrary),
        ("testSDGTool", testSDGTool),
        ("testSelfSpecificScripts", testSelfSpecificScripts)
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testGitIgnoreCoverage", testGitIgnoreCoverage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility)
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests)
    ]
}
#endif
