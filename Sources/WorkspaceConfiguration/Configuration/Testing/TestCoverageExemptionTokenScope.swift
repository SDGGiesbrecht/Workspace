/*
 TestCoverageExemptionTokenScope.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension TestCoverageExemptionToken {

  // @localization(🇩🇪DE) @crossReference(Scope)
  /// Der Geltungsbereich einer Testabdeckungsausnahme.
  public typealias Geltungsbereich = Scope
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Scope)
  /// The scope of a test coverage exemption.
  public enum Scope: String, Codable {

    // MARK: - Cases

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Scope.sameLine)
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
    // @localization(🇩🇪DE) @crossReference(Scope.sameLine)
    /// Dieser Geltungsbereich gilt für Abdeckungsbereiche, die auf der selbe Zeile beginnen als das Zeichen.
    ///
    /// Dieser Geltungsbereich ist nützlich für Funktionen wie `behaupten`, die untestbare Diagnosemeldungen haben:
    ///
    /// ```swift
    /// behaupten(x == y, "Es gibt ein Problem: \(problem)")
    /// // ↑↑↑↑↑↑
    /// // Die Zeichenketteninterpolation kann nicht mit Testen abgedeckt werden...
    /// // ...aber das „behaupten“‐Zeichen erlaubt es als Ausnahme.
    /// ```
    ///
    /// Dieser Geltungbereich ist auch von dem allgemeinen Ausnahme verwendet, `@ausnahme(zu: tests)`.
    ///
    /// ```swift
    /// func untestbareFunktion() { // @ausnahme(zu: teste)
    ///     // Die Ausnahme gilt hier.
    /// }
    /// ```
    public static var selbeZeile: Geltungsbereich {
      return .sameLine
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Scope.previousLine)
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
    // @localization(🇩🇪DE) @crossReference(Scope.previousLine)
    /// Dieser Geltungsbereich gilt für Abdeckungsbereiche, die auf der Zeile vor dem Zeichen beginnen.
    ///
    /// Dieser Geltungsbereich ist nützlich für Funktionen wie `preconditionFailure`, die sich in untestbare Quellzweigen befinden:
    ///
    /// ```swift
    /// guard let x = y else { // ← Der ungetesteter Bereich fängt beim Klammer an...
    ///     voraussetzungsfehlschlag("Das soll nie geschehen.")
    ///  // ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    ///  // ...aber das „voraussetzungsfehlschlag“‐Zeichen erlaubt es als Ausnahme.
    /// }
    ///
    /// // Solche Zeichen gelten auch am der selben Zeile, damit folgende Abschlüsse erlaubt werden:
    /// guard let x = y else { voraussetzungsfehlschlag("Das soll nie geschehen.") }
    /// ```
    public static var vorstehendeZeile: Geltungsbereich {
      return .previousLine
    }
  }
}
