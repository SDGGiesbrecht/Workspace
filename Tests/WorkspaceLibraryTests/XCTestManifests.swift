/*
 XCTestManifests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

extension APITests {
    static let __allTests = [
        ("testBadStyle", testBadStyle),
        ("testCheckForUpdates", testCheckForUpdates),
        ("testCustomProofread", testCustomProofread),
        ("testCustomReadMe", testCustomReadMe),
        ("testDefaults", testDefaults),
        ("testExecutableProjectType", testExecutableProjectType),
        ("testFailingDocumentationCoverage", testFailingDocumentationCoverage),
        ("testFailingTests", testFailingTests),
        ("testHelp", testHelp),
        ("testInvalidConfigurationEnumerationValue", testInvalidConfigurationEnumerationValue),
        ("testInvalidReference", testInvalidReference),
        ("testInvalidRelatedProject", testInvalidRelatedProject),
        ("testInvalidResourceDirectory", testInvalidResourceDirectory),
        ("testInvalidTarget", testInvalidTarget),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testNoAbout", testNoAbout),
        ("testNoAuthor", testNoAuthor),
        ("testNoDescription", testNoDescription),
        ("testNoDocumentationURL", testNoDocumentationURL),
        ("testNoExamples", testNoExamples),
        ("testNoFeatures", testNoFeatures),
        ("testNoLocalizations", testNoLocalizations),
        ("testNoMacOS", testNoMacOS),
        ("testNoMacOSOrIOS", testNoMacOSOrIOS),
        ("testNoMacOSOrIOSOrWatchOS", testNoMacOSOrIOSOrWatchOS),
        ("testNoOther", testNoOther),
        ("testNoQuotation", testNoQuotation),
        ("testNoQuotationSource", testNoQuotationSource),
        ("testNoRepositoryURL", testNoRepositoryURL),
        ("testPartialReadMe", testPartialReadMe),
        ("testSDGLibrary", testSDGLibrary),
        ("testSDGTool", testSDGTool),
        ("testSelfSpecificScripts", testSelfSpecificScripts),
        ("testUndefinedConfigurationValue", testUndefinedConfigurationValue),
        ("testUnicodeSource", testUnicodeSource)
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testDocumentationCoverage", testDocumentationCoverage),
        ("testGitIgnoreCoverage", testGitIgnoreCoverage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility)
    ]
}

#if !os(macOS)
// MARK: - #if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests)
    ]
}
#endif
