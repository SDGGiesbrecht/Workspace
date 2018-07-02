/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A proofreading rule.
public enum ProofreadingRule : String, Codable {

    // MARK: - Cases

    // ••••••• Deprecation •••••••

    /// Catches deprecated example directives.
    case deprecatedExampleDirectives

    /// Catches deprecated Git management notices.
    case deprecatedGitManagement

    /// Catches deprecated configurations.
    case deprecatedConfiguration

    /// Prohibits deprecated compiler conditions for Linux documentation.
    case deprecatedLinuxDocumentation

    // ••••••• Intentional •••••••

    /// Catches generic manual warnings.
    ///
    /// Generic warnings are for times when you want to prevent the project from passing validation until you come back to fix something, but you still need the project to build while you are working on it.
    ///
    /// The text, `[_Warning: Some description here._]`, will always trigger a warning during proofreading and cause validation to fail. It will not interrupt Swift or Xcode builds.
    case manualWarnings

    /// Catches unimplemented code paths marked with SDGCornerstone functions.
    case missingImplementation

    /// Catches outdated workaround reminders.
    ///
    /// Workaround reminders are for times when you need to implement a temporary workaround because of a problem in a dependency, and you would like to remind yourself to go back and remove the workaround once the dependency is fixed.
    ///
    /// The text, `[_Workaround: Some description here._]` will trigger a warning during proofreading, but will still pass validation.
    ///
    /// ## Version Detection
    ///
    /// Optionally, a workaround reminder can specify the dependency and version were the problem exists. Then Workspace will ignore it until the problematic version is out of date.
    ///
    /// `[_Workaround: Some description here. (SomeDependency 0.0.0)_]`
    ///
    /// The dependency can be specified three different ways.
    ///
    /// - Package dependencies can be specified using the exact name of the package.
    ///
    ///   ```swift
    ///   // [_Workaround: There is a problem in MyLibrary. (MyLibrary 1.0.0)_]
    ///   ```
    ///
    /// - Swift itself can be specified with the string `Swift`.
    ///
    ///   ```swift
    ///   // [_Workaround: There is a problem with Swift. (Swift 3.0.2)_]
    ///   ```
    ///
    /// - Arbitrary dependencies can be specified by shell commands which output a version number. Workspace will look for the first group of the characters `0`–`9` and `.` in the command output. Only simple commands are supported; commands cannot contain quotation marks.
    ///
    ///   ```swift
    ///   // [_Workaround: There is a problem with Git. (git --version 2.10.1)_]
    ///   ```
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

    /// Catches broken syntax in source code headings.
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
        .deprecatedExampleDirectives,
        .deprecatedGitManagement,
        .deprecatedConfiguration,
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

    /// The category the rule belongs to.
    public var category: Category {
        switch self {
        case .deprecatedExampleDirectives, .deprecatedGitManagement, .deprecatedConfiguration, .deprecatedLinuxDocumentation:
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
