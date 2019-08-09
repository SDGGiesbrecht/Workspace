/*
 TestCoverageExemptionTokenScope.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension TestCoverageExemptionToken {

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The scope of a test coverage exemption.
    public enum Scope : String, Codable {

        // MARK: - Cases

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// This scope affects coverage ranges beginning on the same line as the token.
        ///
        /// This scope is useful for functions like `assert`, which have untestable diagnostic messages:
        ///
        /// ```swift
        /// assert(x == y, "There is a problem: \(problem)")
        /// // ↑↑↑
        /// // The string interpolation cannot be covered by tests...
        /// // ...but the “assert” token causes it to be exempt.
        /// ```
        ///
        /// This is also the scope of the general exemption, `@exempt(from: tests)`.
        ///
        /// ```swift
        /// func untestableFunction() { // @exempt(from: tests)
        ///     // This is exempt.
        /// }
        /// ```
        case sameLine

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// This scope affects coverage ranges beginning on the line before the token (or on the same line).
        ///
        /// This scope is useful for functions like `preconditionFailure`, which reside in untestable code branches.
        ///
        /// ```swift
        /// guard let x = y else { // ← The untested range starts at this brace...
        ///     preconditionFailure("This should never happen.")
        ///  // ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        ///  // ...but the “preconditionFailure” token causes it to be exempt.
        /// }
        ///
        /// // Previous line tokens also affect the same line, so trailing closures still work:
        /// guard let x = y else { preconditionFailure("This should never happen.") }
        /// ```
        case previousLine
    }
}
