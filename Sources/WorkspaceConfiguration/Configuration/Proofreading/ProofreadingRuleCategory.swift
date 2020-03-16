/*
 ProofreadingRuleCategory.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ProofreadingRule {

  // @localization(🇩🇪DE) @crossReference(Category)
  /// Eine Klasse von Kurrekturregeln.
  public typealias Klasse = Category
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category)
  /// A category of proofreading rule.
  public enum Category {

    // MARK: - Cases

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.deprecation)
    /// Temporary rules which help with updating Workspace by catching deprecated usage.
    case deprecation
    // @localization(🇩🇪DE) @crossReference(Category.deprecation)
    /// Vorübergehende Regel, die das Aktualisiern von Arbeitsbereich helfen, in dem sie Überholtes erwischen.
    public static var überholung: Klasse {
      return .deprecation
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.intentional)
    /// Warnings which are requested manually.
    case intentional
    // @localization(🇩🇪DE) @crossReference(Category.intentional)
    /// Warnungen die absichtlich von Hand verursacht werden.
    public static var absichtlich: Klasse {
      return .intentional
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.functionality)
    /// Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
    case functionality
    // @localization(🇩🇪DE) @crossReference(Category.functionality)
    /// Regeln, die versichern, dass Entwicklungswerkzeuge (Arbeitsbereich, Xcode, usw.) wie vorhergesehen funktionieren.
    public static var funktionalität: Klasse {
      return functionality
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.documentation)
    /// Rules which improve documentation quality.
    case documentation
    // @localization(🇩🇪DE) @crossReference(Category.documentation)
    /// Regeln, die die Dokumentationsqualität erhöhen.
    public static var dokumentation: Klasse {
      return documentation
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.textStyle)
    /// Rules which enforce consistent text style.
    case textStyle
    // @localization(🇩🇪DE) @crossReference(Category.textStyle)
    /// Regeln, die einheitlicher Textstil erzwingen.
    public static var textstil: Klasse {
      return textStyle
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category.sourceCodeStyle)
    /// Rules which enforce consistent source code style.
    case sourceCodeStyle
    // @localization(🇩🇪DE) @crossReference(Category.sourceCodeStyle)
    /// Regeln, die einheitlicher Quellstil erzwingen.
    public static var quellstil: Klasse {
      return sourceCodeStyle
    }
  }
}
