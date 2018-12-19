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

    internal init(localization: LocalizationIdentifier,
                  pathToSiteRoot: StrictString,
                  navigationPath: [APIElement],
                  packageImport: StrictString?,
                  index: StrictString,
                  symbol: APIElement,
                  copyright: StrictString,
                  packageIdentifiers: Set<String>,
                  symbolLinks: [String: String],
                  status: DocumentationStatus,
                  output: Command.Output) {

        if symbol.relativePagePath.first?.value.components(separatedBy: "/").count == 3 {
            switch symbol {
            case .package, .module, .type, .extension, .protocol:
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "..." + StrictString(symbol.name.source()) + "..."
                    }
                }).resolved())
            default:
                break
            }
        }

        let adjustedSymbolLinks = symbolLinks.mapValues { String(pathToSiteRoot) + $0 }

        var content: [StrictString] = []
        content.append(SymbolPage.generateDescriptionSection(symbol: symbol, navigationPath: navigationPath, localization: localization, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks, status: status))
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
                   packageImport: packageImport,
                   index: index,
                   symbolType: symbol.symbolType(localization: localization),
                   compilationConditions: SymbolPage.generateCompilationConditions(symbol: symbol),
                   title: StrictString(symbol.name.source()),
                   content: content.joinedAsLines(), copyright: copyright)
    }

    // MARK: - Generation

    private static func generateNavigationPath(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement]) -> StrictString {
        let navigationPathLinks = navigationPath.indices.map { (level: Int) -> StrictString in
            let element = navigationPath[level]
            let url = pathToSiteRoot.appending(contentsOf: element.relativePagePath[localization]!)
            if ¬navigationPath.isEmpty,
                level ≠ navigationPath.index(before: navigationPath.endIndex) {
                return HTMLElement("a", attributes: [
                    "href": HTML.percentEncodeURLPath(url)
                    ], contents: StrictString(element.name.source()), inline: true).source
            } else {
                return HTMLElement("span", attributes: [:], contents: StrictString(element.name.source()), inline: true).source
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

    private static func generateDescriptionSection(symbol: APIElement, navigationPath: [APIElement], localization: LocalizationIdentifier, packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        if let documentation = symbol.documentation,
            let description = documentation.descriptionSection {
            return HTMLElement("div", attributes: ["class": "description"], contents: StrictString(description.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)), inline: false).source
        }
        if case .extension = symbol {} else {
            status.reportMissingDescription(symbol: symbol, navigationPath: navigationPath)
        }
        return ""
    }

    private static func generateDeclarationSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        guard let declaration = symbol.declaration else {
            return ""
        }

        if case .variable(let variable) = symbol,
            variable.declaration.bindings.first?.typeAnnotation == nil {
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
        case .package, .library, .module, .type, .protocol, .extension:
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Overview"
            }
        case .case, .initializer, .variable, .subscript, .function, .conformance:
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Discussion"
            }
        }

        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: discussionHeading, inline: true).source
        ]
        for paragraph in discussion {
            let rendered = StrictString(paragraph.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
            if rendered.contains("<h1>".scalars) ∨ rendered.contains("<h2>".scalars) {
                status.reportExcessiveHeading(symbol: symbol, navigationPath: navigationPath)
            }
            sectionContents.append(rendered)
        }

        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    internal static func librariesHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Library Products"
            }
        } else {
            heading = "library" // From “products: [.library(...)]”
        }
        return heading
    }

    private static func generateLibrariesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard case .package(let package) = symbol,
            ¬package.libraries.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: librariesHeader(localization: localization), children: package.libraries.map({ APIElement.library($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func modulesHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Modules"
            }
        } else {
            heading = "target" // From “targets: [.target(...)]”
        }
        return heading
    }

    private static func generateModulesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard case .library(let library) = symbol,
            ¬library.modules.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: modulesHeader(localization: localization), children: library.modules.map({ APIElement.module($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func typesHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Types"
            }
        } else {
            heading = "struct/class/enum"
        }
        return heading
    }

    private static func generateTypesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.types.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: typesHeader(localization: localization), children: symbol.types.map({ APIElement.type($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func extensionsHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Extensions"
            }
        } else {
            heading = "extension"
        }
        return heading
    }

    private static func generateExtensionsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.extensions.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: modulesHeader(localization: localization), children: symbol.extensions.map({ APIElement.extension($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func protocolsHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Protocols"
            }
        } else {
            heading = "protocol"
        }
        return heading
    }

    private static func generateProtocolsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.protocols.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: protocolsHeader(localization: localization), children: symbol.protocols.map({ APIElement.protocol($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func functionsHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Functions"
            }
        } else {
            heading = "func"
        }
        return heading
    }

    private static func generateFunctionsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.methods.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: functionsHeader(localization: localization), children: symbol.methods.map({ APIElement.function($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func variablesHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Global Variables"
            }
        } else {
            heading = "var"
        }
        return heading
    }

    private static func generateVariablesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.properties.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: variablesHeader(localization: localization), children: symbol.properties.map({ APIElement.variable($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateCasesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.cases.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.cases.map({ APIElement.case($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateNestedTypesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.types.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.types.map({ APIElement.type($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateTypePropertiesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.typeProperties.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.typeProperties.map({ APIElement.variable($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateTypeMethodsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.typeMethods.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.typeMethods.map({ APIElement.function($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateInitializersSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.initializers.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.initializers.map({ APIElement.initializer($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generatePropertiesSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.properties.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.properties.map({ APIElement.variable($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateSubscriptsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.subscripts.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.subscripts.map({ APIElement.subscript($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateMethodsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.methods.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.methods.map({ APIElement.function($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
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

            var name = StrictString(child.name.source())
            switch child {
            case .package, .library:
                name = HTMLElement("span", attributes: ["class": "text"], contents: name, inline: true).source
                name = HTMLElement("span", attributes: ["class": "string"], contents: name, inline: true).source
            case .module, .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .conformance:
                name = highlight(name: name)
            }
            name = HTMLElement("code", attributes: ["class": "swift"], contents: name, inline: true).source

            let target = pathToSiteRoot + child.relativePagePath[localization]!
            entry.append(HTMLElement("a", attributes: [
                "href": HTML.percentEncodeURLPath(target)
                ], contents: name, inline: true).source)
            if let description = child.documentation?.descriptionSection {
                entry.append(StrictString(description.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)))
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
