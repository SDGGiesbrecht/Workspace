/*
 SDGTests.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©[Current Date] John Doe and the SDG project contributors.
 Urheberrecht ©[Current Date] John Doe und die Mitwirkenden des SDG‐Projekts.
 ©[Current Date]

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest
@testable import Library

class SDGTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(SDG().text(), "Hello, World!")
  }

  func testResources() {
    _ = Library.Resources.Namespace.dataResource
    _ = Library.Resources._2001_01_01_NamedWithNumbers
    _ = Library.Resources._namedWithPunctuation
    _ = Library.Resources.textResource
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
