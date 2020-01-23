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
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
#if canImport(FoundationXML)
  import FoundationXML
#endif

import Dispatch

public func helloWorld() {
  // @exempt(from: tests) #workaround(Not testable yet.)
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
  print(XMLElement(name: "Hello, FoundationXML!"))
  print(DispatchQueue(label: "Hello, Dispatch!"))
}

internal func helloTests() {
  // @exempt(from: tests) #workaround(Not testable yet.)
  print("Hello, tests!")
}
