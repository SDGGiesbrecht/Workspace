/*
 ProofreadingConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(ProofreadingConfiguration)
/// Einstellungen zur Korrektur.
///
/// ```shell
/// $ arbeitsbereich korrektur‐lesen
/// ```
public typealias Korrektureinstellungen = ProofreadingConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProofreadingConfiguration)
/// Options related to proofreading.
///
/// ```shell
/// $ workspace proofread
/// ```
public struct ProofreadingConfiguration: Codable {

  // #workaround(swift-format 0.0.50700, listSeparation is disabled because SwiftFormat ignores its configuration.) @exempt(from: unicode)
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingConfiguration.rules)
  /// The set of active proofreading rules.
  ///
  /// All rules are active by default.
  ///
  /// Individual proofreading violations can be suppressed by placing `@exempt(from: ruleIdentifier)` on the same line.
  public var rules: Set<ProofreadingRule> = Set(ProofreadingRule.allCases) ∖ [.listSeparation]
  // @localization(🇩🇪DE) @crossReference(ProofreadingConfiguration.rules)
  /// Die Menge gültiger Korrekturreglen.
  ///
  /// Wenn nicht angegeben, sind alle Regeln gültig.
  ///
  /// Einzelne Verstöße können unterdrückt werden, in dem `@ausnahme(zu: regelkennzeichen)` auf der selben Zeile plaziert wird.
  public var regeln: Menge<Korrekturregel> {
    get { return rules }
    set { rules = newValue }
  }

  #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
    // @localization(🇩🇪DE) @crossReference(swiftFormatConfiguration)
    /// Die SwiftFormat‐Konfiguration.
    ///
    /// Wenn `nil`, werden keine SwiftFormat‐Aufgaben ausgeführt.
    public var swiftFormatKonfiguration: SwiftFormatKonfiguration? {
      get { return swiftFormatConfiguration }
      set { swiftFormatConfiguration = newValue }
    }
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(swiftFormatConfiguration)
    /// The SwiftFormat configuration.
    ///
    /// When `nil`, no SwiftFormat tasks will be carried out.
    public var swiftFormatConfiguration: SwiftFormatConfiguration.Configuration? = .default
  #endif

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(unicodeRuleScope)
  /// The scope in which to apply the `unicode` rule.
  public var unicodeRuleScope: Set<UnicodeRuleScope> = Set(UnicodeRuleScope.allCases)
  // @localization(🇩🇪DE) @crossReference(unicodeRuleScope)
  /// Das Geltungsbereich der Unicode‐Regel.
  public var geltungsbereichUnicodeRegel: Menge<GeltungsbereichUnicodeRegel> {
    get { return unicodeRuleScope }
    set { unicodeRuleScope = newValue }
  }
}
