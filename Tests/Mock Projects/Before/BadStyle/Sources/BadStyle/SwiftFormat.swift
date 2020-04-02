
func triggerSwiftFormatWithOverload(_ closure: (Bool) -> Bool) {}
func triggerSwiftFormatWithOverload(_ closure: (Int) -> Int)

let TriggerSwiftFormatWithBadCasing = true
let DontTrigger = false  // @exempt(from: swiftFormat[AlwaysUseLowerCamelCase])
