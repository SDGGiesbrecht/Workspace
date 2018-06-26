
import WSGeneralImports

extension Optional where Wrapped : SearchableCollection {
    // MARK: - where Wrapped : SearchableCollection

    internal func contains<C : SearchableCollection>(_ pattern: C) -> Bool where C.Element == Wrapped.Element {
        switch self {
        case .some(let wrapped):
            return wrapped.contains(LiteralPattern(pattern))
        case .none:
            return false
        }
    }
}
