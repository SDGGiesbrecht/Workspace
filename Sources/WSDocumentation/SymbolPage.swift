/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal class SymbolPage : Page {

    // MARK: - Initialization

    /// Begins creating a symbol page.
    ///
    /// If `coverageCheckOnly` is `true`, initialization will be aborted and `nil` returned once validation is complete. No other circumstances will cause initialization to fail.
    internal convenience init?(
        localization: LocalizationIdentifier,
        pathToSiteRoot: StrictString,
        navigationPath: [APIElement],
        packageImport: StrictString?,
        index: StrictString,
        symbol: APIElement,
        package: PackageAPI,
        copyright: StrictString,
        packageIdentifiers: Set<String>,
        symbolLinks: [String: String],
        status: DocumentationStatus,
        output: Command.Output,
        coverageCheckOnly: Bool) {

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
        content.append(SymbolPage.generateParemetersSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks, status: status))
        content.append(SymbolPage.generateThrowsSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks, status: status))
        content.append(SymbolPage.generateReturnsSection(localization: localization, symbol: symbol, navigationPath: navigationPath, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks, status: status))

        if coverageCheckOnly {
            return nil
        }

        self.init(
            localization: localization,
            pathToSiteRoot: pathToSiteRoot,
            navigationPath: navigationPath,
            packageImport: packageImport,
            index: index,
            symbol: symbol,
            package: package,
            copyright: copyright,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks,
            adjustedSymbolLinks: adjustedSymbolLinks,
            partiallyConstructedContent: content)
    }

    /// Final initialization which can be skipped when only checking coverage.
    private init(
        localization: LocalizationIdentifier,
        pathToSiteRoot: StrictString,
        navigationPath: [APIElement],
        packageImport: StrictString?,
        index: StrictString,
        symbol: APIElement,
        package: PackageAPI,
        copyright: StrictString,
        packageIdentifiers: Set<String>,
        symbolLinks: [String: String],
        adjustedSymbolLinks: [String: String],
        partiallyConstructedContent: [StrictString]) {
        var content = partiallyConstructedContent

        content.append(SymbolPage.generateLibrariesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        content.append(SymbolPage.generateModulesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))

        switch symbol {
        case .package, .library, .module:
            content.append(SymbolPage.generateTypesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generateExtensionsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generateProtocolsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generateFunctionsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generateVariablesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generateOperatorsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
            content.append(SymbolPage.generatePrecedenceGroupsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        case .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .conformance:
            content.append(contentsOf: SymbolPage.generateMembersSections(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks))
        case .operator, .precedence:
            break
        }

        let extensions: [StrictString] = SymbolPage.generateOtherModuleExtensionsSections(symbol: symbol, package: package, localization: localization, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: adjustedSymbolLinks)

        super.init(localization: localization,
                   pathToSiteRoot: pathToSiteRoot,
                   navigationPath: SymbolPage.generateNavigationPath(localization: localization, pathToSiteRoot: pathToSiteRoot, navigationPath: navigationPath),
                   packageImport: packageImport,
                   index: index,
                   symbolImports: SymbolPage.generateImportStatement(for: symbol, package: package, localization: localization, pathToSiteRoot: pathToSiteRoot),
                   symbolType: symbol.symbolType(localization: localization),
                   compilationConditions: SymbolPage.generateCompilationConditions(symbol: symbol),
                   constraints: SymbolPage.generateConstraints(symbol: symbol, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks),
                   title: StrictString(symbol.name.source()),
                   content: content.joinedAsLines(),
                   extensions: extensions.joinedAsLines(),
                   copyright: copyright)
    }

    // MARK: - Generation

    private static func generateMembersSections(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> [StrictString] {
        var result: [StrictString] = []
        result.append(SymbolPage.generateCasesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateNestedTypesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateTypePropertiesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateTypeMethodsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateInitializersSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generatePropertiesSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateSubscriptsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(SymbolPage.generateMethodsSection(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        result.append(contentsOf: SymbolPage.generateConformanceSections(localization: localization, symbol: symbol, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        return result
    }

    private static func generateNavigationPath(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: [APIElement]) -> StrictString {
        let navigationPathLinks = navigationPath.indices.map { (level: Int) -> StrictString in
            let element = navigationPath[level]
            let url = pathToSiteRoot.appending(contentsOf: element.relativePagePath[localization]!)
            if ¬navigationPath.isEmpty,
                level ≠ navigationPath.index(before: navigationPath.endIndex) {
                return HTMLElement("a", attributes: [
                    "href": HTML.percentEncodeURLPath(url)
                    ], contents: HTML.escape(StrictString(element.name.source())), inline: true).source
            } else {
                return HTMLElement("span", attributes: [:], contents: HTML.escape(StrictString(element.name.source())), inline: true).source
            }
        }
        return navigationPathLinks.joined(separator: "\n")
    }

    private static func generateDependencyStatement(for symbol: APIElement, package: PackageAPI, localization: LocalizationIdentifier, pathToSiteRoot: StrictString) -> StrictString {

        guard let module = symbol.homeModule.pointee,
            let product = APIElement.module(module).homeProduct.pointee else {
                return "" // @exempt(from: tests) Should never be nil.
        }
        let libraryName = product.name.text
        let packageName = package.name.text

        let dependencyStatement = SyntaxFactory.makeFunctionCallExpr(
            calledExpression: SyntaxFactory.makeMemberAccessExpr(
                base: SyntaxFactory.makeBlankUnknownExpr(),
                dot: SyntaxFactory.makeToken(.period),
                name: SyntaxFactory.makeToken(.identifier("product")),
                declNameArguments: nil),
            leftParen: SyntaxFactory.makeToken(.leftParen),
            argumentList: SyntaxFactory.makeFunctionCallArgumentList([
                SyntaxFactory.makeFunctionCallArgument(
                    label: SyntaxFactory.makeToken(.identifier("name")),
                    colon: SyntaxFactory.makeToken(.colon, trailingTrivia: .spaces(1)),
                    expression: SyntaxFactory.makeStringLiteralExpr(libraryName),
                    trailingComma: SyntaxFactory.makeToken(.comma, trailingTrivia: .spaces(1))),
                SyntaxFactory.makeFunctionCallArgument(
                    label: SyntaxFactory.makeToken(.identifier("package")),
                    colon: SyntaxFactory.makeToken(.colon, trailingTrivia: .spaces(1)),
                    expression: SyntaxFactory.makeStringLiteralExpr(packageName),
                    trailingComma: nil)
                ]),
            rightParen: SyntaxFactory.makeToken(.rightParen),
            trailingClosure: nil)

        let source = dependencyStatement.syntaxHighlightedHTML(
            inline: false,
            internalIdentifiers: [],
            symbolLinks: [:])

        return StrictString(source)
    }

    private static func generateImportStatement(for symbol: APIElement, package: PackageAPI, localization: LocalizationIdentifier, pathToSiteRoot: StrictString) -> StrictString {

        guard let module = symbol.homeModule.pointee else {
            return ""
        }
        let moduleName = module.name.text

        let importStatement = SyntaxFactory.makeImportDecl(
            attributes: nil,
            modifiers: nil,
            importTok: SyntaxFactory.makeToken(.importKeyword, trailingTrivia: .spaces(1)),
            importKind: nil,
            path: SyntaxFactory.makeAccessPath([
                SyntaxFactory.makeAccessPathComponent(
                    name: SyntaxFactory.makeToken(.identifier(moduleName)),
                    trailingDot: nil)
                ]))

        var links: [String: String] = [:]
        if let link = APIElement.module(module).relativePagePath[localization] {
            links[moduleName] = String(pathToSiteRoot + link)
        }

        let source = importStatement.syntaxHighlightedHTML(
            inline: false,
            internalIdentifiers: [moduleName],
            symbolLinks: links)

        return HTMLElement("div", attributes: ["class": "import‐header"], contents: [
            StrictString(source),
            SymbolPage.generateDependencyStatement(for: symbol, package: package, localization: localization, pathToSiteRoot: pathToSiteRoot)
            ].joinedAsLines(), inline: false).source
    }

    private static func generateCompilationConditions(symbol: APIElement) -> StrictString? {
        if let conditions = symbol.compilationConditions?.syntaxHighlightedHTML(inline: true) {
            return StrictString(conditions)
        }
        return nil
    }

    private static func generateConstraints(symbol: APIElement, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString? {
        if let constraints = symbol.constraints {
            let withoutSpace = constraints.withWhereKeyword(constraints.whereKeyword.withLeadingTrivia([]))
            return StrictString(withoutSpace.syntaxHighlightedHTML(inline: true, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
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
        guard var declaration = symbol.declaration else {
            return ""
        }
        if let constraints = symbol.constraints,
            let constrained = declaration as? Constrained {
            declaration = constrained.withGenericWhereClause(constraints)
        }

        if case .variable(let variable) = symbol,
            variable.declaration.bindings.first?.typeAnnotation?.isMissing ≠ false {
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
        case .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
            switch localization._bestMatch {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                discussionHeading = "Discussion"
            }
        }

        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: discussionHeading, inline: true).source
        ]

        var empty = true
        for paragraph in discussion {
            let rendered = StrictString(paragraph.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
            if rendered.contains("<h1>".scalars) ∨ rendered.contains("<h2>".scalars) {
                status.reportExcessiveHeading(symbol: symbol, navigationPath: navigationPath)
            }
            if empty, ¬rendered.isWhitespace {
                empty = false
            }
            sectionContents.append(rendered)
        }

        if empty {
            return ""
        }
        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func generateParemetersSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        let parameters = symbol.parameters()
        let parameterDocumentation = symbol.documentation?.normalizedParameters ?? []

        // Check that parameters correspond.
        var validatedParameters: [ParameterDocumentation] = []
        for index in parameters.indices {
            let name = parameters[index]
            if index ∉ parameterDocumentation.indices {
                status.reportMissingParameter(name, symbol: symbol, navigationPath: navigationPath)
                continue
            }
            let documentation = parameterDocumentation[index]
            if name ≠ documentation.name.text {
                status.reportMissingParameter(name, symbol: symbol, navigationPath: navigationPath)
                continue
            }
            validatedParameters.append(documentation)
        }
        if parameterDocumentation.count > parameters.count {
            for extra in parameterDocumentation[parameters.endIndex...] {
                status.reportNonExistentParameter(extra.name.text, symbol: symbol, navigationPath: navigationPath)
            }
        }

        /// Check that closure parameters are labelled.
        if let declaration = symbol.declaration {
            class Scanner : SyntaxVisitor {
                init(status: DocumentationStatus, symbol: APIElement, navigationPath: [APIElement]) {
                    self.status = status
                    self.symbol = symbol
                    self.navigationPath = navigationPath
                }
                let status: DocumentationStatus
                let symbol: APIElement
                let navigationPath: [APIElement]
                override func visit(_ node: FunctionTypeSyntax) {
                    for argument in node.arguments
                        where (argument.secondName?.text.isEmpty ≠ false ∨ argument.secondName?.text == "_") // @exempt(from: tests) #workaround(SwiftSyntax 0.40200.0, Wildcard is never detected by SwiftSyntax.)
                            ∧ (argument.firstName?.text.isEmpty ≠ false ∨ argument.firstName?.text == "_") {
                                status.reportUnlabelledParameter(node.source(), symbol: symbol, navigationPath: navigationPath)
                    }
                }
            }
            Scanner(status: status, symbol: symbol, navigationPath: navigationPath).visit(declaration)
        }

        guard ¬validatedParameters.isEmpty else {
            return ""
        }

        let parametersHeading: StrictString = Callout.parameters.localizedText(localization.code)

        var list: [HTMLElement] = []
        for entry in validatedParameters {
            let term = StrictString(entry.name.syntaxHighlightedHTML(inline: true, internalIdentifiers: [entry.name.text], symbolLinks: [:]))
            list.append(HTMLElement("dt", contents: term, inline: true))

            let description = entry.description.map({ $0.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks) })
            list.append(HTMLElement("dd", contents: StrictString(description.joinedAsLines()), inline: true))
        }

        let section = [
            HTMLElement("h2", contents: parametersHeading, inline: true).source,
            HTMLElement("dl", contents: list.map({ $0.source }).joinedAsLines(), inline: true).source
        ]
        return HTMLElement("section", contents: section.joinedAsLines(), inline: false).source
    }

    private static func generateThrowsSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        guard let callout = symbol.documentation?.throwsCallout else {
            return ""
        }
        let throwsHeading: StrictString = Callout.throws.localizedText(localization.code)
        var section = [HTMLElement("h2", contents: throwsHeading, inline: true).source]
        for contents in callout.contents {
            section.append(StrictString(contents.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)))
        }
        return HTMLElement("section", contents: section.joinedAsLines(), inline: false).source
    }

    private static func generateReturnsSection(localization: LocalizationIdentifier, symbol: APIElement, navigationPath: [APIElement], packageIdentifiers: Set<String>, symbolLinks: [String: String], status: DocumentationStatus) -> StrictString {
        guard let callout = symbol.documentation?.returnsCallout else {
            return ""
        }
        let returnsHeading: StrictString = Callout.returns.localizedText(localization.code)
        var section = [HTMLElement("h2", contents: returnsHeading, inline: true).source]
        for contents in callout.contents {
            section.append(StrictString(contents.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)))
        }
        return HTMLElement("section", contents: section.joinedAsLines(), inline: false).source
    }

    private static func generateOtherModuleExtensionsSections(symbol: APIElement, package: PackageAPI, localization: LocalizationIdentifier, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> [StrictString] {
        var extensions: [ExtensionAPI] = []
        for `extension` in package.allExtensions {
            switch symbol {
            case .package, .library, .module, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
                break
            case .type(let type):
                if `extension`.isExtension(of: type) {
                    extensions.append(`extension`)
                }
            case .protocol(let `protocol`):
                if `extension`.isExtension(of: `protocol`) {
                    extensions.append(`extension`)
                }
            case .extension(let `rootExtension`):
                if ¬(`extension` === `rootExtension`),
                    `extension`.extendsSameType(as: `rootExtension`) {
                    extensions.append(`extension`)
                }
            }
        }

        return extensions.map({ (`extension`: ExtensionAPI) -> StrictString in
            var result: [StrictString] = []
            result.append(generateImportStatement(for: APIElement.extension(`extension`), package: package, localization: localization, pathToSiteRoot: pathToSiteRoot))

            let sections = generateMembersSections(localization: localization, symbol: APIElement.extension(`extension`), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
            result.append(HTMLElement("div", attributes: ["class": "main‐text‐column"], contents: sections.joinedAsLines(), inline: false).source)
            return result.joinedAsLines()
        })
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
        return generateChildrenSection(localization: localization, heading: extensionsHeader(localization: localization), children: symbol.extensions.map({ APIElement.extension($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
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
        guard ¬symbol.instanceMethods.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: functionsHeader(localization: localization), children: symbol.instanceMethods.map({ APIElement.function($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
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
        guard ¬symbol.instanceProperties.isEmpty else {
                return ""
        }
        return generateChildrenSection(localization: localization, heading: variablesHeader(localization: localization), children: symbol.instanceProperties.map({ APIElement.variable($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func operatorsHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Operators"
            }
        } else {
            heading = "operator"
        }
        return heading
    }

    private static func generateOperatorsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.operators.isEmpty else {
            return ""
        }
        return generateChildrenSection(localization: localization, heading: operatorsHeader(localization: localization), children: symbol.operators.map({ APIElement.operator($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    internal static func precedenceGroupsHeader(localization: LocalizationIdentifier) -> StrictString {
        let heading: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                heading = "Precedence Groups"
            }
        } else {
            heading = "precedencegroup"
        }
        return heading
    }

    private static func generatePrecedenceGroupsSection(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        guard ¬symbol.operators.isEmpty else {
            return ""
        }
        return generateChildrenSection(localization: localization, heading: precedenceGroupsHeader(localization: localization), children: symbol.precedenceGroups.map({ APIElement.precedence($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
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
        guard ¬symbol.instanceProperties.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.instanceProperties.map({ APIElement.variable($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
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
        guard ¬symbol.instanceMethods.isEmpty else {
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

        return generateChildrenSection(localization: localization, heading: heading, children: symbol.instanceMethods.map({ APIElement.function($0) }), pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)
    }

    private static func generateConformanceSections(localization: LocalizationIdentifier, symbol: APIElement, pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> [StrictString] {
        var result: [StrictString] = []
        for conformance in symbol.conformances {
            let name = conformance.type.syntaxHighlightedHTML(inline: true, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)

            var children: [APIElement] = []
            if let reference = conformance.reference {
                var apiElement: APIElement?
                switch reference {
                case .protocol(let `protocol`):
                    if let pointee = `protocol`.pointee {
                        apiElement = .protocol(pointee)
                    }
                case .superclass(let superclass):
                    if let pointee = superclass.pointee {
                        apiElement = .type(pointee)
                    }
                }
                if let found = apiElement?.children {
                    children = found
                }
            }

            let subconformancesFiltered = children.filter { child in
                switch child {
                case .package, .library, .module, .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .operator, .precedence:
                    return true
                case .conformance:
                    return false
                }
            }
            result.append(generateChildrenSection(localization: localization, heading: StrictString(name), escapeHeading: false, children: subconformancesFiltered, pathToSiteRoot: pathToSiteRoot, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks))
        }
        return result
    }

    private static func generateChildrenSection(localization: LocalizationIdentifier, heading: StrictString, escapeHeading: Bool = true, children: [APIElement], pathToSiteRoot: StrictString, packageIdentifiers: Set<String>, symbolLinks: [String: String]) -> StrictString {
        var sectionContents: [StrictString] = [
            HTMLElement("h2", contents: escapeHeading ? HTML.escape(heading) : heading, inline: true).source
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
                name = HTMLElement("span", attributes: ["class": "text"], contents: HTML.escape(name), inline: true).source
                name = HTMLElement("span", attributes: ["class": "string"], contents: name, inline: true).source
            case .module, .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
                name = highlight(name: name, internal: child.relativePagePath[localization] ≠ nil)
            }
            name = HTMLElement("code", attributes: ["class": "swift"], contents: name, inline: true).source
            if let constraints = child.constraints {
                name += StrictString(constraints.syntaxHighlightedHTML(inline: true, internalIdentifiers: packageIdentifiers))
            }

            if let local = child.relativePagePath[localization] {
                let target = pathToSiteRoot + local
                entry.append(HTMLElement("a", attributes: [
                    "href": HTML.percentEncodeURLPath(target)
                    ], contents: name, inline: true).source)
                if let description = child.documentation?.descriptionSection {
                    entry.append(StrictString(description.renderedHTML(localization: localization.code, internalIdentifiers: packageIdentifiers, symbolLinks: symbolLinks)))
                }
            } else {
                entry.append(name)
            }
            sectionContents.append(HTMLElement("div", attributes: ["class": "child"], contents: entry.joinedAsLines(), inline: false).source)
        }
        return HTMLElement("section", contents: sectionContents.joinedAsLines(), inline: false).source
    }

    private static func highlight(name: StrictString, internal: Bool = true) -> StrictString {
        var result = HTML.escape(name)
        highlight("(", as: "punctuation", in: &result, internal: `internal`)
        highlight(")", as: "punctuation", in: &result, internal: `internal`)
        highlight(":", as: "punctuation", in: &result, internal: `internal`)
        highlight("_", as: "keyword", in: &result, internal: `internal`)
        highlight("[", as: "punctuation", in: &result, internal: `internal`)
        highlight("]", as: "punctuation", in: &result, internal: `internal`)
        result.prepend(contentsOf: "<span class=\u{22}" + (`internal` ? "internal" : "external") as StrictString + " identifier\u{22}>")
        result.append(contentsOf: "</span>")
        return result
    }
    private static func highlight(_ token: StrictString, as class: StrictString, in name: inout StrictString, internal: Bool) {
        name.replaceMatches(for: token, with: "</span>" + HTMLElement("span", attributes: ["class": `class`], contents: token, inline: true).source + "<span class=\u{22}" + (`internal` ? "internal" : "external") as StrictString + " identifier\u{22}>")
    }
}
