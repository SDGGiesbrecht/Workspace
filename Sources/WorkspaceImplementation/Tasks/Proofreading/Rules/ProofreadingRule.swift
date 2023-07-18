/*
 ProofreadingRule.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import WorkspaceConfiguration

  extension ProofreadingRule: Comparable {

    internal var parser: Rule {
      switch self {
      case .deprecatedTestManifests:  // @exempt(from: tests)
        // Unreachable. Handled exceptionally elsewhere.
        return .text(DeprecatedTestManifests.self)
      case .deprecatedResourceDirectory:
        return .text(DeprecatedResourceDirectory.self)
      case .manualWarnings:
        return .text(ManualWarnings.self)
      case .missingImplementation:
        return .text(MissingImplementation.self)
      case .workaroundReminders:
        return .text(WorkaroundReminders.self)
      case .accessControl:
        return .syntax(AccessControl.self)
      case .classFinality:
        return .syntax(ClassFinality.self)
      case .compatibilityCharacters:
        return .text(CompatibilityCharacters.self)
      case .explicitTypes:
        return .syntax(ExplicitTypes.self)
      case .headingLevels:
        return .syntax(HeadingLevels.self)
      case .marks:
        return .text(Marks.self)
      case .syntaxColouring:
        return .syntax(SyntaxColouring.self)
      case .unicode:
        return .syntax(UnicodeRule.self)
      case .bullets:
        return .syntax(Bullets.self)
      case .asterisms:
        return .syntax(Asterisms.self)
      case .calloutCasing:
        return .syntax(CalloutCasing.self)
      case .closureSignaturePosition:
        return .syntax(ClosureSignaturePosition.self)
      case .listSeparation:
        return .syntax(ListSeparation.self)
      case .markdownHeadings:
        return .syntax(MarkdownHeadings.self)
      case .parameterGrouping:
        return .syntax(ParameterGrouping.self)
      }
    }

    // MARK: - Comparable

    public static func < (lhs: ProofreadingRule, rhs: ProofreadingRule) -> Bool {
      return lhs.rawValue.scalars.lexicographicallyPrecedes(rhs.rawValue.scalars)
    }
  }
#endif
