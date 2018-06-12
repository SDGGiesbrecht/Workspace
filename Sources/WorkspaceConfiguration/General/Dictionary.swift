
extension Dictionary where Key == LocalizationIdentifier {

    /// Accesses the respective localized value.
    public subscript<L>(_ key: L) -> Value? where L : Localization {
        get {
            return self[LocalizationIdentifier(key)]
        }
        set {
            self[LocalizationIdentifier(key)] = newValue
        }
    }
}
