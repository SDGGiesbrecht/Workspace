
import GeneralImports

import Project

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
