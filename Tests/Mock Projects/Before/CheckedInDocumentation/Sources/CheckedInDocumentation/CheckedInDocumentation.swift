struct CheckedInDocumentation {
    var text = "Hello, World!"
}

/// A class.
public class Class {}

/// A structure.
public struct Structure : Equatable {

    /// A type property.
    public static var typeProperty: Bool = false

    /// A type method.
    public static func typeMethod() {}

    /// An operator.
    public static func ==(lhs: Structure, rhs: Structure) -> Bool {
        return true
    }

    /// An initializer.
    public init() {}

    /// A property.
    public var typeProperty: Bool = false

    /// A subscript.
    public subscript(_ subscript: Bool) -> Bool {
        return `subscript`
    }
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

/// A function.
public func function() {}

/// A global variable.
public var globalVariable: Bool = false

#if canImport(AppKit)
/// Conditionally compiled.
public func conditionallyCompiled() {}
#endif
