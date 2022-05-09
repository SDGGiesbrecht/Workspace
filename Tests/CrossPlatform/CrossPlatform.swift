/*
 CrossPlatform.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
#if !PLATFORM_LACKS_FOUNDATION_NETWORKING
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif
#endif
#if !PLATFORM_LACKS_FOUNDATION_XML
  #if canImport(FoundationXML)
    import FoundationXML
  #endif
#endif

#if !PLATFORM_LACKS_DISPATCH
  import Dispatch
#endif

import CrossPlatformC

#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
  import SwiftFormatConfiguration  // External package.
#endif

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  #if !PLATFORM_LACKS_FOUNDATION_NETWORKING && !PLATFORM_LACKS_FOUNDATION_NETWORKING_URL_CREDENTIAL_INIT_USER_PASSWORD_PERSISTENCE
    print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
  #endif
  #if !PLATFORM_LACKS_FOUNDATION_XML
    print(XMLElement(name: "Hello, FoundationXML!"))
  #endif
  #if !PLATFORM_LACKS_DISPATCH
    print(DispatchQueue(label: "Hello, Dispatch!"))
  #endif
  helloC()
  #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
    print(Configuration())
  #endif
}

internal func helloTests() {
  print("Hello, tests!")
}

public func getResource() throws -> String {
  guard let url = Bundle.module.url(forResource: "Resource", withExtension: "txt") else {
    fatalError("Failed to locate resource!")
  }
  let data = try Data(contentsOf: url)
  guard let text = String(data: data, encoding: .utf8) else {
    fatalError("Failed to decode text.")
  }
  return text
}
