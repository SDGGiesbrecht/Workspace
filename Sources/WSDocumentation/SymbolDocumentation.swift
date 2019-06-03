/*
 SymbolDocumentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

extension Array where Element == SymbolDocumentation {

    public func resolved(
        localizations: [LocalizationIdentifier]
        ) -> (documentation: [LocalizationIdentifier: DocumentationSyntax], parentLocalization: StrictString?) {
            var result: [LocalizationIdentifier: DocumentationSyntax] = [:]
            var parent: StrictString?

            for documentation in self {
                for comment in documentation.developerComments {
                    let content = StrictString(comment.content.text)
                    for match in content.matches(
                        for: AlternativePatterns(PackageRepository.localizationDeclarationPatterns)) {

                            guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                                let closingParenthesis = match.contents.lastMatch(for: ")".scalars) else {
                                    unreachable()
                            }

                            var identifier = StrictString(content[openingParenthesis.range.upperBound ..< closingParenthesis.range.lowerBound])
                            identifier.trimMarginalWhitespace()

                            let localization = LocalizationIdentifier(String(identifier))
                            result[localization] = documentation.documentationComment
                    }
                    for match in content.matches(
                        for: AlternativePatterns(PackageRepository.localizedDeclarationPatterns)) {

                            guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                                let closingParenthesis = match.contents.lastMatch(for: ")".scalars) else {
                                    unreachable()
                            }

                            var identifier = StrictString(content[openingParenthesis.range.upperBound ..< closingParenthesis.range.lowerBound])
                            identifier.trimMarginalWhitespace()

                            parent = identifier
                    }
                }
            }

            if localizations.count == 1,
                let onlyLocalization = localizations.first,
                result.isEmpty /* No localization tags. */ {
                result[onlyLocalization] = last?.documentationComment
            }

            return (result, parent)
    }
}
