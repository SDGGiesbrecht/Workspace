/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
  import SDGSwiftSource

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
      projectRoot: URL,
      packageImport: StrictString?,
      index: StrictString,
      sectionIdentifier: IndexSectionIdentifier,
      platforms: StrictString,
      symbol: SymbolType,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      tools: PackageCLI? = nil,
      editableModules: [String],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) where SymbolType: SymbolLike {

      if extensionStorage[
        symbol.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].relativePagePath.first?
      .value.components(separatedBy: "/").count == 3 {
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
          projectRoot: projectRoot,
          localization: localization,
          editableModules: editableModules,
          graphs: package.symbolGraphs().map({ $0.graph }),
          packageIdentifiers: packageIdentifiers,
          symbolLinks: adjustedSymbolLinks,
          status: status
        )
      )

      self.init(
        symbol: symbol
      )
      #warning("↑ Working backwards from here.")
    }

    /// Final initialization which can be skipped when only checking coverage.
    private init<SymbolType>(
      symbol: SymbolType
    ) where SymbolType: SymbolLike {
      super.init(
        title: "",
        content: ""
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
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
          extensionStorage: extensionStorage,
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
            StrictString(element.names.resolvedForNavigation),
            extensionStorage[
              element.extendedPropertiesIndex,
              default: .default  // @exempt(from: tests) Reachability unknown.
            ].relativePagePath[localization]!
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
      guard
        let module = extensionStorage[
          symbol.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].homeModule,
        let product = extensionStorage[
          module.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].homeProduct
      else {
        return ""  // @exempt(from: tests) Should never be nil.
      }
      let libraryName = product.names.title
      let packageName = package.names.title

      let dependencyStatement = FunctionCallExprSyntax(
        calledExpression: ExprSyntax(
          MemberAccessExprSyntax(
            base: ExprSyntax(MissingSyntax()),
            dot: TokenSyntax(.period, presence: .present),
            name: TokenSyntax(.identifier("product"), presence: .present),
            declNameArguments: nil
          )
        ),
        leftParen: TokenSyntax(.leftParen, presence: .present),
        argumentList: TupleExprElementListSyntax([
          TupleExprElementSyntax(
            label: TokenSyntax(.identifier("name"), presence: .present),
            colon: TokenSyntax(.colon, trailingTrivia: .spaces(1), presence: .present),
            expression: ExprSyntax(
              StringLiteralExprSyntax(
                openQuote: TokenSyntax(.stringQuote, presence: .present),
                segments: StringLiteralSegmentsSyntax([
                  .stringSegment(
                    StringSegmentSyntax(content: TokenSyntax(.stringSegment(libraryName), presence: .present))
                  )
                ]),
                closeQuote: TokenSyntax(.stringQuote, presence: .present)
              )
            ),
            trailingComma: TokenSyntax(.comma, trailingTrivia: .spaces(1), presence: .present)
          ),
          TupleExprElementSyntax(
            label: TokenSyntax(.identifier("package"), presence: .present),
            colon: TokenSyntax(.colon, trailingTrivia: .spaces(1), presence: .present),
            expression: ExprSyntax(
              StringLiteralExprSyntax(
                openQuote: TokenSyntax(.stringQuote, presence: .present),
                segments: StringLiteralSegmentsSyntax([
                  .stringSegment(
                    StringSegmentSyntax(content: TokenSyntax(.stringSegment(packageName), presence: .present))
                  )
                ]),
                closeQuote: TokenSyntax(.stringQuote, presence: .present)
              )
            ),
            trailingComma: nil
          ),
        ]),
        rightParen: TokenSyntax(.rightParen, presence: .present),
        trailingClosure: nil,
        additionalTrailingClosures: nil
      )

      let source = SwiftSyntaxNode(Syntax(dependencyStatement)).syntaxHighlightedHTML(
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
      guard
        let module = extensionStorage[
          symbol.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].homeModule
      else {
        return ""
      }
      let moduleName = module.names.title

      let importStatement = ImportDeclSyntax(
        attributes: nil,
        modifiers: nil,
        importTok: TokenSyntax(.importKeyword, trailingTrivia: .spaces(1), presence: .present),
        importKind: nil,
        path: AccessPathSyntax([
          AccessPathComponentSyntax(
            name: TokenSyntax(.identifier(moduleName), presence: .present),
            trailingDot: nil
          )
        ])
      )

      var links: [String: String] = [:]
      if let link = extensionStorage[
        module.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].relativePagePath[localization] {
        links[moduleName] = String(pathToSiteRoot + link)
      }

      let source = SwiftSyntaxNode(Syntax(importStatement)).syntaxHighlightedHTML(
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
            pathToSiteRoot: pathToSiteRoot,
            extensionStorage: extensionStorage
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
      projectRoot: URL,
      localization: LocalizationIdentifier,
      editableModules: [String],
      graphs: [SymbolGraph],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      var parserCache = ParserCache()
      if let documentation = extensionStorage[
        symbol.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].localizedDocumentation[localization],
        let description = documentation.documentation().descriptionSection(cache: &parserCache)
      {
        return generateDescriptionSection(
          contents: StrictString(
            description.renderedHTML(
              localization: localization.code,
              internalIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks,
              parserCache: &parserCache
            )
          )
        )
      }
      if symbol.hasEditableDocumentation(editableModules: editableModules),
        ¬symbol.isCapableOfInheritingDocumentation(graphs: graphs)
      {
        status.reportMissingDescription(
          symbol: symbol,
          navigationPath: navigationPath,
          projectRoot: projectRoot,
          localization: localization
        )
      }
      return ""
    }

    private static func generateDiscussionSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      editableModules: [String],
      navigationPath: [SymbolLike],
      projectRoot: URL,
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus
    ) -> StrictString where SymbolType: SymbolLike {
      #warning("Presumably useful elsewhere.")
      var parserCache = ParserCache()
      guard
        let discussion = extensionStorage[
          symbol.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].localizedDocumentation[localization]?.documentation().discussionSections(cache: &parserCache),
        ¬discussion.isEmpty
      else {
        return ""
      }

      for paragraph in discussion {
        let rendered = StrictString(
          paragraph.renderedHTML(
            localization: localization.code,
            internalIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks,
            parserCache: &parserCache
          )
        )
        if rendered.contains("<h1>".scalars.literal())
          ∨ rendered.contains("<h2>".scalars.literal()),
          symbol.hasEditableDocumentation(editableModules: editableModules)
        {
          status.reportExcessiveHeading(
            symbol: symbol,
            navigationPath: navigationPath,
            projectRoot: projectRoot,
            localization: localization
          )
        }
      }
      return ""
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
      projectRoot: URL,
      editableModules: [String],
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      status: DocumentationStatus
    ) -> StrictString {
      #warning("Presumably useful elsewhere.")
      let parameters = symbol.parameters()
      let parameterDocumentation =
        extensionStorage[
          symbol.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].localizedDocumentation[localization]?.documentation().parameters()
        ?? []
      let documentedParameters = parameterDocumentation.map { $0.name }

      if symbol.hasEditableDocumentation(editableModules: editableModules),
        parameters ≠ documentedParameters
      {
        // #workaround(SDGSwift 11.1.0, Not collected properly for subscripts at present.)
        if let graphSymbol = symbol as? SymbolGraph.Symbol,
          graphSymbol.kind.identifier == .subscript
            ∨ graphSymbol.kind.identifier == .typeSubscript
        {
        } else {
          status.reportMismatchedParameters(
            documentedParameters,
            expected: parameters,
            symbol: symbol,
            navigationPath: navigationPath,
            projectRoot: projectRoot,
            localization: localization
          )
        }
      }
      return ""
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
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
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
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func modulesHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateModulesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      guard let library = symbol as? LibraryAPI,
        ¬library.modules.isEmpty
      else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: modulesHeader(localization: localization),
        children: library.modules.compactMap({ name in
          return package.modules.first(where: { $0.names.title == name })
        }),
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func typesHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateTypesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let types = symbol.children(package: package).filter({ child in
        if let kind = child.kind?.identifier {
          switch kind {
          case .associatedtype, .class, .enum, .struct, .typealias:
            return true
          case .deinit, .`case`, .func, .operator, .`init`, .ivar, .macro, .method, .property,
            .protocol, .snippet, .snippetGroup, .subscript, .typeMethod, .typeProperty,
            .typeSubscript, .var, .module:
            return false
          default:  // @exempt(from: tests)
            child.kind?.identifier.warnUnknown()
            return false
          }
        } else {
          return false
        }
      })
      guard ¬types.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: typesHeader(localization: localization),
        children: types,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func extensionsHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateExtensionsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      guard let module = symbol as? ModuleAPI else {
        return ""
      }
      let global = extensionStorage[
        package.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].packageExtensions
      let extensions = module.extensions().filter({ `extension` in
        return global.contains(where: { $0.identifier == `extension`.identifier })
      })
      guard ¬extensions.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: extensionsHeader(localization: localization),
        children: extensions,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func protocolsHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateProtocolsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let protocols = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .`protocol` })
      guard ¬protocols.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: protocolsHeader(localization: localization),
        children: protocols,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func functionsHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateFunctionsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let instanceMethods = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .func ∨ $0.kind?.identifier == .method })
      guard ¬instanceMethods.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: functionsHeader(localization: localization),
        children: instanceMethods,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func variablesHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateVariablesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let instanceProperties = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .`var` ∨ $0.kind?.identifier == .property })
      guard ¬instanceProperties.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: variablesHeader(localization: localization),
        children: instanceProperties,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func operatorsHeader(localization: LocalizationIdentifier) -> StrictString {
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
      return heading
    }

    private static func generateOperatorsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let operators = (symbol as? ModuleAPI)?.operators ?? []
      guard ¬operators.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: operatorsHeader(localization: localization),
        children: operators,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    internal static func precedenceGroupsHeader(
      localization: LocalizationIdentifier
    ) -> StrictString {
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
      return heading
    }

    private static func generatePrecedenceGroupsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let precedenceGroups = (symbol as? ModuleAPI)?.precedenceGroups ?? []
      guard ¬precedenceGroups.isEmpty else {
        return ""
      }
      return generateChildrenSection(
        localization: localization,
        heading: precedenceGroupsHeader(localization: localization),
        children: precedenceGroups,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateCasesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let cases = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .`case` })
      guard ¬cases.isEmpty else {
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
        children: cases,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateNestedTypesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let typeKinds: Set<SymbolGraph.Symbol.KindIdentifier?> = [
        .associatedtype, .class, .struct, .enum, .typealias,
      ]
      let types = symbol.children(package: package)
        .filter({ $0.kind?.identifier ∈ typeKinds })
      guard ¬types.isEmpty else {
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
        children: types,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateTypePropertiesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let typeProperties = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .typeProperty })
      guard ¬typeProperties.isEmpty else {
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
        children: typeProperties,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateTypeMethodsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let typeMethods = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .typeMethod })
      guard ¬typeMethods.isEmpty else {
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
        children: typeMethods,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateInitializersSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let initializers = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .`init` })
      guard ¬initializers.isEmpty else {
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
        children: initializers,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generatePropertiesSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let instanceProperties = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .property })
      guard ¬instanceProperties.isEmpty else {
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
        children: instanceProperties,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateSubscriptsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let subscripts = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .subscript })
      guard ¬subscripts.isEmpty else {
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
        children: subscripts,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateMethodsSection<SymbolType>(
      localization: LocalizationIdentifier,
      symbol: SymbolType,
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString where SymbolType: SymbolLike {
      let instanceMethods = symbol.children(package: package)
        .filter({ $0.kind?.identifier == .method })
      guard ¬instanceMethods.isEmpty else {
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
        children: instanceMethods,
        pathToSiteRoot: pathToSiteRoot,
        package: package,
        extensionStorage: extensionStorage,
        packageIdentifiers: packageIdentifiers,
        symbolLinks: symbolLinks
      )
    }

    private static func generateChildrenSection(
      localization: LocalizationIdentifier,
      heading: StrictString,
      children: [SymbolLike],
      pathToSiteRoot: StrictString,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String]
    ) -> StrictString {

      func getEntryContents(_ child: SymbolLike) -> [StrictString] {
        var entry: [StrictString] = []

        var name = StrictString(child.names.title)
        var relativePathOfChild = extensionStorage[
          child.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].relativePagePath[localization]
        if let `extension` = child as? Extension {
          var baseType: SymbolGraph.Symbol?
          for graph in package.symbolGraphs() {
            for symbol in graph.graph.symbols.values {
              if symbol.identifier.precise == `extension`.identifier.precise {
                baseType = symbol  // @exempt(from: tests) Reachability unknown.
              }
            }
          }
          if let resolved = baseType {
            relativePathOfChild =  // @exempt(from: tests) Reachability unknown.
              extensionStorage[resolved.extendedPropertiesIndex, default: .default]
              .relativePagePath[localization]
          }
        }

        switch child {
        case is PackageAPI, is LibraryAPI:
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
        default:
          name = highlight(name: name)
        }
        name = ElementSyntax(
          "code",
          attributes: ["class": "swift"],
          contents: name,
          inline: true
        )
        .normalizedSource()

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
          var parserCache = ParserCache()
          if let description = extensionStorage[
            child.extendedPropertiesIndex,
            default: .default  // @exempt(from: tests) Reachability unknown.
          ].localizedDocumentation[localization]?.documentation().descriptionSection(cache: &parserCache) {
            entry.append(
              StrictString(
                description.renderedHTML(
                  localization: localization.code,
                  internalIdentifiers: packageIdentifiers,
                  symbolLinks: symbolLinks,
                  parserCache: &parserCache
                )
              )
            )
          }
        }

        return entry
      }

      return generateChildrenSection(
        heading: heading,
        children: children.filter({ child in
          extensionStorage[
            child.extendedPropertiesIndex,
            default: .default  // @exempt(from: tests) Reachability unknown.
          ].exists(in: localization)
        }).sorted(by: { $0.names.resolvedForNavigation < $1.names.resolvedForNavigation }),
        childContents: getEntryContents,
        childAttributes: { _ in return [:] }
      )
    }

    private static func generateChildrenSection<T>(
      heading: StrictString,
      children: [T],
      childContents: (T) -> [StrictString],
      childAttributes: (T) -> [StrictString: StrictString] = { _ in [:] }
    ) -> StrictString {

      var sectionContents: [StrictString] = [
        ElementSyntax(
          "h2",
          contents: HTML.escapeTextForCharacterData(heading),
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
        .normalizedSource()
    }

    private static func highlight(name: StrictString) -> StrictString {
      var result = HTML.escapeTextForCharacterData(name)
      highlight("(", as: "punctuation", in: &result)
      highlight(")", as: "punctuation", in: &result)
      highlight(":", as: "punctuation", in: &result)
      highlight("_", as: "keyword", in: &result)
      highlight("[", as: "punctuation", in: &result)
      highlight("]", as: "punctuation", in: &result)
      result.prepend(
        contentsOf: "<span class=\u{22}internal identifier\u{22}>"
      )
      result.append(contentsOf: "</span>")
      return result
    }
    private static func highlight(
      _ token: StrictString,
      as class: StrictString,
      in name: inout StrictString
    ) {
      name.replaceMatches(
        for: token,
        with: "</span>"
          + ElementSyntax(
            "span",
            attributes: ["class": `class`],
            contents: token,
            inline: true
          )
          .normalizedSource() + "<span class=\u{22}internal identifier\u{22}>"
      )
    }
  }
#endif
