/*
 TestCoverageExemptionToken.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A test coverage exemption token.
public struct TestCoverageExemptionToken : Codable, Hashable {

    // MARK: - Initialization

    /// Creates a test coverage exemption token.
    public init(_ token: StrictString, scope: Scope) {
        self.token = token
        self.scope = scope
    }

    // MARK: - Properties

    /// The text of the token.
    public var token: StrictString

    /// The scope.
    public var scope: Scope
}
