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
        ("testCheckForUpdates", testCheckForUpdates),
        ("testDefaults", testDefaults),
        ("testHelp", testHelp),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testSelfSpecificScripts", testSelfSpecificScripts),
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testDocumentationCoverage", testDocumentationCoverage),
        ("testGitIgnoreCoverage", testGitIgnoreCoverage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests),
    ]
}
#endif
