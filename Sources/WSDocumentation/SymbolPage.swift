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
        content.append(SymbolPage.generateDescriptionSection(symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, status: status))
        content.append(SymbolPage.generateDeclarationSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, status: status))
        content.append(SymbolPage.generateDiscussionSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, status: status))

        content.append(SymbolPage.generateLibrariesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers))
        content.append(SymbolPage.generateModulesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers))

        super.init(localization: localization,
                   pathToSiteRoot: pathToSiteRoot,
                   navigationPath: SymbolPage.generateNavigationPath(localization: localization, pathToSiteRoot: pathToSiteRoot, navigationPath: navigationPath),
                   symbolType: symbol.symbolType(localization: localization),
                   title: StrictString(symbol.name),
                   content: content.joinedAsLines())
    }

    // MARK: - Generation

    private static func generateNavigationPath(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement]) -> StrictString {
        let navigationPathLinks = navigationPath.indices.map { (level: Int) -> StrictString in
            let element = navigationPath[level]
            let url = pathToSiteRoot.appending(contentsOf: element.relativePagePath[localization]!)
            if ¬navigationPath.isEmpty,
                level ≠ navigationPath.index(before: navigationPath.endIndex) {
                return HTMLElement("a", attributes: ["href": url], contents: StrictString(element.name), inline: true).source
            } else {
                return HTMLElement("span", attributes: [:], contents: StrictString(element.name), inline: true).source
            }
        }
        return navigationPathLinks.joined(separator: "\n")
    }

    private static func generateDescriptionSection(symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, status: DocumentationStatus) -> StrictString {
        if let documentation = symbol.documentation,
            let description = documentation.descriptionSection {
                return HTMLElement("div", attributes: ["class": "description"], contents: StrictString(description.renderedHTML(internalIdentifiers: packageIdentifiers)), inline: false).source
        }
        status.reportMissingDescription(symbol: symbol, navigationPath: navigationPath)
        return ""
    }

    private static func generateDeclarationSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, status: DocumentationStatus) -> StrictString {
        guard let declaration = symbol.declaration else {
            return ""
        }

        if let variable = symbol as? VariableAPI,
            variable.type == nil {
            status.reportMissingVariableType(variable, navigationPath: navigationPath)
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

    private static func generateDiscussionSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, status: DocumentationStatus) -> StrictString {
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

        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: discussionHeading, inline: true).source
        ]
        for paragraph in discussion {
            let rendered = StrictString(paragraph.renderedHTML(internalIdentifiers: packageIdentifiers))
            if rendered.contains("<h1>".scalars) ∨ rendered.contains("<h2>".scalars) {
                status.reportExcessiveHeading(symbol: symbol, navigationPath: navigationPath)
            }
            sectionContents.append(rendered)
        }

        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func generateLibrariesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>) -> StrictString {
        guard let package = symbol as? PackageAPI,
            ¬package.libraries.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Library Products"
            }
        } else {
            heading = "library" // From “products: [.library(...)]”
        }

        return generateChildrenSection(localization: localization, heading: heading, children: package.libraries, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers)
    }

    private static func generateModulesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>) -> StrictString {
        guard let library = symbol as? LibraryAPI,
            ¬library.modules.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Modules"
            }
        } else {
            heading = "target" // From “targets: [.target(...)]”
        }

        return generateChildrenSection(localization: localization, heading: heading, children: library.modules, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers)
    }

    private static func generateChildrenSection(localization: LocalizationIdentifier, heading: StrictString, children: [APIElement], pathToSiteRoot: StrictString, packageIdentifiers: Set<String>) -> StrictString {
        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: heading, inline: true).source
        ]
        for child in children {
            var name = StrictString(child.name)
            if child is PackageAPI ∨ child is LibraryAPI {
                name = HTMLElement("span", attributes: ["class": "text"], contents: name, inline: true).source
                name = HTMLElement("span", attributes: ["class": "string"], contents: name, inline: true).source
            } else {
                name = highlight(name: name)
            }
            name = HTMLElement("code", attributes: ["class": "swift"], contents: name, inline: true).source

            let target = pathToSiteRoot + child.relativePagePath[localization]!
            var entry = [HTMLElement("a", attributes: ["href": target], contents: name, inline: true).source]
            if let description = child.documentation?.descriptionSection {
                entry.append(StrictString(description.renderedHTML(internalIdentifiers: packageIdentifiers)))
            }
            sectionContents.append(HTMLElement("div", attributes: ["class": "child"], contents: entry.joinedAsLines(), inline: false).source)
        }
        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func highlight(name: StrictString) -> StrictString {
        var result = name
        highlight("(", as: "punctuation", in: &result)
        highlight(")", as: "punctuation", in: &result)
        highlight(":", as: "punctuation", in: &result)
        highlight("_", as: "keyword", in: &result)
        highlight("[", as: "punctuation", in: &result)
        highlight("]", as: "punctuation", in: &result)
        result.prepend(contentsOf: "<span class\u{22}internal‐identifier\u{22}>")
        result.append(contentsOf: "</span>")
        return result
    }
    private static func highlight(_ token: StrictString, as class: StrictString, in name: inout StrictString) {
        name.replaceMatches(for: token, with: "</span>" + HTMLElement("span", attributes: ["class": `class`], contents: token, inline: true).source + "<span class\u{22}internal‐identifier\u{22}>")
    }
}
