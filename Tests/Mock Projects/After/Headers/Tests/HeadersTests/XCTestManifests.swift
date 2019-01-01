/*
 XCTestManifests.swift

 This source file is part of the Headers open source project.

 Copyright ©2019 the Headers project contributors.
 */

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HeadersTests.allTests),
    ]
}
#endif
