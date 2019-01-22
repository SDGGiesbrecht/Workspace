struct FailingDocumentationCoverage {
    var text = "Hello, World!"
}

public func undocumented() {}

public var inferredType = false

private func forSwiftSyntax() {}
/// A description.
///
/// # Excessive Heading
///
/// ### Heading
public func excessiveHeading() {}

/// ...
///
/// - Parameters:
///     - paramOne: Misnamed parameter.
///     - parameterTwo: Non‐existent parameter.
public func mismatchedParameters(parameterOne: Int) {}
