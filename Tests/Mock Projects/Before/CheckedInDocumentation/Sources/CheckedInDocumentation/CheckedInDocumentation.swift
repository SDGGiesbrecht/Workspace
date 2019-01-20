struct CheckedInDocumentation {
    var text = "Hello, World!"
}

/// A class.
///
/// Overview.
///
/// - Attention: Something to be attentive to.
///
/// - Author: The author.
///
/// - Authors: The authors.
///
/// - Bug: A bug.
///
/// - Copyright: ©0000 Someone.
///
/// - Date: 0000‐00‐00
///
/// - Experiment: An experiment.
///
/// - Important: Something important.
///
/// - LocalizationKey: SOME_KEY
///
/// - Note: A note.
///
/// - Remark: A remark.
///
/// - Remarks: Some remarks.
///
/// - SeeAlso: Something related.
///
/// - Since: The time it became available.
///
/// - Tag: A tag.
///
/// - ToDo: Something that still needs doing.
///
/// - Version: 0.0.0
///
/// - Warning: A warning.
///
/// - Keyword: keyword
public class Class {}

/// A structure.
public struct Structure : Equatable {

    /// A type property.
    ///
    /// Discussion.
    public static var typeProperty: Bool = false

    /// A type method.
    ///
    /// - Complexity: O(?)
    ///
    /// - Parameter parameterOne: The first parameter.
    /// - Parameter parameterTwo: The second parameter.
    ///
    /// - Invariant: Something invariant.
    ///
    /// - Postcondition: Something true after the method is executed.
    ///
    /// - Precondition: Some initial requirement.
    ///
    /// - Returns: A return value.
    ///
    /// - Requires: A requirement.
    ///
    /// - Throws: Several errors.
    ///
    /// - Recommended: better()
    ///
    /// - RecommendedOver: worse()
    public static func typeMethod(parameterOne: Int, parameterTwo: Int) throws -> Int {}

    /// An operator.
    ///
    /// - Parameters:
    ///     - lhs: The preceding parameter.
    ///     - rhs: The following parameter.
    public static func <(lhs: Structure, rhs: Structure) -> Bool {
        return true
    }

    public static func ==(lhs: Structure, rhs: Structure) -> Bool {
        // A conformance.
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
    ///
    /// - MutatingVariant: mutatingVariant()
    ///
    /// - NonmutatingVariant: nonmutatingVariant()
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

/// A generic structure.
public struct GenericStructure<GenericParameter> {}

extension Array where Element : Equatable {
    /// A constrained method.
    public func constrained() {}
}

/// An operator.
infix operator ≠
/// A precedence.
precedencegroup Precedence {}
