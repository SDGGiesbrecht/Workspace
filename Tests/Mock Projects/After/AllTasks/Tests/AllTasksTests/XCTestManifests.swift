/*
 XCTestManifests.swift

 This source file is part of the AllTasks open source project.

 Copyright ©2019 the AllTasks project contributors.

 This software is subject to copyright law.
 It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s).
 */

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AllTasksTests.allTests),
    ]
}
#endif
