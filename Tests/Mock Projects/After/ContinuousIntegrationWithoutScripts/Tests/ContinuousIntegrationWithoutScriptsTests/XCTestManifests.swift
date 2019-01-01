/*
 XCTestManifests.swift

 This source file is part of the ContinuousIntegrationWithoutScripts open source project.

 Copyright ©2019 the ContinuousIntegrationWithoutScripts project contributors.

 Licensed under the MIT Licence.
 See https://opensource.org/licenses/MIT for licence information.
 */

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContinuousIntegrationWithoutScriptsTests.allTests),
    ]
}
#endif
