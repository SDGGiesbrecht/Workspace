/*
 InterfaceLocalization.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports
import WSLocalizations

extension InterfaceLocalization {

  public typealias DirectivePattern = ConcatenatedPatterns<
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
  public typealias DirectivePatternWithArguments = ConcatenatedPatterns<
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
  public static let exampleDeclaration: DirectivePatternWithArguments =
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
  public static let endExampleDeclaration: DirectivePattern = declarationPattern(
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
  public static let exampleDirective: DirectivePatternWithArguments = directivePatternWithArguments(
    exampleDirectiveName
  )

  // MARK: - Documentation Inheritance

  private static let documentationDeclarationName: UserFacing<StrictString, InterfaceLocalization> =
    UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "documentation"
      case .deutschDeutschland:
        return "dokumentation"
      }
    })
  public static let documentationDeclaration: DirectivePatternWithArguments =
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
  public static let documentationDirective: DirectivePatternWithArguments =
    directivePatternWithArguments(documentationDirectiveName)

  // MARK: - Documentation Generation

  private static let localizationDeclarationName: UserFacing<StrictString, InterfaceLocalization> =
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
  public static let localizationDeclaration: DirectivePatternWithArguments =
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
  public static let crossReferenceDeclaration: DirectivePatternWithArguments =
    declarationPatternWithArguments(crossReferenceDeclarationName)

  private static let notLocalizedDeclarationName: UserFacing<StrictString, InterfaceLocalization> =
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
  public static let notLocalizedDeclaration: DirectivePatternWithArguments =
    declarationPatternWithArguments(notLocalizedDeclarationName)
}
