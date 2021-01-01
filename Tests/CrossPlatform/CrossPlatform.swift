/*
 CrossPlatform.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
#if canImport(FoundationXML)
  #if !os(WASI)  // #workaround(Swift 5.3, FoundationXML is broken.)
    import FoundationXML
  #endif
#endif

#if !os(WASI)  // #workaround(Swift 5.3, Web lacks Dispatch.)
  import Dispatch
#endif

import CrossPlatformC

// #workaround(Swift 5.3, SwiftFormat cannot build.)
#if !os(WASI)
  import SwiftFormatConfiguration  // External package.
#endif

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  #if !os(WASI)  // #workaround(Swift 5.3, Web lacks FoundationNetworking.)
    print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
  #endif
  #if !os(WASI)  // #workaround(Swift 5.3, FoundationXML is broken.)
    print(XMLElement(name: "Hello, FoundationXML!"))
  #endif
  #if !os(WASI)  // #workaround(Swift 5.3, Web lacks Dispatch.)
    print(DispatchQueue(label: "Hello, Dispatch!"))
  #endif
  helloC()
  // #workaround(Swift 5.3, SwiftFormat cannot build.)
  #if !os(WASI)
    print(Configuration())
  #endif
}

internal func helloTests() {
  print("Hello, tests!")
}
