/*
 InterfaceLocalization.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports
import WSLocalizations

extension InterfaceLocalization {

    private static func patterns(startingWith scalar: Unicode.Scalar, named name: UserFacing<StrictString, InterfaceLocalization>, hasArgument: Bool) -> CompositePattern<Unicode.Scalar> {
        var components: [SDGCollections.Pattern<Unicode.Scalar>] = [
            LiteralPattern([scalar]),
            AlternativePatterns(allCases.map({ LiteralPattern(name.resolved(for: $0)) })),
        ]
        if hasArgument {
            components.append(contentsOf: [
                LiteralPattern("(".scalars),
                RepetitionPattern(
                    ConditionalPattern({ $0 ≠ ")" ∧ $0 ∉ CharacterSet.newlines }),
                    consumption: .greedy),
                LiteralPattern(")".scalars)
                ])
        }
        return CompositePattern(components)
    }

    private static func declarationPatterns(_ name: UserFacing<StrictString, InterfaceLocalization>, hasArgument: Bool) -> CompositePattern<Unicode.Scalar> {
        return patterns(startingWith: "@", named: name, hasArgument: hasArgument)
    }

    private static func directivePatterns(_ name: UserFacing<StrictString, InterfaceLocalization>) -> CompositePattern<Unicode.Scalar> {
        return patterns(startingWith: "#", named: name, hasArgument: true)
    }

    // MARK: - Examples

    private static let exampleDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "example"
        case .deutschDeutschland:
            return "beispiel"
        }
    })
    public static let exampleDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(exampleDeclarationName, hasArgument: true)

    private static let endExampleDecarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "endExample"
        case .deutschDeutschland:
            return "beispielBeenden"
        }
    })
    public static let endExampleDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(endExampleDecarationName, hasArgument: false)

    private static let exampleDirectiveName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "example"
        case .deutschDeutschland:
            return "beispiel"
        }
    })
    public static let exampleDirective: CompositePattern<Unicode.Scalar>
        = directivePatterns(exampleDirectiveName)

    // MARK: - Documentation Inheritance

    private static let documentationDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "documentation"
        case .deutschDeutschland:
            return "dokumentation"
        }
    })
    public static let documentationDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(documentationDeclarationName, hasArgument: true)

    private static let documentationDirectiveName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "documentation"
        case .deutschDeutschland:
            return "dokumentation"
        }
    })
    public static let documentationDirective: CompositePattern<Unicode.Scalar>
        = directivePatterns(documentationDirectiveName)

    // MARK: - Documentation Generation

    private static let localizationDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom:
            return "localisation"
        case .englishUnitedStates, .englishCanada:
            return "localization"
        case .deutschDeutschland:
            return "lokalisation"
        }
    })
    public static let localizationDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(localizationDeclarationName, hasArgument: true)

    private static let crossReferenceDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "crossReference"
        case .deutschDeutschland:
            return "querverweis"
        }
    })
    public static let crossReferenceDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(crossReferenceDeclarationName, hasArgument: true)

    private static let notLocalizedDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom:
            return "notLocalised"
        case .englishUnitedStates, .englishCanada:
            return "notLocalized"
        case .deutschDeutschland:
            return "nichtLokalisiert"
        }
    })
    public static let notLocalizedDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(notLocalizedDeclarationName, hasArgument: true)
}
