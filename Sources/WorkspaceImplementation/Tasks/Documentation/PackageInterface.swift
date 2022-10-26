/*
 PackageInterface.swift

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
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SDGSwiftDocumentation
  import SymbolKit
  import SDGHTML

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal struct PackageInterface {

    private static func specify(package: URL?, version: Version?) -> StrictString? {
      guard let specified = package else {
        return nil
      }
      let packageURL = StrictString(specified.absoluteString)

      var result = [
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ".", inline: true)
          .normalizedSource(),
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "package",
          inline: true
        ).normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: "(", inline: true)
          .normalizedSource(),
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "url",
          inline: true
        )
        .normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true)
          .normalizedSource(),
        " ",
        ElementSyntax(
          "span",
          attributes: ["class": "string"],
          contents: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "a",
              attributes: ["href": packageURL],
              contents: [
                ElementSyntax(
                  "span",
                  attributes: ["class": "text"],
                  contents: HTML.escapeTextForCharacterData(packageURL),
                  inline: true
                ).normalizedSource()
              ].joined(),
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
          ].joined(),
          inline: true
        ).normalizedSource(),
      ].joined()

      if let specified = specify(version: version) {
        result.append(
          contentsOf: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: ",",
              inline: true
            )
            .normalizedSource(),
            " ",
            specified,
          ].joined()
        )
      }

      result.append(
        contentsOf: ElementSyntax(
          "span",
          attributes: ["class": "punctuation"],
          contents: ")",
          inline: true
        )
        .normalizedSource()
      )

      return ElementSyntax(
        "span",
        attributes: ["class": "swift blockquote"],
        contents: result,
        inline: true
      )
      .normalizedSource()
    }

    private static func specify(version: Version?) -> StrictString? {
      guard let specified = version else {
        return nil
      }

      var result = [
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "from",
          inline: true
        ).normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true)
          .normalizedSource(),
        " ",
        ElementSyntax(
          "span",
          attributes: ["class": "string"],
          contents: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "text"],
              contents: StrictString(specified.string()),
              inline: true
            )
            .normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
          ].joined(),
          inline: true
        ).normalizedSource(),
      ].joined()

      if specified.major == 0 {
        result = [
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: ".",
            inline: true
          )
          .normalizedSource(),
          ElementSyntax(
            "span",
            attributes: ["class": "external identifier"],
            contents: "upToNextMinor",
            inline: true
          ).normalizedSource(),
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: "(",
            inline: true
          )
          .normalizedSource(),
          result,
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: ")",
            inline: true
          )
          .normalizedSource(),
        ].joined()
      }

      return result
    }

    private static func generateIndices(
      for package: PackageAPI,
      tools: PackageCLI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      installation: [LocalizationIdentifier: StrictString],
      importing: [LocalizationIdentifier: StrictString],
      relatedProjects: [LocalizationIdentifier: StrictString],
      about: [LocalizationIdentifier: StrictString],
      localizations: [LocalizationIdentifier]
    ) -> [LocalizationIdentifier: StrictString] {
      var result: [LocalizationIdentifier: StrictString] = [:]
      for localization in localizations {
        purgingAutoreleased {
          result[localization] = generateIndex(
            for: package,
            tools: tools,
            extensionStorage: extensionStorage,
            hasInstallation: installation[localization] ≠ nil,
            hasImporting: importing[localization] ≠ nil,
            hasRelatedProjects: relatedProjects[localization] ≠ nil,
            hasAbout: about[localization] ≠ nil,
            localization: localization
          )
        }
      }
      return result
    }

    private static func packageHeader(localization: LocalizationIdentifier) -> StrictString {
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Package"
        case .deutschDeutschland:
          return "Paket"
        }
      } else {
        return "Package"  // From “let ... = Package(...)”
      }
    }

    private static func generateIndex(
      for package: PackageAPI,
      tools: PackageCLI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      hasInstallation: Bool,
      hasImporting: Bool,
      hasRelatedProjects: Bool,
      hasAbout: Bool,
      localization: LocalizationIdentifier
    ) -> StrictString {
      var result: [StrictString] = []

      result.append(
        generateIndexSection(
          named: packageHeader(localization: localization),
          identifier: .package,
          contents: [
            ElementSyntax(
              "a",
              attributes: [
                "href":
                  "[*site root*]\(HTML.percentEncodeURLPath(extensionStorage[package.extendedPropertiesIndex, default: .default].relativePagePath[localization]!))"
              ],
              contents: HTML.escapeTextForCharacterData(
                StrictString(package.names.resolvedForNavigation)
              ),
              inline: false
            ).normalizedSource()
          ].joinedAsLines()
        )
      )

      if hasInstallation {
        result.append(
          generateLoneIndexEntry(
            named: installation(localization: localization),
            target: installationLocation(localization: localization)
          )
        )
      }
      if hasImporting {
        result.append(
          generateLoneIndexEntry(
            named: importing(localization: localization),
            target: importingLocation(localization: localization)
          )
        )
      }

      if ¬tools.commands.isEmpty {
        result.append(
          generateIndexSection(
            named: SymbolPage.toolsHeader(localization: localization),
            identifier: .tools,
            tools: tools,
            localization: localization
          )
        )
      }

      if ¬package.libraries.lazy
        .filter({ library in
          return localization
          ∉ extensionStorage[library.extendedPropertiesIndex, default: .default]
            .skippedLocalizations
        }).isEmpty
      {
        result.append(
          generateIndexSection(
            named: SymbolPage.librariesHeader(localization: localization),
            identifier: .libraries,
            apiEntries: package.libraries,
            localization: localization
          )
        )
      }
      if ¬package.modules.lazy.filter({ module in
        return localization
        ∉ extensionStorage[module.extendedPropertiesIndex, default: .default]
          .skippedLocalizations
      }).isEmpty {
        result.append(
          generateIndexSection(
            named: SymbolPage.modulesHeader(localization: localization),
            identifier: .modules,
            apiEntries: package.modules,
            localization: localization
          )
        )
      }
      let packageProperties = extensionStorage[package.extendedPropertiesIndex, default: .default]
      if ¬packageProperties.packageTypes.lazy.filter({ type in
          return localization
          ∉ extensionStorage[type.extendedPropertiesIndex, default: .default]
            .skippedLocalizations
          
        }).isEmpty
      {
        result.append(
          generateIndexSection(
            named: SymbolPage.typesHeader(localization: localization),
            identifier: .types,
            apiEntries: packageProperties.packageTypes,
            localization: localization
          )
        )
      }
      if ¬packageProperties.packageExtensions.isEmpty{
        result.append(
          generateIndexSection(
            named: SymbolPage.extensionsHeader(localization: localization),
            identifier: .extensions,
            apiEntries: packageProperties.packageExtensions,
            localization: localization
          )
        )
      }
      if ¬packageProperties.packageProtocols.lazy.filter({ `protocol` in
        return localization
        ∉ extensionStorage[`protocol`.extendedPropertiesIndex, default: .default]
          .skippedLocalizations
      }).isEmpty {
        result.append(
          generateIndexSection(
            named: SymbolPage.protocolsHeader(localization: localization),
            identifier: .protocols,
            apiEntries: packageProperties.packageProtocols,
            localization: localization
          )
        )
      }
      if ¬package.functions.lazy.filter({
        localization ∉ APIElement.function($0).skippedLocalizations
      }).isEmpty {
        result.append(
          generateIndexSection(
            named: SymbolPage.functionsHeader(localization: localization),
            identifier: .functions,
            apiEntries: package.functions.lazy.map({ APIElement.function($0) }),
            localization: localization
          )
        )
      }
      if ¬package.globalVariables
        .lazy.filter({ localization ∉ APIElement.variable($0).skippedLocalizations }).isEmpty
      {
        result.append(
          generateIndexSection(
            named: SymbolPage.variablesHeader(localization: localization),
            identifier: .variables,
            apiEntries: package.globalVariables.lazy.map({ APIElement.variable($0) }),
            localization: localization
          )
        )
      }
      if ¬package.operators
        .lazy.filter({ localization ∉ APIElement.operator($0).skippedLocalizations }).isEmpty
      {
        result.append(
          generateIndexSection(
            named: SymbolPage.operatorsHeader(localization: localization),
            identifier: .operators,
            apiEntries: package.operators.lazy.map({ APIElement.operator($0) }),
            localization: localization
          )
        )
      }
      if ¬package.precedenceGroups
        .lazy.filter({ localization ∉ APIElement.precedence($0).skippedLocalizations }).isEmpty
      {
        result.append(
          generateIndexSection(
            named: SymbolPage.precedenceGroupsHeader(localization: localization),
            identifier: .precedenceGroups,
            apiEntries: package.precedenceGroups.lazy.map({ APIElement.precedence($0) }),
            localization: localization
          )
        )
      }
      if hasRelatedProjects {
        result.append(
          generateLoneIndexEntry(
            named: relatedProjects(localization: localization),
            target: relatedProjectsLocation(localization: localization)
          )
        )
      }
      if hasAbout {
        result.append(
          generateLoneIndexEntry(
            named: about(localization: localization),
            target: aboutLocation(localization: localization)
          )
        )
      }

      return result.joinedAsLines()
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      apiEntries: [SymbolLike],
      localization: LocalizationIdentifier
    ) -> StrictString {
      var entries: [StrictString] = []
      for entry in apiEntries.lazy.filter({ $0.exists(in: localization) }) {
        entries.append(
          ElementSyntax(
            "a",
            attributes: [
              "href":
                "[*site root*]\(HTML.percentEncodeURLPath(entry.relativePagePath[localization]!))"
            ],
            contents: HTML.escapeTextForCharacterData(StrictString(entry.name.source())),
            inline: false
          ).normalizedSource()
        )
      }
      return generateIndexSection(
        named: name,
        identifier: identifier,
        contents: entries.joinedAsLines()
      )
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      tools: PackageCLI,
      localization: LocalizationIdentifier
    ) -> StrictString {
      var entries: [StrictString] = []
      for (_, entry) in tools.commands {
        if let interface = entry.interfaces[localization] {
          entries.append(
            ElementSyntax(
              "a",
              attributes: [
                "href":
                  "[*site root*]\(HTML.percentEncodeURLPath(entry.relativePagePath[localization]!))"
              ],
              contents: HTML.escapeTextForCharacterData(StrictString(interface.name)),
              inline: false
            ).normalizedSource()
          )
        }
      }
      return generateIndexSection(
        named: name,
        identifier: identifier,
        contents: entries.joinedAsLines()
      )
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      contents: StrictString
    ) -> StrictString {
      return ElementSyntax(
        "div",
        attributes: ["id": identifier.htmlIdentifier],
        contents: [
          ElementSyntax(
            "a",
            attributes: [
              "class": "heading",
              "onclick": "toggleIndexSectionVisibility(this)",
            ],
            contents: HTML.escapeTextForCharacterData(name),
            inline: true
          )
          .normalizedSource(),
          contents,
        ].joinedAsLines(),
        inline: false
      ).normalizedSource()
    }

    private static func generateLoneIndexEntry(
      named name: StrictString,
      target: StrictString
    ) -> StrictString {
      return ElementSyntax(
        "div",
        contents: ElementSyntax(
          "a",
          attributes: [
            "class": "heading",
            "href": "[*site root*]\(HTML.percentEncodeURLPath(target))",
          ],
          contents: HTML.escapeTextForCharacterData(name),
          inline: true
        )
        .normalizedSource(),
        inline: false
      ).normalizedSource()
    }

    private static func installation(localization: LocalizationIdentifier) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Installation"
      case .deutschDeutschland:
        return "Installierung"
      }
    }
    private static func installationLocation(localization: LocalizationIdentifier) -> StrictString {
      return "\(localization._directoryName)/\(installation(localization: localization)).html"
    }

    private static func importing(localization: LocalizationIdentifier) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Importing"
      case .deutschDeutschland:
        return "Einführung"
      }
    }
    private static func importingLocation(localization: LocalizationIdentifier) -> StrictString {
      return "\(localization._directoryName)/\(importing(localization: localization)).html"
    }

    private static func relatedProjects(localization: LocalizationIdentifier) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Related Projects"
      case .deutschDeutschland:
        return "Verwandte Projekte"
      }
    }
    private static func relatedProjectsLocation(localization: LocalizationIdentifier)
      -> StrictString
    {
      return "\(localization._directoryName)/\(relatedProjects(localization: localization)).html"
    }

    private static func about(localization: LocalizationIdentifier) -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "About"
      case .deutschDeutschland:
        return "Über"
      }
    }
    private static func aboutLocation(localization: LocalizationIdentifier) -> StrictString {
      return "\(localization._directoryName)/\(about(localization: localization)).html"
    }

    private static func generate(platforms: [StrictString]) -> StrictString {
      var result: [StrictString] = []
      for platform in platforms {
        result.append(
          ElementSyntax(
            "span",
            contents: HTML.escapeTextForCharacterData(platform),
            inline: false
          ).normalizedSource()
        )
      }
      return result.joinedAsLines()
    }

    // MARK: - Initialization

    internal init(
      localizations: [LocalizationIdentifier],
      developmentLocalization: LocalizationIdentifier,
      api: PackageAPI,
      cli: PackageCLI,
      packageURL: URL?,
      version: Version?,
      platforms: [LocalizationIdentifier: [StrictString]],
      installation: [LocalizationIdentifier: StrictString],
      importing: [LocalizationIdentifier: StrictString],
      relatedProjects: [LocalizationIdentifier: StrictString],
      about: [LocalizationIdentifier: StrictString],
      copyright: [LocalizationIdentifier?: StrictString],
      customReplacements: [(StrictString, StrictString)],
      output: Command.Output
    ) {

      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Processing API..."
          case .deutschDeutschland:
            return "Die Programmierschnitstelle wird verarbeitet ..."
          }
        }).resolved()
      )

      self.localizations = localizations
      self.developmentLocalization = developmentLocalization
      self.packageAPI = api
      self.api = APIElement.package(api)
      self.cli = cli
      api.computeMergedAPI()

      self.packageImport = PackageInterface.specify(package: packageURL, version: version)
      self.installation = installation
      self.importing = importing
      self.relatedProjects = relatedProjects
      self.about = about
      self.copyrightNotices = copyright

      self.packageIdentifiers = api.identifierList()

      APIElement.package(api).determine(
        localizations: localizations,
        customReplacements: customReplacements
      )
      var paths: [LocalizationIdentifier: [String: String]] = [:]
      for localization in localizations {
        paths[localization] = APIElement.package(api).determinePaths(
          for: localization,
          customReplacements: customReplacements
        )
      }
      APIElement.package(api).determineLocalizedPaths(localizations: localizations)
      self.symbolLinks = paths.mapValues { localization in
        localization.mapValues { link in
          return HTML.percentEncodeURLPath(link)
        }
      }

      self.indices = PackageInterface.generateIndices(
        for: api,
        tools: cli,
        installation: installation,
        importing: importing,
        relatedProjects: relatedProjects,
        about: about,
        localizations: localizations
      )
      self.platforms = platforms.mapValues { PackageInterface.generate(platforms: $0) }
    }

    // MARK: - Properties

    private let localizations: [LocalizationIdentifier]
    private let developmentLocalization: LocalizationIdentifier
    private let packageAPI: PackageAPI
    private let api: APIElement
    private let cli: PackageCLI
    private let packageImport: StrictString?
    private let indices: [LocalizationIdentifier: StrictString]
    private let platforms: [LocalizationIdentifier: StrictString]
    private let installation: [LocalizationIdentifier: Markdown]
    private let importing: [LocalizationIdentifier: Markdown]
    private let relatedProjects: [LocalizationIdentifier: Markdown]
    private let about: [LocalizationIdentifier: Markdown]
    private let copyrightNotices: [LocalizationIdentifier?: StrictString]
    private let packageIdentifiers: Set<String>
    private let symbolLinks: [LocalizationIdentifier: [String: String]]

    private func copyright(
      for localization: LocalizationIdentifier,
      status: DocumentationStatus
    ) -> StrictString {
      if let result = copyrightNotices[localization] {
        return result
      } else {
        status.reportMissingCopyright(localization: localization)
        return copyrightNotices[nil]!
      }
    }

    // MARK: - Output

    internal func outputHTML(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Generating HTML..."
          case .deutschDeutschland:
            return "Auszeichnung wird erstellt ..."
          }
        }).resolved()
      )

      try outputPackagePages(
        to: outputDirectory,
        customReplacements: customReplacements,
        status: status,
        output: output,
        coverageCheckOnly: coverageCheckOnly
      )
      try outputToolPages(
        to: outputDirectory,
        customReplacements: customReplacements,
        status: status,
        output: output,
        coverageCheckOnly: coverageCheckOnly
      )
      try outputLibraryPages(
        to: outputDirectory,
        customReplacements: customReplacements,
        status: status,
        output: output,
        coverageCheckOnly: coverageCheckOnly
      )
      try outputModulePages(
        to: outputDirectory,
        customReplacements: customReplacements,
        status: status,
        output: output,
        coverageCheckOnly: coverageCheckOnly
      )
      try outputTopLevelSymbols(
        to: outputDirectory,
        customReplacements: customReplacements,
        status: status,
        output: output,
        coverageCheckOnly: coverageCheckOnly
      )

      if coverageCheckOnly {
        return
      }

      try outputGeneralPage(
        to: outputDirectory,
        location: PackageInterface.installationLocation,
        title: PackageInterface.installation,
        content: installation,
        status: status,
        output: output
      )
      try outputGeneralPage(
        to: outputDirectory,
        location: PackageInterface.importingLocation,
        title: PackageInterface.importing,
        content: importing,
        status: status,
        output: output
      )
      try outputGeneralPage(
        to: outputDirectory,
        location: PackageInterface.relatedProjectsLocation,
        title: PackageInterface.relatedProjects,
        content: relatedProjects,
        status: status,
        output: output
      )
      try outputGeneralPage(
        to: outputDirectory,
        location: PackageInterface.aboutLocation,
        title: PackageInterface.about,
        content: about,
        status: status,
        output: output
      )

      try outputRedirects(to: outputDirectory, customReplacements: customReplacements)
    }

    private func outputPackagePages(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      for localization in localizations {
        try purgingAutoreleased {
          let pageURL = api.pageURL(
            in: outputDirectory,
            for: localization,
            customReplacements: customReplacements
          )
          try SymbolPage(
            localization: localization,
            allLocalizations: localizations,
            pathToSiteRoot: "../",
            navigationPath: [api],
            packageImport: packageImport,
            index: indices[localization]!,
            sectionIdentifier: .package,
            platforms: platforms[localization]!,
            symbol: api,
            package: packageAPI,
            tools: cli,
            copyright: copyright(for: localization, status: status),
            packageIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks[localization]!,
            status: status,
            output: output,
            coverageCheckOnly: coverageCheckOnly
          )?.contents.save(to: pageURL)
        }
      }
    }

    private func outputToolPages(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      if coverageCheckOnly {
        return
      }
      for localization in localizations {
        for tool in cli.commands.values {
          try purgingAutoreleased {
            let location = tool.pageURL(in: outputDirectory, for: localization)
            try CommandPage(
              localization: localization,
              allLocalizations: localizations,
              pathToSiteRoot: "../../",
              package: api,
              navigationPath: [tool],
              packageImport: packageImport,
              index: indices[localization]!,
              platforms: platforms[localization]!,
              command: tool,
              copyright: copyright(for: localization, status: status),
              customReplacements: customReplacements,
              output: output
            ).contents.save(to: location)

            try outputNestedCommands(
              of: tool,
              namespace: [tool],
              to: outputDirectory,
              localization: localization,
              customReplacements: customReplacements,
              status: status,
              output: output
            )
          }
        }
      }
    }

    private func outputLibraryPages(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      for localization in localizations {
        for library in api.libraries.lazy.map({ APIElement.library($0) })
        where library.exists(in: localization) {
          try purgingAutoreleased {
            let location = library.pageURL(
              in: outputDirectory,
              for: localization,
              customReplacements: customReplacements
            )
            try SymbolPage(
              localization: localization,
              allLocalizations: localizations,
              pathToSiteRoot: "../../",
              navigationPath: [api, library],
              packageImport: packageImport,
              index: indices[localization]!,
              sectionIdentifier: .libraries,
              platforms: platforms[localization]!,
              symbol: library,
              package: packageAPI,
              copyright: copyright(for: localization, status: status),
              packageIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks[localization]!,
              status: status,
              output: output,
              coverageCheckOnly: coverageCheckOnly
            )?.contents.save(to: location)
          }
        }
      }
    }

    private func outputModulePages(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      for localization in localizations {
        for module in api.modules.lazy.map({ APIElement.module($0) })
        where module.exists(in: localization) {
          try purgingAutoreleased {
            let location = module.pageURL(
              in: outputDirectory,
              for: localization,
              customReplacements: customReplacements
            )
            try SymbolPage(
              localization: localization,
              allLocalizations: localizations,
              pathToSiteRoot: "../../",
              navigationPath: [api, module],
              packageImport: packageImport,
              index: indices[localization]!,
              sectionIdentifier: .modules,
              platforms: platforms[localization]!,
              symbol: module,
              package: packageAPI,
              copyright: copyright(for: localization, status: status),
              packageIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks[localization]!,
              status: status,
              output: output,
              coverageCheckOnly: coverageCheckOnly
            )?.contents.save(to: location)
          }
        }
      }
    }

    private func outputTopLevelSymbols(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {
      for localization in localizations {
        for symbol in [
          packageAPI.types.map({ APIElement.type($0) }),
          packageAPI.uniqueExtensions.map({ APIElement.extension($0) }),
          packageAPI.protocols.map({ APIElement.protocol($0) }),
          packageAPI.functions.map({ APIElement.function($0) }),
          packageAPI.globalVariables.map({ APIElement.variable($0) }),
          packageAPI.operators.map({ APIElement.operator($0) }),
          packageAPI.precedenceGroups.map({ APIElement.precedence($0) }),
        ].joined()
        where symbol.exists(in: localization) {
          try purgingAutoreleased {
            let location = symbol.pageURL(
              in: outputDirectory,
              for: localization,
              customReplacements: customReplacements
            )
            let section: IndexSectionIdentifier
            switch symbol {
            case .package, .library, .module, .case, .initializer, .subscript, .conformance:
              unreachable()
            case .type:
              section = .types
            case .extension:
              section = .extensions
            case .protocol:
              section = .protocols
            case .function:
              section = .functions
            case .variable:
              section = .variables
            case .operator:
              section = .operators
            case .precedence:
              section = .precedenceGroups
            }
            try SymbolPage(
              localization: localization,
              allLocalizations: localizations,
              pathToSiteRoot: "../../",
              navigationPath: [api, symbol],
              packageImport: packageImport,
              index: indices[localization]!,
              sectionIdentifier: section,
              platforms: platforms[localization]!,
              symbol: symbol,
              package: packageAPI,
              copyright: copyright(for: localization, status: status),
              packageIdentifiers: packageIdentifiers,
              symbolLinks: symbolLinks[localization]!,
              status: status,
              output: output,
              coverageCheckOnly: coverageCheckOnly
            )?.contents.save(to: location)

            switch symbol {
            case .package, .library, .module, .case, .initializer, .variable, .subscript,
              .function, .operator, .precedence, .conformance:
              break
            case .extension:
              break  // Iterated separately below.
            case .type, .protocol:
              try outputNestedSymbols(
                of: symbol,
                namespace: [symbol],
                sectionIdentifier: section,
                to: outputDirectory,
                localization: localization,
                customReplacements: customReplacements,
                status: status,
                output: output,
                coverageCheckOnly: coverageCheckOnly
              )
            }
          }
        }

        for `extension` in packageAPI.allExtensions {
          let apiElement = APIElement.extension(`extension`)

          var namespace = apiElement
          var section: IndexSectionIdentifier = .extensions
          for type in packageAPI.types where `extension`.isExtension(of: type) {
            namespace = APIElement.type(type)
            section = .types
            break
          }
          if namespace == apiElement /* Still not resolved. */ {
            for `protocol` in packageAPI.protocols
            where `extension`.isExtension(of: `protocol`) {
              namespace = APIElement.protocol(`protocol`)
              section = .protocols
              break
            }
          }

          try outputNestedSymbols(
            of: apiElement,
            namespace: [namespace],
            sectionIdentifier: section,
            to: outputDirectory,
            localization: localization,
            customReplacements: customReplacements,
            status: status,
            output: output,
            coverageCheckOnly: coverageCheckOnly
          )
        }
      }
    }

    private func outputNestedSymbols(
      of parent: APIElement,
      namespace: [APIElement],
      sectionIdentifier: IndexSectionIdentifier,
      to outputDirectory: URL,
      localization: LocalizationIdentifier,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {

      for symbol in [parent.children, parent.localizedChildren].joined()
      where symbol.receivesPage ∧ symbol.exists(in: localization) {
        try purgingAutoreleased {
          let location = symbol.pageURL(
            in: outputDirectory,
            for: localization,
            customReplacements: customReplacements
          )

          var modifiedRoot: StrictString = "../../"
          for _ in namespace.indices {
            modifiedRoot += "../../".scalars
          }

          var navigation: [APIElement] = [api]
          navigation += namespace as [APIElement]
          navigation += [symbol]

          try SymbolPage(
            localization: localization,
            allLocalizations: localizations,
            pathToSiteRoot: modifiedRoot,
            navigationPath: navigation,
            packageImport: packageImport,
            index: indices[localization]!,
            sectionIdentifier: sectionIdentifier,
            platforms: platforms[localization]!,
            symbol: symbol,
            package: packageAPI,
            copyright: copyright(for: localization, status: status),
            packageIdentifiers: packageIdentifiers,
            symbolLinks: symbolLinks[localization]!,
            status: status,
            output: output,
            coverageCheckOnly: coverageCheckOnly
          )?.contents.save(to: location)

          switch symbol {
          case .package, .library, .module, .case, .initializer, .variable, .subscript,
            .function, .operator, .precedence, .conformance:
            break
          case .type, .protocol, .extension:
            try outputNestedSymbols(
              of: symbol,
              namespace: namespace + [symbol],
              sectionIdentifier: sectionIdentifier,
              to: outputDirectory,
              localization: localization,
              customReplacements: customReplacements,
              status: status,
              output: output,
              coverageCheckOnly: coverageCheckOnly
            )
          }
        }
      }
    }

    private func outputNestedCommands(
      of parent: CommandInterfaceInformation,
      namespace: [CommandInterfaceInformation],
      to outputDirectory: URL,
      localization: LocalizationIdentifier,
      customReplacements: [(StrictString, StrictString)],
      status: DocumentationStatus,
      output: Command.Output
    ) throws {

      for subcommand in parent.interfaces[localization]!.subcommands {
        try purgingAutoreleased {
          var information = CommandInterfaceInformation()
          information.interfaces[localization] = subcommand

          for otherLocalization in localizations {
            let localized = parent.interfaces[otherLocalization]!.subcommands.first(where: {
              $0.identifier == subcommand.identifier
            })!
            if otherLocalization ≠ localization {
              information.interfaces[otherLocalization] = localized
            }

            var nestedPagePath = parent.relativePagePath[otherLocalization]!
            nestedPagePath.removeLast(5)  // .html
            nestedPagePath += "/"
            nestedPagePath += CommandPage.subcommandsDirectoryName(for: otherLocalization)
            nestedPagePath += "/"
            nestedPagePath += Page.sanitize(
              fileName: localized.name,
              customReplacements: customReplacements
            )
            nestedPagePath += ".html"
            information.relativePagePath[otherLocalization] = nestedPagePath
          }

          let location = information.pageURL(in: outputDirectory, for: localization)

          var modifiedRoot: StrictString = "../../"
          for _ in namespace.indices {
            modifiedRoot += "../../".scalars
          }

          var navigation = namespace
          navigation.append(information)

          try CommandPage(
            localization: localization,
            allLocalizations: localizations,
            pathToSiteRoot: modifiedRoot,
            package: api,
            navigationPath: navigation,
            packageImport: packageImport,
            index: indices[localization]!,
            platforms: platforms[localization]!,
            command: information,
            copyright: copyright(for: localization, status: status),
            customReplacements: customReplacements,
            output: output
          ).contents.save(to: location)

          try outputNestedCommands(
            of: information,
            namespace: navigation,
            to: outputDirectory,
            localization: localization,
            customReplacements: customReplacements,
            status: status,
            output: output
          )
        }
      }
    }

    private func outputGeneralPage(
      to outputDirectory: URL,
      location: (LocalizationIdentifier) -> StrictString,
      title: (LocalizationIdentifier) -> StrictString,
      content: [LocalizationIdentifier: Markdown],
      status: DocumentationStatus,
      output: Command.Output
    ) throws {
      for localization in localizations {
        if let specifiedContent = content[localization] {
          let pathToSiteRoot: StrictString = "../"
          let pageTitle = title(localization)
          let pagePath = location(localization)

          // Parse via proxy Swift file.
          var documentationMarkup: StrictString = ""
          if ¬specifiedContent.isEmpty {
            documentationMarkup.append(contentsOf: StrictString("/// ...\n///\n"))
            documentationMarkup.append(
              contentsOf: specifiedContent.lines.lazy.map({ line in
                return "/// \(line.line)" as StrictString
              }).joined(separator: "\n")
            )
          }
          documentationMarkup.append(contentsOf: "\npublic func function() {}\n")
          let parsed = try SyntaxParser.parse(source: String(documentationMarkup))
          let documentation = parsed.api().first!.documentation.last?.documentationComment

          var pageContent = ""
          for paragraph in documentation?.discussionEntries ?? [] {  // @exempt(from: tests)
            pageContent.append("\n")
            pageContent.append(
              contentsOf: paragraph.renderedHTML(
                localization: localization.code,
                symbolLinks: symbolLinks[localization]!
                  .mapValues({ String(pathToSiteRoot) + $0 })
              )
            )
          }

          let page = Page(
            localization: localization,
            pathToSiteRoot: pathToSiteRoot,
            navigationPath: SymbolPage.generateNavigationPath(
              localization: localization,
              pathToSiteRoot: pathToSiteRoot,
              allLocalizations: localizations.lazy.filter({ content[$0] ≠ nil })
                .map({ localization in
                  return (localization: localization, path: location(localization))
                }),
              navigationPath: [
                (
                  label: StrictString(api.name.source()),
                  path: api.relativePagePath[localization]!
                ),
                (label: pageTitle, path: pagePath),
              ]
            ),
            packageImport: packageImport,
            index: indices[localization]!,
            sectionIdentifier: nil,
            platforms: platforms[localization]!,
            symbolImports: "",
            symbolType: nil,
            compilationConditions: nil,
            constraints: nil,
            title: HTML.escapeTextForCharacterData(pageTitle),
            content: StrictString(pageContent),
            extensions: "",
            copyright: copyright(for: localization, status: status)
          )
          let url = outputDirectory.appendingPathComponent(String(location(localization)))
          try page.contents.save(to: url)
        }
      }
    }

    private func outputRedirects(
      to outputDirectory: URL,
      customReplacements: [(StrictString, StrictString)]
    ) throws {
      // Out of directories.
      var handled = Set<URL>()
      for url in try FileManager.default.deepFileEnumeration(in: outputDirectory) {
        try purgingAutoreleased {
          var directory = url.deletingLastPathComponent()
          while directory ∉ handled,
            directory.is(in: outputDirectory)
          {
            defer {
              handled.insert(directory)
              directory = directory.deletingLastPathComponent()
            }

            let redirect = directory.appendingPathComponent("index.html")
            if (try? redirect.checkResourceIsReachable()) ≠ true {
              // Do not overwrite if there is a file name clash.
              try DocumentSyntax.redirect(
                language: LocalizationIdentifier.localization(of: url, in: outputDirectory),
                target: URL(fileURLWithPath: "../index.html")
              ).source().save(to: redirect)
            }
          }
        }
      }

      // To home page.
      let root = outputDirectory.appendingPathComponent("index.html")
      try DocumentSyntax.redirect(
        language: LocalizationIdentifier.localization(of: root, in: outputDirectory),
        target: URL(
          fileURLWithPath: String(developmentLocalization._directoryName) + "/index.html"
        )
      ).source().save(to: root)
      for localization in localizations {
        let localizationDirectory = outputDirectory.appendingPathComponent(
          String(localization._directoryName)
        )
        let redirectURL = localizationDirectory.appendingPathComponent("index.html")
        let pageURL = api.pageURL(
          in: outputDirectory,
          for: localization,
          customReplacements: customReplacements
        )
        if redirectURL ≠ pageURL {
          try DocumentSyntax.redirect(
            language: AnyLocalization(code: localization.code),
            target: URL(fileURLWithPath: pageURL.lastPathComponent)
          ).source().save(to: redirectURL)
        }
      }
    }
  }
#endif
