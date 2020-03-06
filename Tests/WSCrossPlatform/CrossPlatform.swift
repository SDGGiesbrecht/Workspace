/*
 WSWindowsLibrary.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
#if !os(Android)  // #workaround(Swift 5.1.3, Linkage broken in SDK.)
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif
#endif
#if canImport(FoundationXML)
  import FoundationXML
#endif

import Dispatch

#if !os(Windows) // #workaround(Cannot build C.)
import WSCrossPlatformC
#endif

import SwiftFormatConfiguration // External package.

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  #if !os(Android)  // #workaround(Swift 5.1.3, Linkage broken in SDK.)
    print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
  #endif
  print(XMLElement(name: "Hello, FoundationXML!"))
  print(DispatchQueue(label: "Hello, Dispatch!"))
  #if !os(Windows) // #workaround(Cannot build C.)
  helloC()
  #endif
  print(Configuration())
}

internal func helloTests() {
  print("Hello, tests!")
}
