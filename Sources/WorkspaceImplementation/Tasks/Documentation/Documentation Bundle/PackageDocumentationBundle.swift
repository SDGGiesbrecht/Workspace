/*
 PackageDocumentationBundle.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

import OrderedCollections

import WorkspaceConfiguration

import SDGSwiftDocumentation
import SDGExportedCommandLineInterface

internal struct PackageDocumentationBundle {

  // MARK: - Static Properties

  internal static func placeholderSymbolGraphFileName(packageName: StrictString) -> StrictString {
    return "\(packageName).symbols.graph"
  }
  internal static func placeholderSymbolGraphData(packageName: StrictString) -> Data {
    return [
      "{",
      "  \u{22}metadata\u{22}: {",
      "    \u{22}formatVersion\u{22}: {",
      "      \u{22}major\u{22}:0,",
      "      \u{22}minor\u{22}:5,",
      "      \u{22}patch\u{22}:3",
      "    },",
      "    \u{22}generator\u{22}: \u{22}Workspace\u{22}",
      "  },",
      "  \u{22}module\u{22}: {",
      "    \u{22}name\u{22}: \u{22}\(packageName)\u{22},",
      "    \u{22}platform\u{22}: {",
      "      \u{22}architecture\u{22}: \u{22}x86_64\u{22},",
      "      \u{22}vendor\u{22}:\u{22}apple\u{22},",
      "      \u{22}operatingSystem\u{22}: {",
      "        \u{22}name\u{22}: \u{22}macosx\u{22},",
      "        \u{22}minimumVersion\u{22}: {",
      "          \u{22}major\u{22}:10,",
      "          \u{22}minor\u{22}:0,",
      "          \u{22}patch\u{22}:0",
      "        }",
      "      }",
      "    }",
      "  },",
      "  \u{22}symbols\u{22}: [],",
      "  \u{22}relationships\u{22}:[]",
      "}",
    ].joined().data(using: .utf8)!
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
    return "\(localization._directoryName)/\(installation(localization: localization)).md"
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
    return "\(localization._directoryName)/\(importing(localization: localization)).md"
  }

  private static func commandLineTools(localization: LocalizationIdentifier) -> StrictString {
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Command Line Tools"
    case .deutschDeutschland:
      return "Befehlszeilenprogramme"
    }
  }
  private static func toolsLocation(localization: LocalizationIdentifier) -> StrictString {
    return "\(localization._directoryName)/\(commandLineTools(localization: localization)).md"
  }

  private static func subcommands(localization: LocalizationIdentifier) -> StrictString {
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Subcommands"
    case .deutschDeutschland:
      return "Unterbefehle"
    }
  }

  internal static func libraries(localization: LocalizationIdentifier) -> StrictString {
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
  private static func librariesLocation(localization: LocalizationIdentifier) -> StrictString {
    return "\(localization._directoryName)/\(libraries(localization: localization)).md"
  }

  internal static func modules(localization: LocalizationIdentifier) -> StrictString {
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
  private static func modulesLocation(localization: LocalizationIdentifier) -> StrictString {
    return "\(localization._directoryName)/\(libraries(localization: localization)).md"
  }

  private static func relatedProjects(localization: LocalizationIdentifier) -> StrictString {
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Related Projects"
    case .deutschDeutschland:
      return "Verwandte Projekte"
    }
  }
  private static func relatedProjectsLocation(
    localization: LocalizationIdentifier
  )-> StrictString {
    return "\(localization._directoryName)/\(relatedProjects(localization: localization)).md"
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
    return "\(localization._directoryName)/\(about(localization: localization)).md"
  }

  // MARK: - Initialization

  internal init(
    localizations: [LocalizationIdentifier],
    developmentLocalization: LocalizationIdentifier,
    docCBundleName: StrictString,
    copyright: [LocalizationIdentifier?: StrictString],
    installation: [LocalizationIdentifier: Markdown],
    importing: [LocalizationIdentifier: Markdown],
    api: PackageAPI,
    cli: PackageCLI,
    relatedProjects: [LocalizationIdentifier: Markdown],
    about: [LocalizationIdentifier: Markdown]
  ) {
    self.localizations = localizations
    self.developmentLocalization = developmentLocalization
    self.docCBundleName = docCBundleName
    self.copyright = copyright
    self.installation = installation
    self.importing = importing
    self.api = api
    self.cli = cli
    self.relatedProjects = relatedProjects
    self.about = about
  }

  // MARK: - Properties

  private let localizations: [LocalizationIdentifier]
  private let developmentLocalization: LocalizationIdentifier
  private let docCBundleName: StrictString
  private let copyright: [LocalizationIdentifier?: StrictString]
  private let installation: [LocalizationIdentifier: Markdown]
  private let importing: [LocalizationIdentifier: Markdown]
  private let api: PackageAPI
  private let cli: PackageCLI
  private let relatedProjects: [LocalizationIdentifier: Markdown]
  private let about: [LocalizationIdentifier: Markdown]

  // MARK: - Ouput

  internal func write(to outputDirectory: URL) throws {
    var articles: OrderedDictionary<StrictString, Article> = [:]
    addLandingPage(to: &articles)
    addCLIArticles(to: &articles)
    addGeneralArticle(
      to: &articles,
      location: PackageDocumentationBundle.installationLocation,
      title: PackageDocumentationBundle.installation,
      content: installation
    )
    addGeneralArticle(
      to: &articles,
      location: PackageDocumentationBundle.importingLocation,
      title: PackageDocumentationBundle.importing,
      content: importing
    )
    addGeneralArticle(
      to: &articles,
      location: PackageDocumentationBundle.relatedProjectsLocation,
      title: PackageDocumentationBundle.relatedProjects,
      content: relatedProjects
    )
    addGeneralArticle(
      to: &articles,
      location: PackageDocumentationBundle.aboutLocation,
      title: PackageDocumentationBundle.about,
      content: about
    )
    try DocumentationBundle(
      developmentLocalization: developmentLocalization,
      copyright: copyright,
      articles: articles
    ).write(to: outputDirectory)
  }

  private func addLandingPage(to articles: inout OrderedDictionary<StrictString, Article>) {
    var repeated: Set<StrictString> = []
    var content: [StrictString] = [
      api.documentation.last?.documentationComment.source() ?? "",
      "",
    ]

    var topics: [StrictString] = []

    for localization in localizations {
      var entries: [StrictString] = []
      if installation[localization] ≠ nil {
        let link = DocumentationBundle.link(toArticle: PackageDocumentationBundle.installation(localization: localization))
        if repeated.insert(link).inserted {
          entries.append(link)
        }
      }
      if importing[localization] ≠ nil {
        let link = DocumentationBundle.link(toArticle: PackageDocumentationBundle.importing(localization: localization))
        if repeated.insert(link).inserted {
          entries.append(link)
        }
      }
      if ¬cli.commands.isEmpty {
        let link = DocumentationBundle.link(toArticle: PackageDocumentationBundle.commandLineTools(localization: localization))
        if repeated.insert(link).inserted {
          entries.append(link)
        }
      }
      if relatedProjects[localization] ≠ nil {
        let link = DocumentationBundle.link(toArticle: PackageDocumentationBundle.relatedProjects(localization: localization))
        if repeated.insert(link).inserted {
          entries.append(link)
        }
      }
      if about[localization] ≠ nil {
        let link = DocumentationBundle.link(toArticle: PackageDocumentationBundle.about(localization: localization))
        if repeated.insert(link).inserted {
          entries.append(link)
        }
      }
      if ¬entries.isEmpty {
        if localizations.count > 1 {
          topics.append("### \(localization._iconOrCode)")
        } else {
          topics.append("### Package")
        }
        topics.append("")
        topics.append(contentsOf: entries)
        topics.append("")
      }
    }
    if ¬topics.isEmpty {
      content.append(
        contentsOf: [
          "## Topics",
          "",
        ] + topics
      )
    }

    articles["\(docCBundleName).md"] = Article(
      title: "``\(docCBundleName)``",
      content: content.joinedAsLines()
    )
  }

  private func addCLIArticles(
    to articles: inout OrderedDictionary<StrictString, Article>
  ) {
    if ¬cli.commands.isEmpty {
      for localization in localizations {
        let commandLineTools = PackageDocumentationBundle.commandLineTools(localization: localization)
        var index: [StrictString] = []
        var subcommandIndex: [StrictString: StrictString] = [:]
        for tool in cli.commands.values {
          purgingAutoreleased {
            let localized = tool.interfaces[localization]!
            index.append(DocumentationBundle.link(toArticle: CommandArticle.title(for: localized, in: [])))

            articles["\(localization._iconOrCode)/\(commandLineTools)/\(localized.name).md"] = CommandArticle(
              localization: localization,
              navigationPath: [],
              command: localized
            ).article()
            
            addSubcommandArticles(
              of: localized,
              namespace: [],
              to: &articles,
              index: &subcommandIndex,
              localization: localization
            )
          }
        }
        var indexArticle: [StrictString] = [
          "## Topics",
          "",
          "### \(commandLineTools)",
          "",
        ]
        indexArticle.append(contentsOf: index)
        if ¬subcommandIndex.isEmpty {
          indexArticle.append(contentsOf: [
            "",
            "### \(PackageDocumentationBundle.subcommands(localization: localization))",
            "",
          ])
          for index in subcommandIndex.keys.sorted() {
            indexArticle.append(subcommandIndex[index]!)
          }
        }
        articles["\(localization._iconOrCode)/\(commandLineTools).md"] = Article(
          title: commandLineTools,
          content: indexArticle.joinedAsLines()
        )
      }
    }
  }

  private func toolsDirectory(for localization: LocalizationIdentifier) -> StrictString {
    return "\(localization._iconOrCode)/Tools"
  }

  private func addSubcommandArticles(
    of parent: CommandInterface,
    namespace: [CommandInterface],
    to articles: inout OrderedDictionary<StrictString, Article>,
    index: inout [StrictString: StrictString],
    localization: LocalizationIdentifier
  ) {

    for subcommand in parent.subcommands {
      purgingAutoreleased {

        var navigation = namespace
        navigation.append(parent)

        let call = (navigation.appending(subcommand))
          .map({ $0.name })
          .joined(separator: " ")
        articles["\(localization._iconOrCode)/\(PackageDocumentationBundle.commandLineTools(localization: localization))/\(call).md"] = CommandArticle(
          localization: localization,
          navigationPath: navigation,
          command: subcommand
        ).article()
        let indexTitle = CommandArticle.title(for: subcommand, in: navigation)
        index[indexTitle] = DocumentationBundle.link(toArticle: indexTitle)

        addSubcommandArticles(
          of: subcommand,
          namespace: navigation,
          to: &articles,
          index: &index,
          localization: localization
        )
      }
    }
  }

  private func addGeneralArticle(
    to articles: inout OrderedDictionary<StrictString, Article>,
    location: (LocalizationIdentifier) -> StrictString,
    title: (LocalizationIdentifier) -> StrictString,
    content: [LocalizationIdentifier: Markdown]
  ) {
    for localization in localizations {
      if let specifiedContent = content[localization] {
        let article = Article(title: title(localization), content: specifiedContent)
        articles[location(localization)] = article
      }
    }
  }
}
