/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

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
public enum ProofreadingRule : String, CaseIterable, Codable {

    // MARK: - Cases

    // ••••••• Deprecation •••••••

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Catches deprecated condition documentation.
    case deprecatedConditionDocumentation

    // ••••••• Intentional •••••••

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Catches generic manual warnings.
    ///
    /// Generic warnings are for times when you want to prevent the project from passing validation until you come back to fix something, but you still need the project to build while you are working on it.
    ///
    /// The text, `#warning(Some description here.)`, will always trigger a warning during proofreading and cause validation to fail. It will not interrupt Swift or Xcode builds.
    case manualWarnings

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Catches unimplemented code paths marked with SDGCornerstone functions.
    case missingImplementation

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
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

    // ••••••• Functionality •••••••

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Prohibits compatiblity characters.
    ///
    /// Compatibility characters were only encoded in Unicode for backwards compatibility, so that legacy encodings could map to it one‐to‐one. These characters were never intended for use when authoring native Unicode text.
    ///
    /// Such characters may be considered equal to their modern counterparts (by compatibility decomposition), or they may be considered distinct (using only canonical decomposition). Since the folding operation is irreversable, compatibility characters are unreliable—especially in machine contexts.
    case compatibilityCharacters

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Prohibits documentation comments vulnerable to auto‐indent.
    case autoindentResilience

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Catches broken syntax in source code headings.
    case marks

    // ••••••• Documentation •••••••

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Requires Markdown code blocks to specify a language.
    case syntaxColouring

    // ••••••• Text Style •••••••

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
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

    // Punctuation

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Enforces consistent spacing around braces.
    case braceSpacing

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Enforces consistent spacing around colons.
    case colonSpacing

    // Tokens

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Requires documentation callouts to be capitalized.
    case calloutCasing

    // Complex nodes

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Requires closure signatures to be on the same line as the closure’s opening brace.
    case closureSignaturePosition

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Requires documented parameters to be grouped.
    case parameterGrouping

    // MARK: - Properties

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The category the rule belongs to.
    public var category: Category {
        switch self {
        case .deprecatedConditionDocumentation:
            return .deprecation

        case .manualWarnings,
             .missingImplementation,
             .workaroundReminders:
            return .intentional

        case .compatibilityCharacters,
             .autoindentResilience,
             .marks:
            return .functionality

        case .syntaxColouring:
            return .documentation

        case .unicode:
            return .textStyle

        case .braceSpacing, .colonSpacing, .calloutCasing, .closureSignaturePosition, .parameterGrouping:
            return .sourceCodeStyle
        }
    }
}
