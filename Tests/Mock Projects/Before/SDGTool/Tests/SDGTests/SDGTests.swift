import XCTest
@testable import Library

class SDGTests : XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SDG().text(), "Hello, World!")
    }
  
    func testResources() {
      _ = Library.Resources.dataResource
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
