/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal class SymbolPage : Page {

    // MARK: - Initialization

    internal init(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement], symbol: APIElement, packageIdentifiers: Set<String>, status: DocumentationStatus) {

        var content: [StrictString] = []
        content.append(SymbolPage.generateDescriptionSection(symbol: symbol, navigationPath: navigationPath, status: status))
        content.append(SymbolPage.generateDeclarationSection(localization: localization, symbol: symbol, packageIdentifiers: packageIdentifiers))
        content.append(SymbolPage.generateDiscussionSection(localization: localization, symbol: symbol))

        super.init(localization: localization,
                   pathToSiteRoot: pathToSiteRoot,
                   navigationPath: SymbolPage.generateNavigationPath(localization: localization, pathToSiteRoot: pathToSiteRoot, navigationPath: navigationPath),
                   symbolType: SymbolPage.generateSymbolType(localization: localization, symbol: symbol),
                   title: StrictString(symbol.name),
                   content: content.joinedAsLines())
    }

    // MARK: - Generation

    private static func generateNavigationPath(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement]) -> StrictString {
        var accumulatedNavigationPath: StrictString = pathToSiteRoot.appending(contentsOf: localization.code.scalars)
        let navigationPathLinks = navigationPath.indices.map { (level: Int) -> StrictString in
            let element = navigationPath[level]
            accumulatedNavigationPath.append(contentsOf: "/" + element.fileName)
            if ¬navigationPath.isEmpty,
                level ≠ navigationPath.index(before: navigationPath.endIndex) {
                return HTMLElement("a", attributes: ["href": accumulatedNavigationPath.appending(contentsOf: ".html".scalars)], contents: StrictString(element.name), inline: true).source
            } else {
                return HTMLElement("span", attributes: [:], contents: StrictString(element.name), inline: true).source
            }
        }
        return navigationPathLinks.joined(separator: "\n")
    }

    private static func generateSymbolType(localization: LocalizationIdentifier, symbol: APIElement) -> StrictString {
        if symbol is PackageAPI {
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Package"
                }
            } else {
                return "Package" // From “let ... = Package(...)”
            }
        } else {
            if BuildConfiguration.current == .debug {
                print("Unrecognized symbol type: \(type(of: symbol))")
            }
            return ""
        }
    }

    private static func generateDescriptionSection(symbol: APIElement, navigationPath: [APIElement], status: DocumentationStatus) -> StrictString {
        if let documentation = symbol.documentation,
            let description = documentation.descriptionSection {
                return HTMLElement("div", attributes: ["class": "description"], contents: StrictString(description.renderedHTML()), inline: false).source
        }
        status.reportMissingDescription(symbol: symbol, navigationPath: navigationPath)
        return ""
    }

    private static func generateDeclarationSection(localization: LocalizationIdentifier, symbol: APIElement, packageIdentifiers: Set<String>) -> StrictString {
        guard let declaration = symbol.declaration else {
            return ""
        }

        let declarationHeading: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            declarationHeading = "Declaration"
        }

        let sectionContents: [StrictString] = [
            HTMLElement("h2", contents: declarationHeading, inline: true).source,
            StrictString(declaration.syntaxHighlightedHTML(inline: false, internalIdentifiers: packageIdentifiers))
        ]

        return HTMLElement("section", attributes: ["class": "declaration"], contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func generateDiscussionSection(localization: LocalizationIdentifier, symbol: APIElement) -> StrictString {
        guard let discussion = symbol.documentation?.discussionEntries,
            ¬discussion.isEmpty else {
                return ""
        }

        let discussionHeading: StrictString
        if symbol.children.isEmpty {
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Overview"
            }
        } else {
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Discussion"
            }
        }

        let sectionContents: [StrictString] = [
            HTMLElement("h2", contents: discussionHeading, inline: true).source
        ]

        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }
}
