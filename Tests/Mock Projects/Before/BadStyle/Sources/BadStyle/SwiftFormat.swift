
func triggerSwiftFormatWithOverload(_ closure: (Bool) -> Bool) {}
func triggerSwiftFormatWithOverload(_ closure: (Int) -> Int)

let TriggerSwiftFormatWithBadCasing = true

struct Namespace { // Should trigger because not an enumeration.
  static let property = 0
}
struct ExemptNamespace {  // @exempt(from: swiftFormat[UseEnumForNamespacing])
  static let property = 0
}
