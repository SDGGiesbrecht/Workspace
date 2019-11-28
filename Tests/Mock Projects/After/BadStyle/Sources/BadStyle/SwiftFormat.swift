func triggerSwiftFormatWithOverload(_ closure: (Bool) -> Bool) {}
func triggerSwiftFormatWithOverload(_ closure: (Int) -> Int)

let TriggerSwiftFormatWithBadCasing = true

struct Namespace { //  @exempt(from: swiftFormat[UseEnumForNamespacing])
  static let property = 0
}
