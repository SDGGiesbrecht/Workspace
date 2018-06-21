/*
 TestingConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to building and testing.
public struct TestingConfiguration : Codable {

    /// Whether or not to prohibit compiler warnings.
    ///
    /// This is on by default.
    ///
    /// ```shell
    /// $ workspace validate build
    /// ```
    public var prohibitCompilerWarnings: Bool = true

    /// Whether or not to enforce test coverage.
    ///
    /// This is on by default.
    ///
    /// ```shell
    /// $ workspace validate test‐coverage
    /// ```
    public var enforceCoverage: Bool = true

    // [_Example 1: Test Coverage Exemption Tokens_]
    /// The set of active test coverage exemption tokens.
    ///
    /// The default tokens, taken straight from the source code, are:
    ///
    /// ```swift
    /// TestCoverageExemptionToken("[_Exempt from Test Coverage_]", scope: .sameLine),
    /// TestCoverageExemptionToken("assert", scope: .sameLine),
    /// TestCoverageExemptionToken("assertionFailure", scope: .previousLine),
    /// TestCoverageExemptionToken("precondition", scope: .sameLine),
    /// TestCoverageExemptionToken("preconditionFailure", scope: .previousLine),
    /// TestCoverageExemptionToken("fatalError", scope: .sameLine),
    /// TestCoverageExemptionToken("primitiveMethod", scope: .previousLine),
    /// TestCoverageExemptionToken("unreachable", scope: .previousLine),
    /// TestCoverageExemptionToken("test", scope: .sameLine),
    /// TestCoverageExemptionToken("fail", scope: .sameLine)
    /// ```
    public var testCoverageExemptions: Set<TestCoverageExemptionToken> = [
        // [_Define Example: Test Coverage Exemption Tokens_]
        TestCoverageExemptionToken("[_Exempt from Test Coverage_]", scope: .sameLine),
        TestCoverageExemptionToken("assert", scope: .sameLine),
        TestCoverageExemptionToken("assertionFailure", scope: .previousLine),
        TestCoverageExemptionToken("precondition", scope: .sameLine),
        TestCoverageExemptionToken("preconditionFailure", scope: .previousLine),
        TestCoverageExemptionToken("fatalError", scope: .sameLine),
        TestCoverageExemptionToken("primitiveMethod", scope: .previousLine),
        TestCoverageExemptionToken("unreachable", scope: .previousLine),
        TestCoverageExemptionToken("test", scope: .sameLine),
        TestCoverageExemptionToken("fail", scope: .sameLine)
        // [_End_]
    ]
}
