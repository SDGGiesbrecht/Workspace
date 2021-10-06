import Foundation

import SDGText

import WorkspaceConfiguration

import XCTest

import SDGXCTestUtilities

#if os(watchOS)
  // #workaround(SDGCornerstone 7.2.3, Real TestCase unavailable.)
  class TestCase: XCTestCase {}
#endif
class RegressionTests: TestCase {

  func testLocalizationIdentifierDecodes() {
    // Untracked

    func encodeAndDecode<T: Codable>(instance: T) {
      do {
        let encoded = try JSONEncoder().encode([instance])
        print("Encoded:")
        print(String(data: encoded, encoding: .utf8)!)
        let decoded = try JSONDecoder().decode([T].self, from: encoded)
        print("Decoded:")
        print(decoded)
      } catch {
        XCTFail("\(error)")
      }
    }
    let english = LocalizationIdentifier("en")
    encodeAndDecode(instance: english)
    let dictionary: [LocalizationIdentifier: StrictString] = [english: "..."]
    encodeAndDecode(instance: dictionary)
    struct Container: Codable {
      let dictionary: [LocalizationIdentifier: StrictString]
    }
    let container = Container(dictionary: dictionary)
    encodeAndDecode(instance: container)
  }
}
