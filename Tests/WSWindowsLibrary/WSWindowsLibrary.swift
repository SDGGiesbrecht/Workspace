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
#if !os(Android)  // #workaround(Until Android can import these.)
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif
  #if canImport(FoundationXML)
    import FoundationXML
  #endif
#endif

import Dispatch

#if !os(Android)  // #workaround(Until Android can import these.)
  import SwiftFormatConfiguration
#endif

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  #if !os(Android)  // #workaround(Until Android can import these.)
    print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
    print(XMLElement(name: "Hello, FoundationXML!"))
  #endif
  print(DispatchQueue(label: "Hello, Dispatch!"))
  #if !os(Android)  // #workaround(Until Android can import these.)
    print(Configuration())
  #endif
}

internal func helloTests() {
  print("Hello, tests!")
}
