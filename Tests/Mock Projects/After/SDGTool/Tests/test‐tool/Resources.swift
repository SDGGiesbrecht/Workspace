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

enum Resources {}
typealias Ressourcen = Resources

extension Resources {
  #if !os(WASI)
    private static let moduleBundle: Bundle = {
      let main = Bundle.main.executableURL?.resolvingSymlinksInPath().deletingLastPathComponent()
      let module = main?.appendingPathComponent("SDG_test‐tool.bundle")
      return module.flatMap({ Bundle(url: $0) }) ?? Bundle.module
    }()
  #endif
  #if os(WASI)
    private static let textResource0: [UInt8] = [
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
      0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ]
    static var textResource: String {
      return String(
        data: Data(([textResource0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    static var textResource: String {
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
