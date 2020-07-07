import Foundation
#if canImport(FoundationXML)
  import FoundationXML
#endif
import Dispatch
import HelloC

public func helloWorld() {
  print("Hello, world!")
  print(NSString(string: "Hello, Foundation!"))
  print(XMLElement(name: "Hello, FoundationXML!"))
  print(DispatchQueue(label: "Hello, Dispatch!"))
  helloC()
}

internal func helloTests() {
  print("Hello, tests!")
}
