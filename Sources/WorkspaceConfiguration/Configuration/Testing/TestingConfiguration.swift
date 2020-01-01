/*
 TestingConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(TestingConfiguration)
/// Einstellungen zur Erstellung und zum Testen.
public typealias Testeinstellungen = TestingConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(TestingConfiguration)
/// Options related to building and testing.
public struct TestingConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestingConfiguration.prohibitCompilerWarnings)
  /// Whether or not to prohibit compiler warnings.
  ///
  /// This is on by default.
  ///
  /// ```shell
  /// $ workspace validate build
  /// ```
  public var prohibitCompilerWarnings: Bool = true
  // @localization(🇩🇪DE) @crossReference(TestingConfiguration.prohibitCompilerWarnings)
  /// Ob Arbeitsbereich Übersetzerwarnungen verbieten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  ///
  /// ```shell
  /// $ arbeitsbereich prüfen erstellung
  /// ```
  public var übersetzerwarnungenVerbieten: Bool {
    get { return prohibitCompilerWarnings }
    set { prohibitCompilerWarnings = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestingConfiguration.enforceCoverage)
  /// Whether or not to enforce test coverage.
  ///
  /// This is on by default.
  ///
  /// ```shell
  /// $ workspace validate test‐coverage
  /// ```
  public var enforceCoverage: Bool = true
  // @localization(🇩🇪DE) @crossReference(TestingConfiguration.enforceCoverage)
  /// Ob Arbeitsbereich Testabdeckung erzwingen soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung ein.
  ///
  /// ```shell
  /// $ arbeitsbereich prüfen testabdeckung
  /// ```
  public var abdeckungErzwingen: Bool {
    get { return enforceCoverage }
    set { enforceCoverage = newValue }
  }

  // @localization(🇩🇪DE) @crossReference(TestingConfiguration.exemptionTokens)
  // #example(1, testabdeckungsausnahmen), #example(2, testCoverageExemptionTokens)
  /// Die aktive Testabdeckungsausnahmszeichen.
  ///
  /// Wenn nicht angegeben, sind die folgenden Zeichen aktiv (direkt aus dem Quelltext):
  ///
  /// ```swift
  /// Testabdeckungsausnahmszeichen("@ausnahme(zu: teste)", geltungsbereich: .selbeZeile),
  ///
  /// Testabdeckungsausnahmszeichen("behaupten", geltungsbereich: .selbeZeile),
  /// Testabdeckungsausnahmszeichen("behauptungsfehlschlag", geltungsbereich: .vorstehendeZeile),
  /// Testabdeckungsausnahmszeichen("voraussetzung", geltungsbereich: .selbeZeile),
  /// Testabdeckungsausnahmszeichen(
  ///   "voraussetzungsfehlschlag",
  ///   geltungsbereich: .vorstehendeZeile
  /// ),
  /// Testabdeckungsausnahmszeichen("unbehebbarerFehler", geltungsbereich: .vorstehendeZeile),
  ///
  /// Testabdeckungsausnahmszeichen("stammmethode", geltungsbereich: .vorstehendeZeile),
  /// Testabdeckungsausnahmszeichen("unerreichbar", geltungsbereich: .vorstehendeZeile),
  /// Testabdeckungsausnahmszeichen("prüfen", geltungsbereich: .selbeZeile),
  /// Testabdeckungsausnahmszeichen("fehlschlagen", geltungsbereich: .selbeZeile)
  /// ```
  ///
  /// Und auch die englische Formen:
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
  /// TestCoverageExemptionToken("fail", scope: .sameLine),
  /// ```
  public var ausnahmensZeichen: Menge<Testabdeckungsausnahmszeichen> {
    get { return exemptionTokens }
    set { exemptionTokens = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestingConfiguration.exemptionTokens)
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
  /// TestCoverageExemptionToken("fail", scope: .sameLine),
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
    TestCoverageExemptionToken("fail", scope: .sameLine),
    // @endExample
    // @beispiel(testabdeckungsausnahmen)
    Testabdeckungsausnahmszeichen("@ausnahme(zu: teste)", geltungsbereich: .selbeZeile),

    Testabdeckungsausnahmszeichen("behaupten", geltungsbereich: .selbeZeile),
    Testabdeckungsausnahmszeichen("behauptungsfehlschlag", geltungsbereich: .vorstehendeZeile),
    Testabdeckungsausnahmszeichen("voraussetzung", geltungsbereich: .selbeZeile),
    Testabdeckungsausnahmszeichen(
      "voraussetzungsfehlschlag",
      geltungsbereich: .vorstehendeZeile
    ),
    Testabdeckungsausnahmszeichen("unbehebbarerFehler", geltungsbereich: .vorstehendeZeile),

    Testabdeckungsausnahmszeichen("stammmethode", geltungsbereich: .vorstehendeZeile),
    Testabdeckungsausnahmszeichen("unerreichbar", geltungsbereich: .vorstehendeZeile),
    Testabdeckungsausnahmszeichen("prüfen", geltungsbereich: .selbeZeile),
    Testabdeckungsausnahmszeichen("fehlschlagen", geltungsbereich: .selbeZeile)
    // @beispielBeenden
  ]

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestingConfiguration.exemptPaths)
  /// Paths exempt from test coverage.
  ///
  /// The paths must be specified relative to the package root.
  public var exemptPaths: Set<String> = []
  // @localization(🇩🇪DE) @crossReference(TestingConfiguration.exemptPaths)
  /// Pfade, die Ausnahmen zur Testabdeckung sind.
  ///
  /// Die Pfade sind relativ zur Paketenwurzel.
  public var ausnahmspfade: Menge<Zeichenkette> {
    get { return exemptPaths }
    set { exemptPaths = newValue }
  }
}
