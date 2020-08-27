import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
#if canImport(FoundationXML)
  import FoundationXML
#endif
import Dispatch
import HelloC

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  print(URLCredential(user: "Hello,", password: "FoundationNetworking", persistence: .none))
  print(XMLElement(name: "Hello, FoundationXML!"))
  print(DispatchQueue(label: "Hello, Dispatch!"))
  helloC()
}

internal func helloTests() {
  print("Hello, tests!")
}
