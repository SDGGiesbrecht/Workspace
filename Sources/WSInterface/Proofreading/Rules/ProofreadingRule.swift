/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

extension ProofreadingRule {

    var parser: Rule.Type {
        switch self {
        case .deprecatedConfiguration:
            return DeprecatedConfiguration.self
        case .deprecatedLinuxDocumentation:
            return DeprecatedLinuxDocumentation.self
        case .manualWarnings:
            return ManualWarnings.self
        case .missingImplementation:
            return MissingImplementation.self
        case .workaroundReminders:
            return WorkaroundReminders.self
        case .compatibilityCharacters:
            return CompatibilityCharacters.self
        case .autoindentResilience:
            return AutoindentResilience.self
        case .marks:
            return Marks.self
        case .documentationOfExtensionConstraints:
            return DocumentationOfExtensionConstraints.self
        case .documentationOfCompilationConditions:
            return DocumentationOfCompilationConditions.self
        case .syntaxColouring:
            return SyntaxColouring.self
        case .unicode:
            return UnicodeRule.self
        case .colonSpacing:
            return ColonSpacing.self
        case .calloutCasing:
            return CalloutCasing.self
        case .parameterGrouping:
            return ParameterGrouping.self
        }
    }
}
