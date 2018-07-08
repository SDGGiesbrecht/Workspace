/*
 LinuxMain.swift

 This source file is part of the ContinuousIntegrationWithoutScripts open source project.

 Copyright ©2018 the ContinuousIntegrationWithoutScripts project contributors.

 Licensed under the MIT Licence.
 See https://opensource.org/licenses/MIT for licence information.
 */

import XCTest

import ContinuousIntegrationWithoutScriptsTests

var tests = [XCTestCaseEntry]()
tests += ContinuousIntegrationWithoutScriptsTests.allTests()
XCTMain(tests)
