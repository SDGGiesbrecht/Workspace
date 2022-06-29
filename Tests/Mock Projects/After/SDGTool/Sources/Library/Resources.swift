/*
 Resources.swift

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

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  #if !os(WASI)
    private static let moduleBundle: Bundle = {
      let main = Bundle.main.executableURL?.resolvingSymlinksInPath().deletingLastPathComponent()
      let module = main?.appendingPathComponent("SDG_Library.bundle")
      return module.flatMap({ Bundle(url: $0) }) ?? Bundle.module
    }()
  #endif
  #if os(WASI)
    private static let _2001_01_01_NamedWithNumbers0: [UInt8] = [
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
      0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ]
    internal static var _2001_01_01_NamedWithNumbers: String {
      return String(
        data: Data(([_2001_01_01_NamedWithNumbers0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var _2001_01_01_NamedWithNumbers: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(
            forResource: "2001‐01‐01 (Named with Numbers)",
            withExtension: "txt"
          )!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
  #if os(WASI)
    private static let _namedWithPunctuation0: [UInt8] = [
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
      0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ]
    internal static var _namedWithPunctuation: String {
      return String(
        data: Data(([_namedWithPunctuation0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var _namedWithPunctuation: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(
            forResource: "(Named with) Punctuation!",
            withExtension: "txt"
          )!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
  #if os(WASI)
    internal static var dataResource: Data {
      return Data(([] as [[UInt8]]).lazy.joined())
    }
  #else
    internal static var dataResource: Data {
      return try! Data(
        contentsOf: moduleBundle.url(forResource: "Data Resource", withExtension: nil)!,
        options: [.mappedIfSafe]
      )
    }
  #endif
  #if os(WASI)
    private static let textResource0: [UInt8] = [
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
      0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ]
    internal static var textResource: String {
      return String(
        data: Data(([textResource0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var textResource: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(forResource: "Text Resource", withExtension: "txt")!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif

}
