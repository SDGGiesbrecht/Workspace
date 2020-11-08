/*
 CrossPlatform.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
#if !os(Android)  // #workaround(Swift 5.2.4, Linkage broken in SDK.)
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif
#endif
#if canImport(FoundationXML)
  #if !os(WASI)  // #workaround(Swift 5.3, FoundationXML is broken.)
    import FoundationXML
  #endif
#endif

import Dispatch

import CrossPlatformC

// #workaround(Swift 5.3, SwiftFormat cannot build.)
#if !os(WASI)
  import SwiftFormatConfiguration  // External package.
#endif

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  #if !os(Android)  // #workaround(Swift 5.2.4, Linkage broken in SDK.)
    #if !os(WASI)  // #workaround(Swift 5.3, Web lacks FoundationNetworking.)
      print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
    #endif
  #endif
  #if !os(WASI)  // #workaround(Swift 5.3, FoundationXML is broken.)
    print(XMLElement(name: "Hello, FoundationXML!"))
  #endif
  #if !os(WASI)  // #workaround(Swift 5.3, Web lacks DispatchQueue.)
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
