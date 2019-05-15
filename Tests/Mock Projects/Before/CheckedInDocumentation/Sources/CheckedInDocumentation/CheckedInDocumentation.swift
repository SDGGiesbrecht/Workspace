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
    ///
    /// - Parameters:
    ///     - parameterName: A parameter.
    public init(label parameterName: Bool) {}

    /// A property.
    public var typeProperty: Bool = false

    /// A subscript.
    ///
    /// - Parameters:
    ///     - subscript: The subscript index.
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

    /// A protocol requirement.
    func protocolRequirement()

    /// A customization point.
    func customizationPoint()
}
extension Protocol {
    
    public func customizationPoint() {}

    /// A provided extension.
    public func providedExtension() {}
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

/// ...
///
/// - Parameters:
///     - simple: A simple parameter.
///     - nestedInSimple: A nested parameter.
///     - metatype: A metatype parameter.
///     - nestedInMetatype: A nested parameter.
///     - member: A member parameter.
///     - nestedInMember: A nested parameter.
///     - optional: An optional parameter.
///     - nestedInOptional: A nested parameter.
///     - unwrapped: An implicitly unwrapped parameter.
///     - nestedInUnwrapped: A nested parameter.
///     - tuple: A tuple parameter.
///     - nestedInTuple: A nested parameter.
///     - alsoNestedInTuple: A nested parameter.
public func demonstrateParameters(
    simple: Simple<(_ nestedInSimple: Bool) -> Void>,
    metatype: Metatype<(_ nestedInMetatype: Bool) -> Void>.Type,
    member: BaseType<(_ nestedInMember: Bool) -> Void>.Member,
    optional: Optional<(_ nestedInOptional: Bool) -> Void>?,
    unwrapped: Unwrapped<(_ nestedInUnwrapped: Bool) -> Void>!,
    tuple: (nestedInTuple: Bool, alsoNestedInTuple: Bool)
    ) {}

/// ...
///
/// - Parameters:
///     - composition: A composition parameter.
///     - nestedInComposition: A nested parameter.
///     - array: An array parameter.
///     - nestedInArray: A nested parameter.
///     - dictionary: A dictionary parameter.
///     - nestedInDictionaryKey: A nested parameter.
///     - nestedInDictionaryValue: A nested parameter.
///     - function: A function parameter.
///     - nestedInFunction: A nested parameter.
///     - attributed: An attributed parameter.
///     - nestedInAttributed: A nested parameter.
public func demonstrateMoreParameters(
    composition: Composition & Simple<(_ nestedInComposition: Bool) -> Void>,
    array: [Simple<(_ nestedInArray: Bool) -> Void>],
    dictionary: [Simple<(_ nestedInDictionaryKey: Bool) -> Void>: Simple<(_ nestedInDictionaryValue: Bool) -> Void>],
    function: (_ nestedInFunction: Bool) -> Void,
    attributed: inout Simple<(_ nestedInAttributed: Bool) -> Void>
    ) {}

/// An intermediate protocol.
public protocol IntermediateProtocol : Protocol {
    /// A method from the intermediate protocol.
    func intermediateProtocolMethod()
}

/// A top‐level conformer.
public struct TopConformer : IntermediateProtocol {
    public typealias AssociatedType = Bool
    public func intermediateProtocolMethod() {}
}

/// A variable with a closure type.
///
/// - Parameters:
///     - aParameter: A parameter.
public var variable: (_ aParameter: Type) -> Void

/// A function with a closure in a tuple.
///
/// - Parameters:
///     - aParameter: A parameter.
///     - tupleHalfA: The first element of the tuple.
///     - closureParameter: The parameter of the closure.
///     - tupleHalfB: The second element of the tuple.
public func function(parameter aParameter: (tupleHalfA: (_ closureParameter: Int) -> Void, tupleHalfB: Bool)) {}

/// A base class.
public class BaseClass {
    /// A base class method.
    public func baseClassMethod() {}
}

/// A subclass.
public class Subclass : BaseClass {
    public override func baseClassMethod() {}
}
