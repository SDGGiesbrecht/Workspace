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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
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
  #endif

  private static func declarationPattern(
    _ name: UserFacing<StrictString, InterfaceLocalization>
  ) -> DirectivePattern {
    return pattern(named: name, startingWith: "@")
  }
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
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
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let exampleDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(exampleDeclarationName)
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let exampleDirective: DirectivePatternWithArguments =
      directivePatternWithArguments(
        exampleDirectiveName
      )
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let documentationDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(documentationDeclarationName)
  #endif

  private static let documentationDirectiveName: UserFacing<StrictString, InterfaceLocalization> =
    UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "documentation"
      case .deutschDeutschland:
        return "dokumentation"
      }
    })
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let documentationDirective: DirectivePatternWithArguments =
      directivePatternWithArguments(documentationDirectiveName)
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let localizationDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(localizationDeclarationName)
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let crossReferenceDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(crossReferenceDeclarationName)
  #endif

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
  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public static let notLocalizedDeclaration: DirectivePatternWithArguments =
      declarationPatternWithArguments(notLocalizedDeclarationName)
  #endif
}
