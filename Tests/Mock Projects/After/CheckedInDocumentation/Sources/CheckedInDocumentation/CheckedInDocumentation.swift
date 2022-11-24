import EnableBuild

struct CheckedInDocumentation {
  var text = "Hello, World!"
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
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
public class Class: AmericanEnglishProtocol, BritishEnglishProtocol, CanadianEnglishProtocol {}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A structure.
public struct Structure: Equatable {

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A type property.
  ///
  /// Discussion.
  public static var typeProperty: Bool = false

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
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
  public static func typeMethod(parameterOne: Int, parameterTwo: Int) throws -> Int {
    return 0
  }

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// An operator.
  ///
  /// - Parameters:
  ///     - lhs: The preceding parameter.
  ///     - rhs: The following parameter.
  public static func < (lhs: Structure, rhs: Structure) -> Bool {
    return true
  }

  public static func == (lhs: Structure, rhs: Structure) -> Bool {
    // A conformance.
    return true
  }

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// An initializer.
  ///
  /// - Parameters:
  ///     - parameterName: A parameter.
  public init(label parameterName: Bool) {}

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A property.
  public var typeProperty: Bool = false

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A subscript.
  ///
  /// - Parameters:
  ///     - subscript: The subscript index.
  public subscript(_ subscript: Bool) -> Bool {
    return `subscript`
  }
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// An enumeration.
public enum Enumeration {

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A case.
  case enumerationCase
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A type alias.
public typealias TypeAlias = Structure

extension Bool {

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// An extension method.
  ///
  /// - MutatingVariant: mutatingVariant()
  ///
  /// - NonmutatingVariant: nonmutatingVariant()
  public func extensionMethod() {}
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A protocol.
public protocol Protocol {

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// An associated type.
  associatedtype AssociatedType

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A protocol requirement.
  func protocolRequirement()

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A customization point.
  func customizationPoint()
}
extension Protocol {

  public func customizationPoint() {}

  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A provided extension.
  public func providedExtension() {}
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A function.
public func function() {}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A global variable.
public var globalVariable: Bool = false

#if canImport(AppKit)
  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// Conditionally compiled.
  public func conditionallyCompiled() {}
#endif

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A generic structure.
public struct GenericStructure<GenericParameter> {}

extension Array where Element: Equatable {
  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A constrained method.
  public func constrained() {}
}

// @localization(zxx)
/// ...
// @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇩🇪DE)
/// An operator.
infix operator ≠
// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A precedence.
precedencegroup Precedence {
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// ...
///
/// - Parameters:
///     - simple: A simple parameter.
///     - metatype: A metatype parameter.
///     - member: A member parameter.
///     - optional: An optional parameter.
///     - unwrapped: An implicitly unwrapped parameter.
///     - tuple: A tuple parameter.
public func demonstrateParameters(
  simple: Simple<(_ nestedInSimple: Bool) -> Void>,
  metatype: Metatype<(_ nestedInMetatype: Bool) -> Void>.Type,
  member: BaseType<(_ nestedInMember: Bool) -> Void>.Member,
  optional: Optional<(_ nestedInOptional: Bool) -> Void>?,
  unwrapped: Unwrapped<(_ nestedInUnwrapped: Bool) -> Void>!,
  tuple: (nestedInTuple: Bool, alsoNestedInTuple: Bool)
) {}

#if !os(macOS)  // Compiler bug in Swift 5.6.
  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// ...
  ///
  /// - Parameters:
  ///     - composition: A composition parameter.
  ///     - array: An array parameter.
  ///     - dictionary: A dictionary parameter.
  ///     - function: A function parameter.
  ///     - attributed: An attributed parameter.
  public func demonstrateMoreParameters(
    composition: Composition & Simple<(_ nestedInComposition: Bool) -> Void>,
    array: [Simple<(_ nestedInArray: Bool) -> Void>],
    dictionary: [Simple<(_ nestedInDictionaryKey: Bool) -> Void>: Simple<
      (_ nestedInDictionaryValue: Bool) -> Void
    >],
    function: (_ nestedInFunction: Bool) -> Void,
    attributed: inout Simple<(_ nestedInAttributed: Bool) -> Void>
  ) {}
#endif

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// An intermediate protocol.
public protocol IntermediateProtocol: Protocol {
  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A method from the intermediate protocol.
  func intermediateProtocolMethod()
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A top‐level conformer.
public struct TopConformer: IntermediateProtocol {
  public typealias AssociatedType = Bool
  public func intermediateProtocolMethod() {}
  public func protocolRequirement() {}
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A variable with a closure type.
public var variable: (_ aParameter: Type) -> Void = { _ in }

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A function with a closure in a tuple.
///
/// - Parameters:
///     - aParameter: A parameter.
public func function(
  parameter aParameter: (tupleHalfA: (_ closureParameter: Int) -> Void, tupleHalfB: Bool)
) {}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A base class.
public class BaseClass {
  // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// A base class method.
  public func baseClassMethod() {}
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A subclass.
public class Subclass: BaseClass {
  public override func baseClassMethod() {}
}

// @localization(🇩🇪DE) @localization(zxx)
/// ...
// @localization(🇨🇦EN) @crossReference(doSomethingInCanadianEnglish())
/// Does something in Canadian English.
public func doSomethingInCanadianEnglish() {}

// @localization(🇬🇧EN) @crossReference(doSomethingInCanadianEnglish())
/// Does something in British English.
public func doSomethingInBritishEnglish() {}

// @localization(🇺🇸EN) @crossReference(doSomethingInCanadianEnglish())
/// Does something in American English.
public func doSomethingInAmericanEnglish() {}

// @localization(🇩🇪DE) @localization(zxx)
/// ...
// @localization(🇨🇦EN) @crossReference(Protocol)
/// A Canadian English protocol.
public protocol CanadianEnglishProtocol {}
// @localization(🇬🇧EN) @crossReference(Protocol)
/// A British English protocol.
public protocol BritishEnglishProtocol {}
// @localization(🇺🇸EN) @crossReference(Protocol)
/// An American English protocol.
public protocol AmericanEnglishProtocol {}

// @localization(🇬🇧EN) @crossReference(Aliased)
/// ...
public typealias Alias = Aliased
// @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx) @crossReference(Aliased)
/// ...
public struct Aliased {
  // @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx) @crossReference(aliased)
  /// ...
  public var aliased: String?
  // @localization(🇬🇧EN) @crossReference(aliased)
  /// ...
  public var alias: String? {
    get { return aliased }
    set { aliased = newValue }
  }
}

// @localization(🇬🇧EN) @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// ...
///
/// - Parameters:
///     - aliased: ...
public func use(aliased: Aliased) {}

extension Dictionary where Value == Aliased {

  // @localization(🇬🇧EN) @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
  /// ...
  ///
  /// - Parameters:
  ///     - i: ...
  public subscript(_ i: Aliased) -> Aliased {
    return i
  }
}

// @localization(🇩🇪DE) @crossReference(LocalizedEnumeration)
/// ...
public typealias LokalisierterAufzählung = LocalizedEnumeration
// @localization(🇬🇧EN) @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(zxx) @crossReference(LocalizedEnumeration)
/// ...
public enum LocalizedEnumeration {

  // @localization(🇬🇧EN) @localization(🇨🇦EN) @localization(🇺🇸EN) @localization(zxx) @crossReference(LocalizedEnumeration.localizedEnumerationCase)
  /// ...
  case localizedEnumerationCase
  // @localization(🇩🇪DE) @crossReference(LocalizedEnumeration.localizedEnumerationCase)
  /// ...
  public static var lokalisierterAufzählungsfall: LokalisierterAufzählung {
    return .localizedEnumerationCase
  }
}

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// ...
///
/// ```swift
/// let x = LokalisierterAufzählung.lokalisierterAufzählungsfall
/// ```
public func demonstratingLocalizedEnumerationCase() {}

// @localization(🇩🇪DE) @notLocalized(🇨🇦EN) @notLocalized(🇬🇧EN) @notLocalized(🇺🇸EN) @notLocalized(zxx)
/// ...
public func nurAufDeutsch() {}
