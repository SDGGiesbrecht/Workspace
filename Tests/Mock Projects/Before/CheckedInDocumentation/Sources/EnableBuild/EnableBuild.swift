open class Simple<T> : Hashable {
    public static func == (lhs: Simple<T>, rhs: Simple<T>) -> Bool { return false }
    public func hash(into hasher: inout Hasher) {}
}
public struct Metatype<T> {}
public struct BaseType<T> {
    public struct Member {}
}
public struct Unwrapped<T> {}
public protocol Composition {}
public struct Type {}

public struct Resources {
    public static let deutsch: String = ""
    public static let english: String = ""
}
