/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public enum ProofreadingRule : String, Codable {

    // MARK: - Cases

    // ••••••• Deprecation •••••••

    /// Prohibits deprecated compiler conditions for Linux documentation.
    case deprecatedLinuxDocumentation

    // ••••••• Intentional •••••••

    /// Catches generic manual warnings.
    case manualWarnings

    /// Catches unimplemented code paths marked with SDGCornerstone functions.
    case missingImplementation

    /// Catches outdated workaround reminders.
    case workaroundReminders

    // ••••••• Functionality •••••••

    /// Prohibits compatiblity characters.
    ///
    /// Compatibility characters were only encoded in Unicode for backwards compatibility, so that legacy encodings could map to it one‐to‐one. These characters were never intended for use when authoring native Unicode text.
    ///
    /// Such characters may be considered equal to their modern counterparts (by compatibility decomposition), or they may be considered distinct (using only canonical decomposition). Since the folding operation is irreversable, compatibility characters are unreliable—especially in machine contexts.
    case compatibilityCharacters

    /// Prohibits documentation comments vulnerable to auto‐indent.
    case autoindentResilience

    /// Catches broken syntax in source code headings (MARK).
    case marks

    // ••••••• Documentation •••••••

    /// Requires extension constraints to be documented.
    case documentationOfExtensionConstraints

    /// Requires compilation conditions to be documented.
    case documentationOfCompilationConditions

    /// Requires Markdown code blocks to specify a language.
    case syntaxColouring

    // ••••••• Text Style •••••••

    /// Prohibits typewriter workarounds when proper Unicode characters are available.
    case unicode

    // ••••••• Source Code Style •••••••

    /// Enforces consistent spacing around colons.
    case colonSpacing

    /// Requires documentation callouts to be capitalized.
    case calloutCasing

    /// Requires documented parameters to be grouped.
    case parameterGrouping

    // [_Inherit Documentation: SDGCornerstone.IterableEnumeration.cases_]
    /// An array containing every case of the enumeration.
    public static let cases: [ProofreadingRule] = [
        .deprecatedLinuxDocumentation,

        .manualWarnings,
        .missingImplementation,
        .workaroundReminders,

        .compatibilityCharacters,
        .autoindentResilience,
        .marks,

        .documentationOfExtensionConstraints,
        .documentationOfCompilationConditions,
        .syntaxColouring,

        .unicode,

        .colonSpacing,
        .calloutCasing,
        .parameterGrouping
    ]

    // MARK: - Properties

    public var category: Category {
        switch self {
        case .deprecatedLinuxDocumentation:
            return .deprecation

        case .manualWarnings,
             .missingImplementation,
             .workaroundReminders:
            return .intentional

        case .compatibilityCharacters,
             .autoindentResilience,
             .marks:
            return .functionality

        case .documentationOfExtensionConstraints,
             .documentationOfCompilationConditions,
             .syntaxColouring:
            return .documentation

        case .unicode:
            return .textStyle

        case .colonSpacing, .calloutCasing, .parameterGrouping:
            return .sourceCodeStyle
        }
    }
}
