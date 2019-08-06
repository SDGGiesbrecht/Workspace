/*
 TestingConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

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

    // #example(1, testCoverageExemptionTokens)
    /// The set of active test coverage exemption tokens.
    ///
    /// The default tokens, taken straight from the source code, are:
    ///
    /// ```swift
    /// TestCoverageExemptionToken("@exempt(from: tests)", scope: .sameLine),
    ///
    /// TestCoverageExemptionToken("assert", scope: .sameLine),
    /// TestCoverageExemptionToken("assertionFailure", scope: .previousLine),
    /// TestCoverageExemptionToken("precondition", scope: .sameLine),
    /// TestCoverageExemptionToken("preconditionFailure", scope: .previousLine),
    /// TestCoverageExemptionToken("fatalError", scope: .previousLine),
    /// TestCoverageExemptionToken("@unknown", scope: .sameLine),
    ///
    /// TestCoverageExemptionToken("primitiveMethod", scope: .previousLine),
    /// TestCoverageExemptionToken("unreachable", scope: .previousLine),
    /// TestCoverageExemptionToken("test", scope: .sameLine),
    /// TestCoverageExemptionToken("fail", scope: .sameLine)
    /// ```
    public var exemptionTokens: Set<TestCoverageExemptionToken> = [
        // @example(testCoverageExemptionTokens)
        TestCoverageExemptionToken("@exempt(from: tests)", scope: .sameLine),

        TestCoverageExemptionToken("assert", scope: .sameLine),
        TestCoverageExemptionToken("assertionFailure", scope: .previousLine),
        TestCoverageExemptionToken("precondition", scope: .sameLine),
        TestCoverageExemptionToken("preconditionFailure", scope: .previousLine),
        TestCoverageExemptionToken("fatalError", scope: .previousLine),
        TestCoverageExemptionToken("@unknown", scope: .sameLine),

        TestCoverageExemptionToken("primitiveMethod", scope: .previousLine),
        TestCoverageExemptionToken("unreachable", scope: .previousLine),
        TestCoverageExemptionToken("test", scope: .sameLine),
        TestCoverageExemptionToken("fail", scope: .sameLine)
        // @endExample
    ]

    /// Paths exempt from test coverage.
    ///
    /// The paths must be specified relative to the package root.
    public var exemptPaths: Set<String> = []
}
