/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

extension ProofreadingRule : Comparable {

    internal var parser: Rule {
        switch self {
        case .deprecatedConditionDocumentation:
            return .text(DeprecatedConditionDocumentation.self)
        case .deprecatedWarnings:
            return .text(DeprecatedWarnings.self)
        case .deprecatedTestExemptions:
            return .text(DeprecatedTestExemptions.self)
        case .deprecatedInheritanceDirectives:
            return .text(DeprecatedInheritanceDirectives.self)
        case .deprecatedExampleDirectives:
            return .text(DeprecatedExampleDirectives.self)
        case .deprecatedGitManagement:
            return .text(DeprecatedGitManagement.self)
        case .deprecatedConfiguration:
            return .text(DeprecatedConfiguration.self)
        case .manualWarnings:
            return .text(ManualWarnings.self)
        case .missingImplementation:
            return .text(MissingImplementation.self)
        case .workaroundReminders:
            return .text(WorkaroundReminders.self)
        case .compatibilityCharacters:
            return .text(CompatibilityCharacters.self)
        case .autoindentResilience:
            return .syntax(AutoindentResilience.self)
        case .marks:
            return .text(Marks.self)
        case .syntaxColouring:
            return .syntax(SyntaxColouring.self)
        case .unicode:
            return .text(UnicodeRule.self)
        case .colonSpacing:
            return .syntax(ColonSpacing.self)
        case .calloutCasing:
            return .syntax(CalloutCasing.self)
        case .parameterGrouping:
            return .text(ParameterGrouping.self)
        }
    }

    // MARK: - Comparable

    public static func < (lhs: ProofreadingRule, rhs: ProofreadingRule) -> Bool {
        return lhs.rawValue.scalars.lexicographicallyPrecedes(rhs.rawValue.scalars)
    }
}
