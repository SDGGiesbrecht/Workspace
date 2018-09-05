struct FailingDocumentationCoverage {
    var text = "Hello, World!"
}

public func undocumented() {}

public var inferredType = false

/// A description.
///
/// # Excessive Heading
///
/// ### Heading
public func excessiveHeading() {}
