/*
 InterfaceLocalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

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
        case .englishCanada:
            return "example"
        }
    })
    public static let exampleDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(exampleDeclarationName, hasArgument: true)

    private static let endExampleDecarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "endExample"
        }
    })
    public static let endExampleDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(endExampleDecarationName, hasArgument: false)

    private static let exampleDirectiveName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "example"
        }
    })
    public static let exampleDirective: CompositePattern<Unicode.Scalar>
        = directivePatterns(exampleDirectiveName)

    // MARK: - Documentation Inheritance

    private static let documentationDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "documentation"
        }
    })
    public static let documentationDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(documentationDeclarationName, hasArgument: true)

    private static let documentationDirectiveName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "documentation"
        }
    })
    public static let documentationDirective: CompositePattern<Unicode.Scalar>
        = directivePatterns(documentationDirectiveName)

    // MARK: - Documentation Generation

    private static let localizationDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "localization"
        }
    })
    public static let localizationDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(localizationDeclarationName, hasArgument: true)

    private static let crossReferenceDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "crossReference"
        }
    })
    public static let crossReferenceDeclaration: CompositePattern<Unicode.Scalar>
        = declarationPatterns(crossReferenceDeclarationName, hasArgument: true)
}
