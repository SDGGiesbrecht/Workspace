/// ...
///
/// - Parameters:
///   - documented: A parameter that does not exist.
public func mismatchedParameter(actual: Bool) {}

/// Stranded documentation.
///
/// - Parameters:
///   - stranded: A stranded parameter.
import Foundation

/// ...
///
/// - Parameters:
///   - cannot: A parameter that cannot exist.
public struct NeverHasParameters {

  /// ...
  ///
  /// - Parameters:
  ///   - documented: A parameter that does not exist.
  public init(actual: Bool) {}

  /// ...
  ///
  /// - Parameters:
  ///   - documented: A parameter that does not exist.
  public subscript(actual: Bool) -> Bool {
    return false
  }
}
