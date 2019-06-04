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

    private static func declarationPatterns(_ name: UserFacing<StrictString, InterfaceLocalization>) -> [CompositePattern<Unicode.Scalar>] {
        return InterfaceLocalization.allCases.map { localization in
            return CompositePattern([
                LiteralPattern("@".scalars),
                LiteralPattern(name.resolved(for: localization)),
                LiteralPattern("(".scalars),
                RepetitionPattern(
                    ConditionalPattern({ $0 ≠ ")" ∧ $0 ∉ CharacterSet.newlines }),
                    consumption: .greedy),
                LiteralPattern(")".scalars)
                ])
        }
    }

    private static let localizationDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "localization"
        }
    })
    public static let localizationDeclaration: [CompositePattern<Unicode.Scalar>]
        = declarationPatterns(localizationDeclarationName)

    private static let crossReferenceDeclarationName: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "crossReference"
        }
    })
    public static let crossReferenceDeclaration: [CompositePattern<Unicode.Scalar>]
        = declarationPatterns(crossReferenceDeclarationName)
}
