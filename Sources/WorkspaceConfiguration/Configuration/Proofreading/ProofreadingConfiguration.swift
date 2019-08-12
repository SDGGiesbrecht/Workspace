/*
 ProofreadingConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

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
public struct ProofreadingConfiguration : Codable {

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// The set of active proofreading rules.
    ///
    /// All rules are active by default.
    ///
    /// Individual proofreading violations can be suppressed by placing `@exempt(from: ruleIdentifier)` on the same line.
    public var rules: Set<ProofreadingRule> = Set(ProofreadingRule.allCases)
    // @localization(🇩🇪DE)
    /// Die Menge gültiger Korrekturreglen.
    ///
    /// Wenn nicht angegeben, sind alle Regeln gültig.
    ///
    /// Einzelne Verstöße können unterdrückt werden, in dem `@ausnahme(zu: regelkennzeichen)` auf der selben Zeile plaziert wird.
    public var regeln: Menge<Korrekturregel> {
        get { return rules }
        set { rules = newValue }
    }

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The scope in which to apply the `unicode` rule.
    public var unicodeRuleScope: Set<UnicodeRuleScope> = Set(UnicodeRuleScope.allCases)
}
