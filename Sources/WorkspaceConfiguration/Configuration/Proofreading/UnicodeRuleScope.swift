/*
 UnicodeRuleScope.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(UnicodeRuleScope)
/// Ein Geltungsbereich für die Unicode‐Regel.
public typealias GeltungsbereichUnicodeRegel = UnicodeRuleScope
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(UnicodeRuleScope)
/// A scope of application for the `unicode` rule.
public enum UnicodeRuleScope: String, CaseIterable, Decodable, Encodable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(UnicodeRuleScope.humanLanguage)
  /// Scopes which are usually human language, such as documentation and comments.
  case humanLanguage
  // @localization(🇩🇪DE) @crossReference(UnicodeRuleScope.humanLanguage)
  /// Bereiche, wo meistens nur menschliche Sprache auftaucht, wie Dokumentation und Kommentare.
  public static var menschlicheSprache: GeltungsbereichUnicodeRegel {
    return .humanLanguage
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(UnicodeRuleScope.machineIdentifiers)
  /// Scopes which are usually machine identifiers, such as variable and function names.
  case machineIdentifiers
  // @localization(🇩🇪DE) @crossReference(UnicodeRuleScope.machineIdentifiers)
  /// Bereiche, wo meistens nur maschinenkennzeichnungen auftauchen, wie Variable‐ und Funktionsnamen.
  public static var maschinenkennzeichungen: GeltungsbereichUnicodeRegel {
    return .machineIdentifiers
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(UnicodeRuleScope.ambiguous)
  /// Scopes commonly used for both human language and machine identifiers, such as string literals.
  case ambiguous
  // @localization(🇩🇪DE) @crossReference(UnicodeRuleScope.ambiguous)
  /// Bereiche, wo oft beide menschliche Sprache und maschinenkennzeichnungen auftauchen, wie Zeichenkettenliterale.
  public static var uneindeutig: GeltungsbereichUnicodeRegel {
    return .ambiguous
  }
}
