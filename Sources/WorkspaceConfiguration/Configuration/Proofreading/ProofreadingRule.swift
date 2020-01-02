/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

// @localization(🇩🇪DE) @crossReference(ProofreadingRule)
/// Eine Korrekturregel.
public typealias Korrekturregel = ProofreadingRule
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProofreadingRule)
/// A proofreading rule.
public enum ProofreadingRule: String, CaseIterable, Codable {

  // MARK: - Cases

  // ••••••• Deprecation •••••••

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.deprecatedTestManifests)
  /// Catches deprecated test manifests.
  case deprecatedTestManifests
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.deprecatedTestManifests)
  /// Erwischt überholte Testlisten.
  public static var überholteTestlisten: Korrekturregel {
    return .deprecatedTestManifests
  }

  // ••••••• Intentional •••••••

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.manualWarnings)
  /// Catches generic manual warnings.
  ///
  /// Generic warnings are for times when you want to prevent the project from passing validation until you come back to fix something, but you still need the project to build while you are working on it.
  ///
  /// The text, `#warning(Some description here.)`, will always trigger a warning during proofreading and cause validation to fail. It will not interrupt Swift or Xcode builds.
  case manualWarnings
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.manualWarnings)
  /// Erwischt allgemeine, von Hand erstellte Warnungen.
  ///
  /// Allgemeine Warnungen sind für Fälle, wo das Projekt verhindert werden soll, die Prüfung zu bestehen, bis etwas behoben ist, aber das Projekt muss immer noch erfolgreich erstellt werden können.
  ///
  /// Die Zeichenkette `#warnung(Eine Beschreibung hier.)` wird immer eine Warnung während Korrektur auslösen. Es wird die Erstellung des Projekts per Swift und Xcode nicht verhindern.
  public static var warnungenVonHand: Korrekturregel {
    return .manualWarnings
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.missingImplementation)
  /// Catches unimplemented code paths marked with SDGCornerstone functions.
  case missingImplementation
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.missingImplementation)
  /// Erwischt Quellpfaden, die mit Funktionen aus SDGCornerstone als unimplementiert markiert sind.
  public static var fehlendeImplementierung: Korrekturregel {
    return .missingImplementation
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.workaroundReminders)
  /// Catches outdated workaround reminders.
  ///
  /// Workaround reminders are for times when you need to implement a temporary workaround because of a problem in a dependency, and you would like to remind yourself to go back and remove the workaround once the dependency is fixed.
  ///
  /// The text, `#workaround(Some description here.)` will trigger a warning during proofreading, but will still pass validation.
  ///
  /// ### Version Detection
  ///
  /// Optionally, a workaround reminder can specify the dependency and version were the problem exists. Then Workspace will ignore it until the problematic version is out of date.
  ///
  /// `#workaround(SomeDependency 0.0.0, Some description here.)`
  ///
  /// The dependency can be specified three different ways.
  ///
  /// - Package dependencies can be specified using the exact name of the package.
  ///
  ///   ```swift
  ///   // #workaround(MyLibrary 1.0.0, There is a problem in MyLibrary.)
  ///   ```
  ///
  /// - Swift itself can be specified with the string `Swift`.
  ///
  ///   ```swift
  ///   // #workaround(Swift 3.0.2, There is a problem with Swift.)
  ///   ```
  ///
  /// - Arbitrary dependencies can be specified by shell commands which output a version number. Workspace will look for the first group of the characters `0`–`9` and `.` in the command output. Only simple commands are supported; commands cannot contain quotation marks.
  ///
  ///   ```swift
  ///   // #workaround(git --version 2.10.1, There is a problem with Git.) @exempt(from: unicode)
  ///   ```
  case workaroundReminders
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.workaroundReminders)
  /// Erwischt veraltete Notlösungserinnerungen.
  ///
  /// Notlösungserinnerungen sind für Fälle, wo eine vorübergehende Notlösung implementiert wird, weil ein es Problem in eine Abhängigkeit gibt, und eine Erinnnerung hinterlassen werden soll, die Notlösung zu entfernen, sobald die Abhängigkeit instand gesetzt ist.
  ///
  /// Die Zeichenkette `#notlösung(Eine Beschreibung.)` wird eine Warnung während der Korrektur auslösen, aber das Projekt wird die Prüfung trotzdem bestehen.
  ///
  /// ### Versionerkennung
  ///
  /// Notlösungserinnerungen können auch die Version eines Abhängigkeits angeben, wo das Problem existiert. Dann wird Arbeitsbereich die Erinnerungen übergehen, bis die Version veraltet ist.
  ///
  /// `#notlösung(EineAbhängigkeit 0.0.0, Eine Beschreibung.)`
  ///
  /// Die Abhängigkeit kann auf drei Arten angegeben werden.
  ///
  /// - Paketenabhängikeiten werden mit dem Paketennamen angegeben.
  ///
  ///   ```swift
  ///   // #notlösung(MeineBibliotek 1.0.0, Es gibt ein Problem in MeineBibliotek.)
  ///   ```
  ///
  /// - Auch Swift kann mit dem Zeichenkette `Swift` angegeben werden.
  ///
  ///   ```swift
  ///   // #notlösung(Swift 3.0.2, Es gibt ein Problem in Swift.)
  ///   ```
  ///
  /// - Beliebige Abhängigkeiten können durch Kommandozeilenbefehle angegeben, die eine Versionsnummer ausgeben. Arbeitsbereich sucht die erste Zeichenkette in der Ausgabe, die aus `0`–`9` und `.` besteht. Nur einfache Befehle sind unterstützt; Befehle können keine Anführungszeichen beinhalten.
  ///
  ///   ```swift
  ///   // #notlösung(git --version 2.10.1, Es gibt ein Problem in Git.) @ausnahme(zu: unicode)
  ///   ```
  public static var notlösungsErinnerungen: Korrekturregel {
    return .workaroundReminders
  }

  // ••••••• Functionality •••••••

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.compatibilityCharacters)
  /// Prohibits compatiblity characters.
  ///
  /// Compatibility characters were only encoded in Unicode for backwards compatibility, so that legacy encodings could map to it one‐to‐one. These characters were never intended for use when authoring native Unicode text.
  ///
  /// Such characters may be considered equal to their modern counterparts (by compatibility decomposition), or they may be considered distinct (using only canonical decomposition). Since the folding operation is irreversable, compatibility characters are unreliable—especially in machine contexts.
  case compatibilityCharacters
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.compatibilityCharacters)
  /// Verbietet verträglichkeitsschriftzeichen.
  ///
  /// Verträglichkeitsschriftzeichen wurden nur in Unicode wegen Abwärtsverträglichkeit kodiert, damit frühere Zeichenkodierungen eineindeutig umkodiert werden können. Diese Schriftzeichen waren nie für neue Texte gemeint, die auf Unicode geschrieben werden.
  ///
  /// Solche Zeichen können sowohl als gleich oder ungleich ihre moderne Versionen erkannt werden (Verträglichkeits‐ gegen Kanonische Zersetzung). Weil die Zusammenlegung unumkehrbar ist, sind diese Zeichen unzuverlässig – besonders in Quelltext.
  public static var verträglichkeitsschriftzeichen: Korrekturregel {
    return .compatibilityCharacters
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.marks)
  /// Catches broken syntax in source code headings.
  case marks
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.marks)
  /// Erwischt gebrochener Syntax in Quelltextüberschrifte.
  public static var überschrifte: Korrekturregel {
    return .marks
  }

  // ••••••• Documentation •••••••

  // @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(Proofreading.syntaxColouring)
  /// Requires Markdown code blocks to specify a language.
  case syntaxColouring
  // @localization(🇺🇸EN) @crossReference(Proofreading.syntaxColouring)
  /// Requires Markdown code blocks to specify a language.
  public static var syntaxColoring: ProofreadingRule {
    return syntaxColouring
  }
  // @localization(🇩🇪DE) @crossReference(Proofreading.syntaxColouring)
  /// Erfordert, dass Markdown‐Quellblöcke eine Sprache angeben.
  public static var syntaxhervorhebung: ProofreadingRule {
    return syntaxColouring
  }

  // ••••••• Text Style •••••••

  // @localization(🇩🇪DE)
  /// Verbietet Schreibmaschinenlösungen wenn bessere Unicode‐Zeichen verfügbar sind.
  ///
  /// Diese Regel gilt nicht, wo bessere Zeichen nicht erkannt wären:
  ///
  /// ```swift
  /// print("Hello, world!") // ← Erlaubt, weil Anführungszeichen hier nicht funktionieren.
  /// ```
  ///
  /// In manche Zusammenhänge, wie beim Ersellung einer Parallelbezeichnung, sind markierte ausnahmen trotzdem nötig:
  ///
  /// ```swift
  /// func ≠ (a: Any, b: Any) -> Bool {
  ///    return a != b // @ausnahme(zu: unicode)
  /// }
  /// ```
  ///
  /// Diese Regel fasst folgendes um:
  ///
  /// - Waagerechte Striche:
  ///   - Bindestriche: „E‐Mail“ (U+2010) anstatt „E&#x2D;Mail“ (U+002D).
  ///   - Minuszeichen: „3 − 1 = 2“ (U+2212) anstatt „3 &#x2D; 1 = 2“ (U+002D).
  ///   - Gedankenstriche: „–“ anstatt „&#x2D;&#x2D;“.
  ///   - Aufzählungszeichen: „•“ anstatt „&#x2D;“.
  /// - Hochgestellte Striche:
  ///   - Anführungszeichen: „... ‚...‘ ...“ (U+2018–U+201F) anstatt &#x22;... &#x27;...&#x27; ...&#x22; (U+0022, U+0027).
  ///   - Apostrophe: „die Grimm’schen Märchen“ (U+2019) anstatt „die Grimm&#x27;schen Märchen“ (U+0027).
  ///   - Gradzeichen: „20 °C“ anstatt „20 &#x27;C“.
  ///   - Prime symbols: 52° 31′ 00′′ N (U+2032) anstatt 52° 31&#x27; 00&#x22; N (U+0027, U+0022).
  /// - „⋅“ anstatt „*“.
  /// - „∶“ anstatt „/“.
  /// - „≠“ anstatt „&#x21;=“.
  /// - „≤“ anstatt „&#x3C;=“.
  /// - „≥“ anstatt „&#x3E;=“.
  /// - „¬“ anstatt „&#x21;“.
  /// - „∧“ anstatt „&#x26;&#x26;“.
  /// - „∨“ anstatt „&#x7C;|“.
  // @localization(🇬🇧EN)
  /// Prohibits typewriter workarounds when proper Unicode characters are available.
  ///
  /// This rule still permits most uses where the proper characters would not work:
  ///
  /// ```swift
  /// print("Hello, world!") // ← Allowed, because quotation marks cannot be used instead.
  /// ```
  ///
  /// In some contexts, such as when creating aliases, marked exemptions may be necessary:
  ///
  /// ```swift
  /// func ≠ (a: Any, b: Any) -> Bool {
  ///    return a != b // @exempt(from: unicode)
  /// }
  /// ```
  ///
  /// This rule covers:
  ///
  /// - Horizontal strokes:
  ///   - Hyphens: ‘twenty‐one’ (U+2010) instead of ‘twenty&#x2D;one’ (U+002D).
  ///   - Minus signs: ‘3 − 1 = 2’ (U+2212) instead of ‘3 &#x2D; 1 = 2’ (U+002D).
  ///   - Dashes: ‘—’ instead of ‘&#x2D;&#x2D;’.
  ///   - Bullets: ‘•’ instead of ‘&#x2D;’.
  ///   - Range symbols: ‘Dec. 3–5’ (U+2013) instead of ‘Dec. 3&#x2D;5’ (U+002D).
  /// - Raised marks:
  ///   - Quotation marks: ‘... “...” ...’ (U+2018–U+201F) instead of &#x27;... &#x22;...&#x22; ...&#x27;; (U+0022, U+0027).
  ///   - Apostrophes: ‘it’s’ (U+2019) instead of ‘it&#x27;s’ (U+0027).
  ///   - Degrees symbols: ‘20°C’ instead of ‘20&#x27;C’.
  ///   - Prime symbols: 5′6′′ (U+2032) instead of 5&#x27;6&#x22; (U+0027, U+0022).
  /// - ‘×‘ instead of ‘*’.
  /// - ‘÷‘ instead of ‘/‘.
  /// - ‘≠‘ instead of ‘&#x21;=‘.
  /// - ‘≤‘ instead of ‘&#x3C;=‘.
  /// - ‘≥‘ instead of ‘&#x3E;=‘.
  /// - ‘¬‘ instead of ‘&#x21;‘.
  /// - ‘∧‘ instead of ‘&#x26;&#x26;‘.
  /// - ‘∨‘ instead of ‘&#x7C;|‘.
  // @localization(🇺🇸EN) @localization(🇨🇦EN)
  /// Prohibits typewriter workarounds when proper Unicode characters are available.
  ///
  /// This rule still permits most uses where the proper characters would not work:
  ///
  /// ```swift
  /// print("Hello, world!") // ← Allowed, because quotation marks cannot be used instead.
  /// ```
  ///
  /// In some contexts, such as when creating aliases, marked exemptions may be necessary:
  ///
  /// ```swift
  /// func ≠ (a: Any, b: Any) -> Bool {
  ///    return a != b // @exempt(from: unicode)
  /// }
  /// ```
  ///
  /// This rule covers:
  ///
  /// - Horizontal strokes:
  ///   - Hyphens: “twenty‐one” (U+2010) instead of “twenty&#x2D;one” (U+002D).
  ///   - Minus signs: “3 − 1 = 2” (U+2212) instead of “3 &#x2D; 1 = 2” (U+002D).
  ///   - Dashes: “—” instead of “&#x2D;&#x2D;”.
  ///   - Bullets: “•” instead of “&#x2D;”.
  ///   - Range symbols: “Dec. 3–5” (U+2013) instead of “Dec. 3&#x2D;5” (U+002D).
  /// - Raised marks:
  ///   - Quotation marks: “... ‘...’ ...” (U+2018–U+201F) instead of &#x22;... &#x27;...&#x27; ...&#x22; (U+0022, U+0027).
  ///   - Apostrophes: “it’s” (U+2019) instead of “it&#x27;s” (U+0027).
  ///   - Degrees symbols: “20°C” instead of “20&#x27;C”.
  ///   - Prime symbols: 5′6′′ (U+2032) instead of 5&#x27;6&#x22; (U+0027, U+0022).
  /// - “×” instead of “*”.
  /// - “÷” instead of “/”.
  /// - “≠” instead of “&#x21;=”.
  /// - “≤” instead of “&#x3C;=”.
  /// - “≥” instead of “&#x3E;=”.
  /// - “¬” instead of “&#x21;”.
  /// - “∧” instead of “&#x26;&#x26;”.
  /// - “∨” instead of “&#x7C;|”.
  case unicode

  // ••••••• Source Code Style •••••••

  // Tokens

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProofreadingRule.calloutCasing)
  /// Requires documentation callouts to be capitalized.
  case calloutCasing
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.calloutCasing)
  /// Erzwingt die Großschreibung von Dokumentationshervorhebungen.
  public static var hervorhebungsGroßschreibung: Korrekturregel {
    return .calloutCasing
  }

  // Complex nodes

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.closureSignaturePosition)
  /// Requires closure signatures to be on the same line as the closure’s opening brace.
  case closureSignaturePosition
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.closureSignaturePosition)
  /// Erzwingt die Platzierung von Abschlusssignaturen auf der selben Zeile wie den öffnenden geschweiften Klammer.
  public static var abschlusssignaturplatzierung: Korrekturregel {
    return .closureSignaturePosition
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ProofreadingRule.parameterGrouping)
  /// Requires documented parameters to be grouped.
  case parameterGrouping
  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.parameterGrouping)
  /// Erzwingt die Zusammenstellung dokumentierter Übergabewerten.
  public static var übergabewertenzusammenstellung: Korrekturregel {
    return .parameterGrouping
  }

  // MARK: - Properties

  // @localization(🇩🇪DE) @crossReference(ProofreadingRule.category)
  /// Die Klasse zu der die Regel gehört.
  public var klasse: Klasse {
    return category
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProofreadingRule.category)
  /// The category the rule belongs to.
  public var category: Category {
    switch self {
    case .deprecatedTestManifests:
      return .deprecation

    case .manualWarnings,
      .missingImplementation,
      .workaroundReminders:
      return .intentional

    case .compatibilityCharacters,
      .marks:
      return .functionality

    case .syntaxColouring:
      return .documentation

    case .unicode:
      return .textStyle

    case .calloutCasing, .closureSignaturePosition,
      .parameterGrouping:
      return .sourceCodeStyle
    }
  }
}
