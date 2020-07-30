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

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  import Foundation
#endif
#if !os(Android)  // #workaround(Swift 5.2.4, Linkage broken in SDK.)
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif
#endif
#if canImport(FoundationXML)
  import FoundationXML
#endif

// #workaround(Swift 5.2.4, Web lacks Dispatch.)
#if !os(WASI)
  import Dispatch
#endif

#if !os(Windows)  // #workaround(Swift 5.2.4, Cannot build C.)
  import WSCrossPlatformC
#endif

// #workaround(Swift 5.2.4, SwiftFormat cannot build.)
#if !os(WASI)
  import SwiftFormatConfiguration  // External package.
#endif

public func helloWorld() {
  print("Hello, world!")
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    print(NSString(string: "Hello, Foundation!"))
    #if !os(Android)  // #workaround(Swift 5.2.4, Linkage broken in SDK.)
      print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
    #endif
    print(XMLElement(name: "Hello, FoundationXML!"))
  #endif
  // #workaround(Swift 5.2.4, Web lacks Dispatch.)
  #if !os(WASI)
    print(DispatchQueue(label: "Hello, Dispatch!"))
  #endif
  #if !os(Windows)  // #workaround(Swift 5.2.4, Cannot build C.)
    helloC()
  #endif
  // #workaround(Swift 5.2.4, SwiftFormat cannot build.)
  #if !os(WASI)
    print(Configuration())
  #endif
}

internal func helloTests() {
  print("Hello, tests!")
}
