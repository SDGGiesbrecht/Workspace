/*
 LinuxMain.swift

 This source file is part of the Headers open source project.

 Copyright ©2018 the Headers project contributors.
 */

import XCTest

import HeadersTests

var tests = [XCTestCaseEntry]()
tests += HeadersTests.allTests()
XCTMain(tests)
