/*
 SDGTests.swift

 This source file is part of the SDG open source project.
 https://example.github.io/SDG/SDG

 Copyright ©2018 John Doe and the SDG project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
@testable import Library

class SDGTests : XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SDG().text(true), "Hello, World!")
        XCTAssertEqual(SDG().text(false), "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}

// @example(Read‐Me 🇨🇦EN)
// 🇨🇦EN
// @endExample

// @example(Read‐Me 🇬🇧EN)
// 🇬🇧EN
// @endExample

// @example(Read‐Me 🇺🇸EN)
// 🇺🇸EN
// @endExample

// @example(Read‐Me 🇩🇪DE)
// 🇩🇪DE
// @endExample

// @example(Read‐Me 🇫🇷FR)
// 🇫🇷FR
// @endExample

// @example(Read‐Me 🇬🇷ΕΛ)
// 🇬🇷ΕΛ
// @endExample

// @example(Read‐Me 🇮🇱עב)
// 🇮🇱עב
// @endExample

// @example(Read‐Me zxx)
// zxx
// @endExample
