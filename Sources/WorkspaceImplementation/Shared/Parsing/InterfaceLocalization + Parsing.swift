/*
 InterfaceLocalization + Parsing.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import WorkspaceLocalizations

  extension InterfaceLocalization {

    internal typealias DirectivePattern = ConcatenatedPatterns<
      [Unicode.Scalar],
      NaryAlternativePatterns<StrictString>
    >
    private static func pattern(
      named name: UserFacing<StrictString, InterfaceLocalization>,
      startingWith scalar: Unicode.Scalar
    ) -> DirectivePattern {
      return [scalar]
        + NaryAlternativePatterns(Array(Set(allCases.map({ name.resolved(for: $0) }))))
    }
    internal typealias DirectivePatternWithArguments = ConcatenatedPatterns<
      ConcatenatedPatterns<
        ConcatenatedPatterns<DirectivePattern, String.ScalarView>,
        RepetitionPattern<ConditionalPattern<Unicode.Scalar>>
      >,
      String.ScalarView
    >
    private static func patternWithArguments(
      named name: UserFacing<StrictString, InterfaceLocalization>,
      startingWith scalar: Unicode.Scalar
    ) -> DirectivePatternWithArguments {
      let simple = pattern(named: name, startingWith: scalar)
      let parenthesis = simple + "(".scalars
      let arguments =
        parenthesis
        + RepetitionPattern(
          ConditionalPattern({ $0 ≠ ")" ∧ $0 ∉ CharacterSet.newlines }),
          consumption: .greedy
        )
      return arguments + ")".scalars
    }

    private static func declarationPattern(
      _ name: UserFacing<StrictString, InterfaceLocalization>
    ) -> DirectivePattern {
      return pattern(named: name, startingWith: "@")
    }
    private static func declarationPatternWithArguments(
      _ name: UserFacing<StrictString, InterfaceLocalization>
    ) -> DirectivePatternWithArguments {
      return patternWithArguments(named: name, startingWith: "@")
    }

    private static func directivePatternWithArguments(
      _ name: UserFacing<StrictString, InterfaceLocalization>
    ) -> DirectivePatternWithArguments {
      return patternWithArguments(named: name, startingWith: "#")
    }

    // MARK: - Examples

    private static let exampleDeclarationName: UserFacing<StrictString, InterfaceLocalization> =
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "example"
        case .deutschDeutschland:
          return "beispiel"
        }
      })
    internal static let exampleDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(exampleDeclarationName)

    private static let endExampleDecarationName: UserFacing<StrictString, InterfaceLocalization> =
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "endExample"
        case .deutschDeutschland:
          return "beispielBeenden"
        }
      })
    internal static let endExampleDeclaration: DirectivePattern = declarationPattern(
      endExampleDecarationName
    )

    private static let exampleDirectiveName: UserFacing<StrictString, InterfaceLocalization> =
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "example"
        case .deutschDeutschland:
          return "beispiel"
        }
      })
    internal static let exampleDirective: DirectivePatternWithArguments =
      directivePatternWithArguments(
        exampleDirectiveName
      )

    // MARK: - Documentation Inheritance

    private static let documentationDeclarationName:
      UserFacing<StrictString, InterfaceLocalization> =
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "documentation"
          case .deutschDeutschland:
            return "dokumentation"
          }
        })
    internal static let documentationDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(documentationDeclarationName)

    private static let documentationDirectiveName: UserFacing<StrictString, InterfaceLocalization> =
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "documentation"
        case .deutschDeutschland:
          return "dokumentation"
        }
      })
    internal static let documentationDirective: DirectivePatternWithArguments =
      directivePatternWithArguments(documentationDirectiveName)

    // MARK: - Documentation Generation

    private static let localizationDeclarationName:
      UserFacing<StrictString, InterfaceLocalization> =
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return "localisation"
          case .englishUnitedStates, .englishCanada:
            return "localization"
          case .deutschDeutschland:
            return "lokalisation"
          }
        })
    internal static let localizationDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(localizationDeclarationName)

    private static let crossReferenceDeclarationName:
      UserFacing<StrictString, InterfaceLocalization> = UserFacing<
        StrictString, InterfaceLocalization
      >({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "crossReference"
        case .deutschDeutschland:
          return "querverweis"
        }
      })
    internal static let crossReferenceDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(crossReferenceDeclarationName)

    private static let notLocalizedDeclarationName:
      UserFacing<StrictString, InterfaceLocalization> =
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return "notLocalised"
          case .englishUnitedStates, .englishCanada:
            return "notLocalized"
          case .deutschDeutschland:
            return "nichtLokalisiert"
          }
        })
    internal static let notLocalizedDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(notLocalizedDeclarationName)
  }
#endif
