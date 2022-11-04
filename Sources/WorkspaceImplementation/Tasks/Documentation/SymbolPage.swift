/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SymbolKit
  import SDGSwiftDocumentation
  import SDGHTML

  import SwiftSyntax
  import SwiftSyntaxParser
  #warning("Simplify.")
  import enum SDGSwiftSource.Callout
  import struct SDGSwiftSource.ParameterDocumentation

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal class SymbolPage: Page {

    // MARK: - Initialization

    /// Begins creating a symbol page.
    ///
    /// If `coverageCheckOnly` is `true`, initialization will be aborted and `nil` returned once validation is complete. No other circumstances will cause initialization to fail.
    internal convenience init?<SymbolType>(
      localization: LocalizationIdentifier,
      allLocalizations: [LocalizationIdentifier],
      pathToSiteRoot: StrictString,
      navigationPath: [SymbolLike],
      packageImport: StrictString?,
      index: StrictString,
      sectionIdentifier: IndexSectionIdentifier,
      platforms: StrictString,
      symbol: SymbolType,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      tools: PackageCLI? = nil,
      copyright: StrictString,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) where SymbolType: SymbolLike {

      if extensionStorage[symbol.extendedPropertiesIndex, default: .default].relativePagePath.first?.value.components(separatedBy: "/").count == 3 {
        switch symbol.indexSectionIdentifier {
        case .package, .modules, .types, .extensions, .protocols:
          output.print(
            UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "...\(StrictString(symbol.names.title))..."
              case .deutschDeutschland:
                return "... \(StrictString(symbol.names.title)) ..."
              }
            }).resolved()
          )
        default:
          break
        }
      }

      let adjustedSymbolLinks = symbolLinks.mapValues { String(pathToSiteRoot) + $0 }

      var content: [StrictString] = []
      content.append(
        SymbolPage.generateDescriptionSection(
          symbol: symbol,
          extensionStorage: extensionStorage,
          navigationPath: navigationPath,
          localization: localization,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks,
          status: status
        )
      )
      content.append(
        SymbolPage.generateDeclarationSection(
          localization: localization,
          symbol: symbol,
          navigationPath: navigationPath,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks,
          status: status
        )
      )
      content.append(
        SymbolPage.generateDiscussionSection(
          localization: localization,
          symbol: symbol,
          extensionStorage: extensionStorage,
          navigationPath: navigationPath,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks,
          status: status
        )
      )
      content.append(
        SymbolPage.generateParametersSection(
          localization: localization,
          symbol: symbol,
          navigationPath: navigationPath,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks,
          extensionStorage: extensionStorage,
          status: status
        )
      )
      content.append(
        SymbolPage.generateThrowsSection(
          localization: localization,
          symbol: symbol,
          extensionStorage: extensionStorage,
          navigationPath: navigationPath,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks,
          status: status
        )
      )
      content.append(
        SymbolPage.generateReturnsSection(
          localization: localization,
          symbol: symbol,
          extensionStorage: extensionStorage,
          navigationPath: navigationPath,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks,
          status: status
        )
      )

      if coverageCheckOnly {
        return nil
      }

      self.init(
        localization: localization,
        allLocalizations: allLocalizations,
        pathToSiteRoot: pathToSiteRoot,
        navigationPath: navigationPath,
        packageImport: packageImport,
        index: index,
        sectionIdentifier: sectionIdentifier,
        platforms: platforms,
        symbol: symbol,
        package: package,
        extensionStorage: extensionStorage,
        tools: tools,
        copyright: copyright,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks,
        adjustedSymbolLinks: adjustedSymbolLinks,
        partiallyConstructedContent: content
      )
    }

    /// Final initialization which can be skipped when only checking coverage.
    private init<SymbolType>(
      localization: LocalizationIdentifier,
      allLocalizations: [LocalizationIdentifier],
      pathToSiteRoot: StrictString,
      navigationPath: [SymbolLike],
      packageImport: StrictString?,
      index: StrictString,
      sectionIdentifier: IndexSectionIdentifier,
      platforms: StrictString,
      symbol: SymbolType,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      tools: PackageCLI?,
      copyright: StrictString,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      adjustedSymbolLinks: [String: String],
      partiallyConstructedContent: [StrictString]
    ) where SymbolType: SymbolLike {
      let navigationPath = SymbolPage.generateNavigationPath(
        localization: localization,
        pathToSiteRoot: pathToSiteRoot,
        allLocalizations: allLocalizations
          .lazy.filter({ $0 ∉ extensionStorage[symbol.extendedPropertiesIndex, default: .default].skippedLocalizations }).map({ localization in
            let path: StrictString
            if extensionStorage[symbol.extendedPropertiesIndex, default: .default].exists(in: localization) {
              path = extensionStorage[symbol.extendedPropertiesIndex, default: .default].relativePagePath[localization]!
            } else {
              path = extensionStorage[symbol.extendedPropertiesIndex, default: .default].localizedEquivalentPaths[localization]!
            }
            return (localization: localization, path: path)
          }),
        navigationPath: navigationPath,
        extensionStorage: extensionStorage
      )

      var content = partiallyConstructedContent

      content.append(
        SymbolPage.generateToolsSection(
          localization: localization,
          tools: tools,
          pathToSiteRoot: pathToSiteRoot
        )
      )

      content.append(
        SymbolPage.generateLibrariesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks
        )
      )

      content.append(
        SymbolPage.generateModulesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks
        )
      )

      switch symbol.indexSectionIdentifier {
      case .package, .libraries, .modules:
        content.append(
          SymbolPage.generateTypesSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generateExtensionsSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generateProtocolsSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generateFunctionsSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generateVariablesSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generateOperatorsSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
        content.append(
          SymbolPage.generatePrecedenceGroupsSection(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
      case .types, .protocols, .extensions, .variables, .functions:
        if case .protocols = symbol.indexSectionIdentifier {
          content.append(SymbolPage.protocolModeInterface(localization: localization))
        }
        content.append(
          contentsOf: SymbolPage.generateMembersSections(
            localization: localization,
            symbol: symbol,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: adjustedSymbolLinks
          )
        )
      case .tools, .operators, .precedenceGroups:
        break
      }

      super.init(
        localization: localization,
        pathToSiteRoot: pathToSiteRoot,
        navigationPath: navigationPath,
        packageImport: packageImport,
        index: index,
        sectionIdentifier: sectionIdentifier,
        platforms: platforms,
        symbolImports: SymbolPage.generateImportStatement(
          for: symbol,
          package: package,
          localization: localization,
          pathToSiteRoot: pathToSiteRoot, extensionStorage: extensionStorage
        ),
        symbolType: symbol.symbolType(localization: localization),
        title: StrictString(symbol.names.title),
        content: content.joinedAsLines(),
        copyright: copyright
      )
    }

    // MARK: - Generation

    internal static func conformanceFilterLabel(
      localization: LocalizationIdentifier
    ) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Filter"
      }
    }

    internal static func conformanceFilterOff(localization: LocalizationIdentifier) -> StrictString
    {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "All"
      case .deutschDeutschland:
        return "Alle"
      }
    }

    internal static func conformanceFilterRequired(
      localization: LocalizationIdentifier
    ) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Conformance Requirements"
      case .deutschDeutschland:
        return "Übereinstimmungsvoraussetzungen"
      }
    }

    internal static func conformanceFilterCustomizable(
      localization: LocalizationIdentifier
    ) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom:
        return "Customisation Points"
      case .englishUnitedStates, .englishCanada:
        return "Customization Points"
      case .deutschDeutschland:
        return "Anpassungsmöglichkeiten"
      }
    }

    internal static func conformanceFilterButton(
      labelled label: StrictString,
      value: StrictString
    ) -> StrictString {
      return ElementSyntax(
        "input",
        attributes: [
          "name": "conformance filter",
          "onchange": "switchConformanceMode(this)",
          "type": "radio",
          "value": value,
        ],
        contents: label,
        inline: false
      ).normalizedSource()
    }

    private static func protocolModeInterface(localization: LocalizationIdentifier) -> StrictString
    {
      var contents: StrictString = ""
      contents.append(
        contentsOf: ElementSyntax(
          "p",
          attributes: ["class": "conformance‐filter‐label"],
          contents: conformanceFilterLabel(localization: localization),
          inline: false
        ).normalizedSource()
      )
      contents.append(
        contentsOf: conformanceFilterButton(
          labelled: conformanceFilterOff(localization: localization),
          value: "all"
        )
      )
      contents.append(
        contentsOf: conformanceFilterButton(
          labelled: conformanceFilterRequired(localization: localization),
          value: "required"
        )
      )
      contents.append(
        contentsOf: conformanceFilterButton(
          labelled: conformanceFilterCustomizable(localization: localization),
          value: "customizable"
        )
      )
      return ElementSyntax(
        "div",
        attributes: ["class": "conformance‐filter"],
        contents: contents,
        inline: false
      ).normalizedSource()
    }

    private static func generateMembersSections<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> [StrictString] where SymbolType: SymbolLike {
      var result: [StrictString] = []
      result.append(
        SymbolPage.generateCasesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateNestedTypesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateTypePropertiesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateTypeMethodsSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateInitializersSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generatePropertiesSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateSubscriptsSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        SymbolPage.generateMethodsSection(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      result.append(
        contentsOf: SymbolPage.generateConformanceSections(
          localization: localization,
          symbol: symbol,
          pathToSiteRoot: pathToSiteRoot,
          package: package,
          packageIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )
      )
      return result
    }

    private static func generateNavigationPath(
      localization: LocalizationIdentifier,
      pathToSiteRoot: StrictString,
      allLocalizations: [(localization: LocalizationIdentifier, path: StrictString)],
      navigationPath: [SymbolLike],
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      return generateNavigationPath(
        localization: localization,
        pathToSiteRoot: pathToSiteRoot,
        allLocalizations: allLocalizations,
        navigationPath: navigationPath.map({ element in
          return (
            StrictString(element.names.resolvedForNavigation), extensionStorage[element.extendedPropertiesIndex, default: .default].relativePagePath[localization]!
          )
        })
      )
    }

    internal static func generateNavigationPath(
      localization: LocalizationIdentifier,
      pathToSiteRoot: StrictString,
      allLocalizations: [(localization: LocalizationIdentifier, path: StrictString)],
      navigationPath: [(label: StrictString, path: StrictString)]
    ) -> StrictString {

      var elements: [ElementSyntax] = []
      if allLocalizations.count > 1 {
        elements.append(
          ElementSyntax(
            "a",
            attributes: [
              "id": "current‐language‐icon",
              "onmouseenter": "showLanguageSwitch(this)",
            ],
            contents: [
              ElementSyntax(
                "span",
                contents: HTML.escapeTextForCharacterData(localization._iconOrCode),
                inline: true
              )
            ].lazy.map({ $0.normalizedSource() }).joinedAsLines(),
            inline: true
          )
        )

        elements.append(
          ElementSyntax(
            "div",
            attributes: [
              "id": "language‐switch",
              "onmouseleave": "hideLanguageSwitch(this)",
            ],
            contents: allLocalizations.lazy.filter({ $0.localization ≠ localization })
              .map({ entry in
                return ElementSyntax(
                  "a",
                  attributes: [
                    "href": pathToSiteRoot + HTML.percentEncodeURLPath(entry.path)
                  ],
                  contents: HTML.escapeTextForCharacterData(
                    entry.localization._iconOrCode
                  ),
                  inline: true
                ).normalizedSource()
              }).joinedAsLines(),
            inline: false
          )
        )
      }

      elements.append(
        contentsOf: navigationPath.indices.lazy.map { (level: Int) -> ElementSyntax in
          let (label, path) = navigationPath[level]
          let url = pathToSiteRoot.appending(contentsOf: path)
          if ¬navigationPath.isEmpty,
            level ≠ navigationPath.index(before: navigationPath.endIndex)
          {
            return ElementSyntax(
              "a",
              attributes: [
                "href": HTML.percentEncodeURLPath(url)
              ],
              contents: HTML.escapeTextForCharacterData(label),
              inline: true
            )
          } else {
            return ElementSyntax(
              "span",
              attributes: [:],
              contents: HTML.escapeTextForCharacterData(label),
              inline: true
            )
          }
        }
      )

      return elements.lazy.map({ $0.normalizedSource() }).joined(separator: "\n")
    }

    private static func generateDependencyStatement<SymbolType>(
      for symbol: SymbolType,
      package: PackageAPI,
      localization: LocalizationIdentifier,
      pathToSiteRoot: StrictString,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString where SymbolType: SymbolLike {
      guard let module = extensionStorage[symbol.extendedPropertiesIndex, default: .default].homeModule,
            let product = extensionStorage[module.extendedPropertiesIndex, default: .default].homeProduct
      else {
        return ""  // @exempt(from: tests) Should never be nil.
      }
      let libraryName = product.names.title
      let packageName = package.names.title

      let dependencyStatement = SyntaxFactory.makeFunctionCallExpr(
        calledExpression: ExprSyntax(
          SyntaxFactory.makeMemberAccessExpr(
            base: ExprSyntax(SyntaxFactory.makeBlankUnknownExpr()),
            dot: SyntaxFactory.makeToken(.period),
            name: SyntaxFactory.makeToken(.identifier("product")),
            declNameArguments: nil
          )
        ),
        leftParen: SyntaxFactory.makeToken(.leftParen),
        argumentList: SyntaxFactory.makeTupleExprElementList([
          SyntaxFactory.makeTupleExprElement(
            label: SyntaxFactory.makeToken(.identifier("name")),
            colon: SyntaxFactory.makeToken(.colon, trailingTrivia: .spaces(1)),
            expression: ExprSyntax(SyntaxFactory.makeStringLiteralExpr(libraryName)),
            trailingComma: SyntaxFactory.makeToken(.comma, trailingTrivia: .spaces(1))
          ),
          SyntaxFactory.makeTupleExprElement(
            label: SyntaxFactory.makeToken(.identifier("package")),
            colon: SyntaxFactory.makeToken(.colon, trailingTrivia: .spaces(1)),
            expression: ExprSyntax(SyntaxFactory.makeStringLiteralExpr(packageName)),
            trailingComma: nil
          ),
        ]),
        rightParen: SyntaxFactory.makeToken(.rightParen),
        trailingClosure: nil,
        additionalTrailingClosures: nil
      )

      let source = dependencyStatement.syntaxHighlightedHTML(
        inline: false,
        internalIdentifiers: [],
        symbolLinks: [:]
      )

      return StrictString(source)
    }

    private static func generateImportStatement<SymbolType>(
      for symbol: SymbolType,
      package: PackageAPI,
      localization: LocalizationIdentifier,
      pathToSiteRoot: StrictString,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString where SymbolType: SymbolLike {
      guard let module = extensionStorage[symbol.extendedPropertiesIndex, default: .default].homeModule else {
        return ""
      }
      let moduleName = module.names.title

      let importStatement = SyntaxFactory.makeImportDecl(
        attributes: nil,
        modifiers: nil,
        importTok: SyntaxFactory.makeToken(.importKeyword, trailingTrivia: .spaces(1)),
        importKind: nil,
        path: SyntaxFactory.makeAccessPath([
          SyntaxFactory.makeAccessPathComponent(
            name: SyntaxFactory.makeToken(.identifier(moduleName)),
            trailingDot: nil
          )
        ])
      )

      var links: [String: String] = [:]
      if let link = extensionStorage[module.extendedPropertiesIndex, default: .default].relativePagePath[localization] {
        links[moduleName] = String(pathToSiteRoot + link)
      }

      let source = importStatement.syntaxHighlightedHTML(
        inline: false,
        internalIdentifiers: [moduleName],
        symbolLinks: links
      )

      return ElementSyntax(
        "div",
        attributes: ["class": "import‐header"],
        contents: [
          StrictString(source),
          SymbolPage.generateDependencyStatement(
            for: symbol,
            package: package,
            localization: localization,
            pathToSiteRoot: pathToSiteRoot, extensionStorage: extensionStorage
          ),
        ].joinedAsLines(),
        inline: false
      ).normalizedSource()
    }

    internal static func generateDescriptionSection(contents: StrictString) -> StrictString {
      return ElementSyntax(
        "div",
        attributes: ["class": "description"],
        contents: contents,
        inline: false
      ).normalizedSource()
    }

    private static func generateDescriptionSection<SymbolType>(
      symbol: SymbolType,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      navigationPath: [SymbolLike],
      localization: LocalizationIdentifier,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      if let documentation = extensionStorage[symbol.extendedPropertiesIndex, default: .default].localizedDocumentation[localization],
         let description = documentation.documentation().descriptionSection
      {
        return generateDescriptionSection(
          contents: StrictString(
            description.renderedHTML(
              localization: localization.code,
              internalIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks
            )
          )
        )
      }
      if symbol is Extension {
      } else {
        status.reportMissingDescription(
          symbol: symbol,
          navigationPath: navigationPath,
          localization: localization
        )
      }
      return ""
    }

    internal static func generateDeclarationSection(
      localization: LocalizationIdentifier,
      declaration: StrictString
    ) -> StrictString {
      let declarationHeading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        declarationHeading = "Declaration"
      case .deutschDeutschland:
        declarationHeading = "Festlegung"
      }

      let sectionContents: [StrictString] = [
        ElementSyntax("h2", contents: declarationHeading, inline: true).normalizedSource(),
        declaration,
      ]

      return ElementSyntax(
        "section",
        attributes: ["class": "declaration"],
        contents: sectionContents.joinedAsLines(),
        inline: false
      ).normalizedSource()
    }

    private static func generateDeclarationSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      navigationPath: [SymbolLike],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      guard var declaration = symbol.declaration else {
        return ""
      }

      #warning("Need to convert to proofreading rule.")
      /*if case .variable(let variable) = symbol,
        variable.declaration.bindings.first?.typeAnnotation?.isMissing ≠ false
      {
        status.reportMissingVariableType(variable, navigationPath: navigationPath)
      }*/

      return generateDeclarationSection(
        localization: localization,
        declaration: StrictString(
          declaration.syntaxHighlightedHTML(
            inline: false,
            internalIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks
          )
        )
      )
    }

    internal static func generateDiscussionSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType?,
      content: StrictString?
    ) -> StrictString where SymbolType: SymbolLike {
      guard let discussion = content else {
        return ""
      }

      var discussionHeading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        discussionHeading = "Discussion"
      case .deutschDeutschland:
        discussionHeading = "Einzelheiten"
      }
      if let swiftSymbol = symbol {
        switch swiftSymbol.indexSectionIdentifier {
        case .package, .libraries, .modules, .types, .protocols, .extensions:
          switch localization._bestMatch {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            discussionHeading = "Overview"
          case .deutschDeutschland:
            discussionHeading = "Übersicht"
          }
        case .variables, .functions, .operators, .precedenceGroups, .tools:
          break
        }
      }

      var sectionContents: [StrictString] = [
        ElementSyntax("h2", contents: discussionHeading, inline: true).normalizedSource()
      ]

      sectionContents.append(discussion)

      return ElementSyntax("section", contents: sectionContents.joinedAsLines(), inline: false)
        .normalizedSource()
    }

    private static func generateDiscussionSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      navigationPath: [SymbolLike],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      guard let discussion = extensionStorage[symbol.extendedPropertiesIndex, default: .default].localizedDocumentation[localization]?.documentation().discussionEntries,
        ¬discussion.isEmpty
      else {
        return ""
      }

      var sectionContents: [StrictString] = []

      var empty = true
      for paragraph in discussion {
        let rendered = StrictString(
          paragraph.renderedHTML(
            localization: localization.code,
            internalIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks
          )
        )
        if rendered.contains("<h1>".scalars.literal()) ∨ rendered.contains("<h2>".scalars.literal())
        {
          status.reportExcessiveHeading(
            symbol: symbol,
            navigationPath: navigationPath,
            localization: localization
          )
        }
        if empty, ¬rendered.isWhitespace {
          empty = false
        }
        sectionContents.append(rendered)
      }

      if empty {
        return ""
      }
      return generateDiscussionSection(
        localization: localization,
        symbol: symbol,
        content: sectionContents.joinedAsLines()
      )
    }

    internal static func generateParameterLikeSection(
      heading: StrictString,
      entries: [(term: StrictString, description: StrictString)]
    ) -> StrictString {
      guard ¬entries.isEmpty else {
        return ""
      }

      var list: [ElementSyntax] = []
      for entry in entries {
        list.append(ElementSyntax("dt", contents: entry.term, inline: true))
        list.append(ElementSyntax("dd", contents: entry.description, inline: true))
      }

      let section = [
        ElementSyntax("h2", contents: heading, inline: true).normalizedSource(),
        ElementSyntax(
          "dl",
          contents: list.map({ $0.normalizedSource() }).joinedAsLines(),
          inline: true
        ).normalizedSource(),
      ]
      return ElementSyntax("section", contents: section.joinedAsLines(), inline: false)
        .normalizedSource()
    }

    private static func generateParametersSection(
      localization: LocalizationIdentifier,
      symbol: SymbolLike,
      navigationPath: [SymbolLike],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      status: DocumentationStatus
    ) -> StrictString {
      let parameters = symbol.parameters()
      let parameterDocumentation =
      extensionStorage[symbol.extendedPropertiesIndex, default: .default]
        .localizedDocumentation[localization]?.normalizedParameters()
        ?? []
      let documentedParameters = parameterDocumentation.map { $0.name.text }

      if parameters ≠ documentedParameters {
        // #workaround(SDGSwift 11.1.0, Not collected properly for subscripts at present.)
        if let graphSymbol = symbol as? SymbolGraph.Symbol,
           graphSymbol.kind.identifier == .subscript
            ∨ graphSymbol.kind.identifier == .typeSubscript {
        } else {
          status.reportMismatchedParameters(
            documentedParameters,
            expected: parameters,
            symbol: symbol,
            navigationPath: navigationPath,
            localization: localization
          )
        }
      }
      let validatedParameters =
        parameterDocumentation
        .filter { parameters.contains($0.name.text) }

      /// Check that closure parameters are labelled.
      if let declaration = symbol.declaration {
        class Scanner: SyntaxVisitor {
          init(status: DocumentationStatus, symbol: SymbolLike, navigationPath: [SymbolLike]) {
            self.status = status
            self.symbol = symbol
            self.navigationPath = navigationPath
          }
          let status: DocumentationStatus
          let symbol: SymbolLike
          let navigationPath: [SymbolLike]
          override func visit(_ node: FunctionTypeSyntax) -> SyntaxVisitorContinueKind {
            for argument in node.arguments
            where
              (argument.secondName?.text.isEmpty ≠ false
              ∨ argument.secondName?.tokenKind == .wildcardKeyword)  // @exempt(from: tests)
              ∧ (argument.firstName?.text.isEmpty ≠ false
                ∨ argument.firstName?.tokenKind == .wildcardKeyword)
            {
              status.reportUnlabelledParameter(
                node.source(),
                symbol: symbol,
                navigationPath: navigationPath
              )
            }
            return .visitChildren
          }
        }
        let scanner = Scanner(status: status, symbol: symbol, navigationPath: navigationPath)
        let source: String = declaration.declarationFragments.lazy.map({ $0.spelling }).joined()
        if let syntax = try? SyntaxParser.parse(source: source) {
          scanner.walk(syntax)
        }
      }

      let parametersHeading: StrictString = Callout.parameters.localizedText(localization.code)
      return generateParameterLikeSection(
        heading: parametersHeading,
        entries:
          validatedParameters
          .map(
            { (entry: ParameterDocumentation) -> (term: StrictString, description: StrictString) in
              let term = StrictString(
                entry.name.syntaxHighlightedHTML(
                  inline: true,
                  internalIdentifiers: [entry.name.text],
                  symbolLinks: [:]
                )
              )

              let description = entry.description.map({ description in
                description.renderedHTML(
                  localization: localization.code,
                  internalIdentifiers: packageIdentifiers,
                  symbolLinks: symbolLinks
                )
              })
              return (term: term, description: StrictString(description.joinedAsLines()))
            }
          )
      )
    }

    private static func generateThrowsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      navigationPath: [SymbolLike],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      guard let callout = extensionStorage[symbol.extendedPropertiesIndex, default: .default].localizedDocumentation[localization]?.documentation().throwsCallout else {
        return ""
      }
      let throwsHeading: StrictString = Callout.throws.localizedText(localization.code)
      var section = [
        ElementSyntax("h2", contents: throwsHeading, inline: true).normalizedSource()
      ]
      for contents in callout.contents {
        section.append(
          StrictString(
            contents.renderedHTML(
              localization: localization.code,
              internalIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks
            )
          )
        )
      }
      return ElementSyntax("section", contents: section.joinedAsLines(), inline: false)
        .normalizedSource()
    }

    private static func generateReturnsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      navigationPath: [SymbolLike],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      guard let callout = extensionStorage[symbol.extendedPropertiesIndex, default: .default].localizedDocumentation[localization]?.documentation().returnsCallout else {
        return ""
      }
      let returnsHeading: StrictString = Callout.returns.localizedText(localization.code)
      var section = [
        ElementSyntax("h2", contents: returnsHeading, inline: true).normalizedSource()
      ]
      for contents in callout.contents {
        section.append(
          StrictString(
            contents.renderedHTML(
              localization: localization.code,
              internalIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks
            )
          )
        )
      }
      return ElementSyntax("section", contents: section.joinedAsLines(), inline: false)
        .normalizedSource()
    }

    internal static func toolsHeader(localization: LocalizationIdentifier) -> StrictString {
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Command Line Tools"
        case .deutschDeutschland:
          heading = "Befehlszeilenprogramme"
        }
      } else {
        heading = "executable"  // From “products: [.executable(...)]”
      }
      return heading
    }

    internal static func generateToolsSection(
      localization: LocalizationIdentifier,
      tools: PackageCLI?,
      pathToSiteRoot: StrictString
    ) -> StrictString {

      guard let commands = tools?.commands,
        ¬commands.isEmpty
      else {
        return ""
      }

      return generateChildrenSection(
        localization: localization,
        heading: toolsHeader(localization: localization),
        children: commands.values.sorted(
          by: { commandA, commandB in  // @exempt(from: tests)
            commandA.interfaces[localization]!.name < commandB.interfaces[localization]!.name
          }),
        pathToSiteRoot: pathToSiteRoot
      )
    }

    internal static func librariesHeader(localization: LocalizationIdentifier) -> StrictString {
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Library Products"
        case .deutschDeutschland:
          heading = "Biblioteksprodukte"
        }
      } else {
        heading = "library"  // From “products: [.library(...)]”
      }
      return heading
    }

    private static func generateLibrariesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      guard let package = symbol as? PackageAPI,
        ¬package.libraries.isEmpty
      else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: librariesHeader(localization: localization),
        children: package.libraries,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func modulesHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Modules"
        case .deutschDeutschland:
          heading = "Module"
        }
      } else {
        heading = "target"  // From “targets: [.target(...)]”
      }
      return heading*/
    }

    private static func generateModulesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard case .library(let library) = symbol,
        ¬library.modules.isEmpty
      else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: modulesHeader(localization: localization),
        children: library.modules.map({ APIElement.module($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func typesHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Types"
        case .deutschDeutschland:
          heading = "Typen"
        }
      } else {
        heading = "struct/class/enum"
      }
      return heading*/
    }

    private static func generateTypesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.types.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: typesHeader(localization: localization),
        children: symbol.types.map({ APIElement.type($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func extensionsHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Extensions"
        case .deutschDeutschland:
          heading = "Erweiterungen"
        }
      } else {
        heading = "extension"
      }
      return heading*/
    }

    private static func generateExtensionsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.extensions.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: extensionsHeader(localization: localization),
        children: symbol.extensions.map({ APIElement.extension($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func protocolsHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Protocols"
        case .deutschDeutschland:
          heading = "Protokolle"
        }
      } else {
        heading = "protocol"
      }
      return heading*/
    }

    private static func generateProtocolsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.protocols.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: protocolsHeader(localization: localization),
        children: symbol.protocols.map({ APIElement.protocol($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func functionsHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Functions"
        case .deutschDeutschland:
          heading = "Funktionen"
        }
      } else {
        heading = "func"
      }
      return heading*/
    }

    private static func generateFunctionsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.instanceMethods.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: functionsHeader(localization: localization),
        children: symbol.instanceMethods.map({ APIElement.function($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func variablesHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Global Variables"
        case .deutschDeutschland:
          heading = "Globale Variablen"
        }
      } else {
        heading = "var"
      }
      return heading*/
    }

    private static func generateVariablesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.instanceProperties.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: variablesHeader(localization: localization),
        children: symbol.instanceProperties.map({ APIElement.variable($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func operatorsHeader(localization: LocalizationIdentifier) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Operators"
        case .deutschDeutschland:
          heading = "Operatoren"
        }
      } else {
        heading = "operator"
      }
      return heading*/
    }

    private static func generateOperatorsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.operators.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: operatorsHeader(localization: localization),
        children: symbol.operators.map({ APIElement.operator($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    internal static func precedenceGroupsHeader(
      localization: LocalizationIdentifier
    ) -> StrictString {
      return ""
      #warning("Debugging...")/*
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Precedence Groups"
        case .deutschDeutschland:
          heading = "Rangfolgenklassen"
        }
      } else {
        heading = "precedencegroup"
      }
      return heading*/
    }

    private static func generatePrecedenceGroupsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.operators.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: precedenceGroupsHeader(localization: localization),
        children: symbol.precedenceGroups.map({ APIElement.precedence($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateCasesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.cases.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Cases"
        case .deutschDeutschland:
          heading = "Fälle"
        }
      } else {
        heading = "case"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.cases.map({ APIElement.case($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateNestedTypesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.types.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Nested Types"
        case .deutschDeutschland:
          heading = "Geschachtelte Typen"
        }
      } else {
        heading = "struct/class/enum"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.types.map({ APIElement.type($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateTypePropertiesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.typeProperties.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Type Properties"
        case .deutschDeutschland:
          heading = "Typ‐Eigenschaften"
        }
      } else {
        heading = "static var"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.typeProperties.map({ APIElement.variable($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateTypeMethodsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.typeMethods.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Type Methods"
        case .deutschDeutschland:
          heading = "Typ‐Methoden"
        }
      } else {
        heading = "static func"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.typeMethods.map({ APIElement.function($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateInitializersSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.initializers.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom:
          heading = "Initialisers"
        case .englishUnitedStates, .englishCanada:
          heading = "Initializers"
        case .deutschDeutschland:
          heading = "Voreinsteller"
        }
      } else {
        heading = "init"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.initializers.map({ APIElement.initializer($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generatePropertiesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.instanceProperties.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Properties"
        case .deutschDeutschland:
          heading = "Eigenschaften"
        }
      } else {
        heading = "var"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.instanceProperties.map({ APIElement.variable($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateSubscriptsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.subscripts.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Subscripts"
        case .deutschDeutschland:
          heading = "Indexe"
        }
      } else {
        heading = "subscript"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.subscripts.map({ APIElement.subscript($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateMethodsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*
      guard ¬symbol.instanceMethods.isEmpty else {
        return ""
      }

      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Methods"
        case .deutschDeutschland:
          heading = "Methoden"
        }
      } else {
        heading = "func"
      }

      return generateChildrenSection(
        localization: localization,
        heading: heading,
        children: symbol.instanceMethods.map({ APIElement.function($0) }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )*/
    }

    private static func generateConformanceSections<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> [StrictString] where SymbolType: SymbolLike {
      return []
      #warning("Debugging...")/*
      var result: [StrictString] = []
      conformanceProcessing: for conformance in symbol.conformances {
        let name = conformance.type.syntaxHighlightedHTML(
          inline: true,
          internalIdentifiers: packageIdentifiers,
          symbolLinks: symbolLinks
        )

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
          if let element = apiElement {
            if ¬element.exists(in: localization) {
              continue conformanceProcessing
            }
            children = element.children
          }
        }

        let subconformancesFiltered = children.filter { child in
          switch child {
          case .package, .library, .module, .type, .protocol, .extension, .case, .initializer,
            .variable, .subscript, .function, .operator, .precedence:
            return true
          case .conformance:
            return false
          }
        }
        result.append(
          generateChildrenSection(
            localization: localization,
            heading: StrictString(name),
            escapeHeading: false,
            children: subconformancesFiltered,
            pathToSiteRoot: pathToSiteRoot,
            package: package,
            packageIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks
          )
        )
      }
      return result*/
    }

    private static func generateChildrenSection(
      localization: LocalizationIdentifier,
      heading: StrictString,
      escapeHeading: Bool = true,
      children: [CommandInterfaceInformation],
      pathToSiteRoot: StrictString
    ) -> StrictString {
      return ""
      #warning("Debugging...")/*

      func getEntryContents(_ child: CommandInterfaceInformation) -> [StrictString] {
        var entry: [StrictString] = []

        let target = pathToSiteRoot + child.relativePagePath[localization]!
        entry.append(
          ElementSyntax(
            "a",
            attributes: ["href": HTML.percentEncodeURLPath(target)],
            contents: ElementSyntax(
              "code",
              attributes: ["class": "swift code"],
              contents: ElementSyntax(
                "span",
                attributes: ["class": "command"],
                contents: child.interfaces[localization]!.name,
                inline: true
              ).normalizedSource(),
              inline: true
            ).normalizedSource(),
            inline: true
          ).normalizedSource()
        )

        entry.append(
          ElementSyntax(
            "p",
            contents: HTML.escapeTextForCharacterData(
              child.interfaces[localization]!.description
            ),
            inline: false
          ).normalizedSource()
        )

        return entry
      }

      return generateChildrenSection(
        heading: heading,
        escapeHeading: escapeHeading,
        children: children,
        childContents: getEntryContents
      )*/
    }

    private static func generateChildrenSection<SymbolType>(
      localization: LocalizationIdentifier,
      heading: StrictString,
      escapeHeading: Bool = true,
      children: [SymbolType],
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      return ""
      #warning("Debugging...")/*

      func getEntryContents(_ child: APIElement) -> [StrictString] {
        var entry: [StrictString] = []
        if let conditions = child.compilationConditions {
          entry.append(
            StrictString(
              conditions.syntaxHighlightedHTML(
                inline: true,
                internalIdentifiers: [],
                symbolLinks: [:]
              )
            )
          )
          entry.append("<br>")
        }

        var name = StrictString(child.name.source())
        var relativePathOfChild = child.relativePagePath[localization]
        if case .extension(let `extension`) = child {
          var baseType: APIElement?
          for type in package.types where `extension`.isExtension(of: type) {
            baseType = APIElement.type(type)
            break
          }
          if baseType == nil /* Still not resolved. */ {
            for `protocol` in package.protocols
            where `extension`.isExtension(of: `protocol`) {
              baseType = APIElement.protocol(`protocol`)
              break
            }
          }
          if let resolved = baseType {
            relativePathOfChild = resolved.relativePagePath[localization]
          }
        }

        switch child {
        case .package, .library:
          name = ElementSyntax(
            "span",
            attributes: ["class": "text"],
            contents: HTML.escapeTextForCharacterData(name),
            inline: true
          ).normalizedSource()
          name = ElementSyntax(
            "span",
            attributes: ["class": "string"],
            contents: name,
            inline: true
          )
          .normalizedSource()
        case .module, .type, .protocol, .extension, .case, .initializer, .variable, .subscript,
          .function, .operator, .precedence, .conformance:
          name = highlight(name: name, internal: relativePathOfChild ≠ nil)
        }
        name = ElementSyntax(
          "code",
          attributes: ["class": "swift"],
          contents: name,
          inline: true
        )
        .normalizedSource()
        if let constraints = child.constraints {
          name += StrictString(
            constraints.syntaxHighlightedHTML(
              inline: true,
              internalIdentifiers: packageIdentifiers
            )
          )
        }

        if let local = relativePathOfChild {
          let target = pathToSiteRoot + local
          entry.append(
            ElementSyntax(
              "a",
              attributes: [
                "href": HTML.percentEncodeURLPath(target)
              ],
              contents: name,
              inline: true
            ).normalizedSource()
          )
          if let description = child.localizedDocumentation[localization]?.descriptionSection {
            entry.append(
              StrictString(
                description.renderedHTML(
                  localization: localization.code,
                  internalIdentifiers: packageIdentifiers,
                  symbolLinks: symbolLinks
                )
              )
            )
          }
        } else {
          entry.append(name)
        }

        return entry
      }
      func getAttributes(_ child: APIElement) -> [StrictString: StrictString] {
        if child.isProtocolRequirement {
          let conformanceAttributeName: StrictString = "data\u{2D}conformance"
          if child.hasDefaultImplementation {
            return [conformanceAttributeName: "customizable"]
          } else {
            return [conformanceAttributeName: "requirement"]
          }
        }
        return [:]
      }

      return generateChildrenSection(
        heading: heading,
        escapeHeading: escapeHeading,
        children: children.filter({ $0.exists(in: localization) }),
        childContents: getEntryContents,
        childAttributes: getAttributes
      )*/
    }

    private static func generateChildrenSection<T>(
      heading: StrictString,
      escapeHeading: Bool,
      children: [T],
      childContents: (T) -> [StrictString],
      childAttributes: (T) -> [StrictString: StrictString] = { _ in [:] }
    ) -> StrictString {
      return ""
      #warning("Debugging...")/*

      var sectionContents: [StrictString] = [
        ElementSyntax(
          "h2",
          contents: escapeHeading ? HTML.escapeTextForCharacterData(heading) : heading,
          inline: true
        ).normalizedSource()
      ]
      for child in children {
        let entry = childContents(child)

        var attributes: [StrictString: StrictString] = ["class": "child"]
        attributes.merge(
          childAttributes(child),
          uniquingKeysWith: { _, second in  // @exempt(from. tests) Keys always unique.
            return second
          }
        )

        sectionContents.append(
          ElementSyntax(
            "div",
            attributes: attributes,
            contents: entry.joinedAsLines(),
            inline: false
          ).normalizedSource()
        )
      }
      return ElementSyntax("section", contents: sectionContents.joinedAsLines(), inline: false)
        .normalizedSource()*/
    }

    private static func highlight(name: StrictString, internal: Bool = true) -> StrictString {
      return ""
      #warning("Debugging...")/*
      var result = HTML.escapeTextForCharacterData(name)
      highlight("(", as: "punctuation", in: &result, internal: `internal`)
      highlight(")", as: "punctuation", in: &result, internal: `internal`)
      highlight(":", as: "punctuation", in: &result, internal: `internal`)
      highlight("_", as: "keyword", in: &result, internal: `internal`)
      highlight("[", as: "punctuation", in: &result, internal: `internal`)
      highlight("]", as: "punctuation", in: &result, internal: `internal`)
      result.prepend(
        contentsOf: "<span class=\u{22}" + (`internal` ? "internal" : "external")
          as StrictString + " identifier\u{22}>"
      )
      result.append(contentsOf: "</span>")
      return result*/
    }
    private static func highlight(
      _ token: StrictString,
      as class: StrictString,
      in name: inout StrictString,
      internal: Bool
    ) {
      #warning("Debugging...")/*
      name.replaceMatches(
        for: token,
        with: "</span>"
          + ElementSyntax(
            "span",
            attributes: ["class": `class`],
            contents: token,
            inline: true
          )
          .normalizedSource() + "<span class=\u{22}" + (`internal` ? "internal" : "external")
          as StrictString + " identifier\u{22}>"
      )*/
    }
  }
#endif
