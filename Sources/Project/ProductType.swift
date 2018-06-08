
extension ProductType {

    public var isLibrary: Bool {
        if case .library = self {
            return true
        } else {
            return false
        }
    }
}
