/*
 TestCoverageExemptionToken.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Not properly localized yet.)
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
/// A test coverage exemption token.
public struct TestCoverageExemptionToken : Codable, Hashable {

    // MARK: - Initialization

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Creates a test coverage exemption token.
    ///
    /// - Parameters:
    ///     - token: The text of the token.
    ///     - scope: The scope of the token’s effect.
    public init(_ token: StrictString, scope: Scope) {
        self.token = token
        self.scope = scope
    }

    // MARK: - Properties

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The text of the token.
    public var token: StrictString

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The scope.
    public var scope: Scope
}
