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

    internal init(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement], symbol: APIElement, packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) {
        let adjustedSymbolLinks = symbolLinks.mapValues { String(pathToSiteRoot) + $0 }

        var content: [StrictString] = []
        content.append(SymbolPage.generateDescriptionSection(symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks, status: status))
        content.append(SymbolPage.generateDeclarationSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks, status: status))
        content.append(SymbolPage.generateDiscussionSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks, status: status))

        content.append(SymbolPage.generateLibrariesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        content.append(SymbolPage.generateModulesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        content.append(SymbolPage.generateTypesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateExtensionsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateProtocolsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateFunctionsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateVariablesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        content.append(SymbolPage.generateCasesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateNestedTypesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateTypePropertiesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateTypeMethodsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateInitializersSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generatePropertiesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateSubscriptsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        content.append(SymbolPage.generateMethodsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        super.init(localization: localization,
                   pathToSiteRoot: pathToSiteRoot,
                   navigationPath: SymbolPage.generateNavigationPath(localization: localization, pathToSiteRoot: pathToSiteRoot, navigationPath: navigationPath),
                   symbolType: symbol.symbolType(localization: localization),
                   compilationConditions: SymbolPage.generateCompilationConditions(symbol: symbol),
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

    private static func generateCompilationConditions(symbol: APIElement) -> StrictString? {
        if let conditions = symbol.compilationConditions?.syntaxHighlightedHTML(inline: true) {
            return StrictString(conditions)
        }
        return nil
    }

    private static func generateDescriptionSection(symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        if let documentation = symbol.documentation,
            let description = documentation.descriptionSection {
                return HTMLElement("div", attributes: ["class": "description"], contents: StrictString(description.renderedHTML(internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)), inline: false).source
        }
        if ¬(symbol is ExtensionAPI) {
            status.reportMissingDescription(symbol: symbol, navigationPath: navigationPath)
        }
        return ""
    }

    private static func generateDeclarationSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
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
            StrictString(declaration.syntaxHighlightedHTML(inline: false, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        ]

        return HTMLElement("section", attributes: ["class": "declaration"], contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func generateDiscussionSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        guard let discussion = symbol.documentation?.discussionEntries,
            ¬discussion.isEmpty else {
                return ""
        }

        let discussionHeading: StrictString
        switch symbol {
        case is APIScope, is PackageAPI, is LibraryAPI, is ModuleAPI :
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Overview"
            }
        default:
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Discussion"
            }
        }

        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: discussionHeading, inline: true).source
        ]
        for paragraph in discussion {
            let rendered = StrictString(paragraph.renderedHTML(internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
            if rendered.contains("<h1>".scalars) ∨ rendered.contains("<h2>".scalars) {
                status.reportExcessiveHeading(symbol: symbol, navigationPath: navigationPath)
            }
            sectionContents.append(rendered)
        }

        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func generateLibrariesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
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

        return generateChildrenSection(localization: localization, heading: heading, children: package.libraries, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateModulesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
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

        return generateChildrenSection(localization: localization, heading: heading, children: library.modules, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateTypesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let module = symbol as? ModuleAPI,
            ¬module.types.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Types"
            }
        } else {
            heading = "struct/class/enum"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: module.types, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateExtensionsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let module = symbol as? ModuleAPI,
            ¬module.extensions.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Extensions"
            }
        } else {
            heading = "extension"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: module.extensions, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateProtocolsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let module = symbol as? ModuleAPI,
            ¬module.protocols.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Protocols"
            }
        } else {
            heading = "protocol"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: module.protocols, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateFunctionsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let module = symbol as? ModuleAPI,
            ¬module.functions.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Functions"
            }
        } else {
            heading = "func"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: module.functions, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateVariablesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let module = symbol as? ModuleAPI,
            ¬module.globalVariables.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Global Variables"
            }
        } else {
            heading = "var"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: module.globalVariables, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateCasesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.cases.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Cases"
            }
        } else {
            heading = "case"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.cases, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateNestedTypesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.subtypes.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Nested Types"
            }
        } else {
            heading = "struct/class/enum"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.subtypes, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateTypePropertiesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.typeProperties.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Type Properties"
            }
        } else {
            heading = "static var"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.typeProperties, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateTypeMethodsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.typeMethods.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Type Methods"
            }
        } else {
            heading = "static func"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.typeMethods, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateInitializersSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.initializers.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Initializers"
            }
        } else {
            heading = "init"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.initializers, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generatePropertiesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.properties.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Properties"
            }
        } else {
            heading = "var"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.properties, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateSubscriptsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.subscripts.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Subscripts"
            }
        } else {
            heading = "subscript"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.subscripts, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateMethodsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard let scope = symbol as? APIScope,
            ¬scope.methods.isEmpty else {
                return ""
        }

        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Methods"
            }
        } else {
            heading = "func"
        }

        return generateChildrenSection(localization: localization, heading: heading, children: scope.methods, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateChildrenSection(localization: LocalizationIdentifier, heading: StrictString, children: [APIElement], pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: heading, inline: true).source
        ]
        for child in children {
            var entry: [StrictString] = []
            if let conditions = child.compilationConditions {
                entry.append(StrictString(conditions.syntaxHighlightedHTML(inline: true, internalIdentifiers: [], symbolLinks: [:])))
                entry.append("<br>")
            }

            var name = StrictString(child.name)
            if child is PackageAPI ∨ child is LibraryAPI {
                name = HTMLElement("span", attributes: ["class": "text"], contents: name, inline: true).source
                name = HTMLElement("span", attributes: ["class": "string"], contents: name, inline: true).source
            } else {
                name = highlight(name: name)
            }
            name = HTMLElement("code", attributes: ["class": "swift"], contents: name, inline: true).source

            let target = pathToSiteRoot + child.relativePagePath[localization]!
            entry.append(HTMLElement("a", attributes: ["href": target], contents: name, inline: true).source)
            if let description = child.documentation?.descriptionSection {
                entry.append(StrictString(description.renderedHTML(internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)))
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
        result.prepend(contentsOf: "<span class=\u{22}internal identifier\u{22}>")
        result.append(contentsOf: "</span>")
        return result
    }
    private static func highlight(_ token: StrictString, as class: StrictString, in name: inout StrictString) {
        name.replaceMatches(for: token, with: "</span>" + HTMLElement("span", attributes: ["class": `class`], contents: token, inline: true).source + "<span class=\u{22}internal identifier\u{22}>")
    }
}
