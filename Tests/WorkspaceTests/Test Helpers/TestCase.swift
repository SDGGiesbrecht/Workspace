/*
 TestCase.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
import Foundation

import SDGCornerstone
import SDGCommandLine

class TestCase : XCTestCase {

    static var initialized = false

    override func setUp() {
        if ¬TestCase.initialized {
            TestCase.initialized = true
            SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.Workspace.Tests", version: nil, packageURL: nil)
        }
        super.setUp()
    }
}
