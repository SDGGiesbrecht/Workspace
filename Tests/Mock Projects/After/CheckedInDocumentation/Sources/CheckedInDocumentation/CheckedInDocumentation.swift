struct CheckedInDocumentation {
    var text = "Hello, World!"
}

/// A class.
public class Class {}

/// A structure.
public struct Structure {

    /// An initializer.
    public init() {}
}

/// An enumeration.
public enum Enumeration {

    /// A case.
    case enumerationCase
}

/// A type alias.
public typealias TypeAlias = Structure

extension Bool {

    /// An extension method.
    public func extensionMethod() {}
}

/// A protocol
public protocol Protocol {

    /// An associated type.
    associatedtype AssociatedType
}

/// A global variable.
public var globalVariable: Bool = false
