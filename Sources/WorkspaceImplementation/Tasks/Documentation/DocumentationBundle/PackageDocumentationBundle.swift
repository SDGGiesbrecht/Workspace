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

import WorkspaceConfiguration

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
    copyright: [LocalizationIdentifier?: StrictString],
    installation: [LocalizationIdentifier: Markdown],
    importing: [LocalizationIdentifier: Markdown],
    cli: PackageCLI,
    relatedProjects: [LocalizationIdentifier: Markdown],
    about: [LocalizationIdentifier: Markdown]
  ) {
    self.localizations = localizations
    self.developmentLocalization = developmentLocalization
    self.copyright = copyright
    self.installation = installation
    self.importing = importing
    self.cli = cli
    self.relatedProjects = relatedProjects
    self.about = about
  }

  // MARK: - Properties

  private let localizations: [LocalizationIdentifier]
  private let developmentLocalization: LocalizationIdentifier
  private let copyright: [LocalizationIdentifier?: StrictString]
  private let installation: [LocalizationIdentifier: Markdown]
  private let importing: [LocalizationIdentifier: Markdown]
  private let cli: PackageCLI
  private let relatedProjects: [LocalizationIdentifier: Markdown]
  private let about: [LocalizationIdentifier: Markdown]

  // MARK: - Ouput

  internal func write(to outputDirectory: URL) throws {
    var articles: [StrictString: Article] = [:]
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
    addCLIArticles(to: &articles)
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

  private func addCLIArticles(
    to articles: inout [StrictString: Article]
  ) {
    for localization in localizations {
      for tool in cli.commands.values {
        purgingAutoreleased {
          articles["\(tool.name).md"] = CommandArticle(
            localization: localization,
            navigationPath: [tool],
            command: tool
          ).article()

          addNestedCommandArticles(
            of: tool,
            namespace: [tool],
            to: &articles,
            localization: localization
          )
        }
      }
    }
  }

  private func addNestedCommandArticles(
    of parent: CommandInterface,
    namespace: [CommandInterface],
    to articles: inout [StrictString: Article],
    localization: LocalizationIdentifier
  ) {

    for subcommand in parent.subcommands {
      purgingAutoreleased {

        var navigation = namespace
        navigation.append(parent)

        let call = (navigation.appending(subcommand))
          .map({ $0.name })
          .joined(separator: " ")
        articles["\(call).md"] = CommandArticle(
          localization: localization,
          navigationPath: navigation,
          command: subcommand
        ).article()

        addNestedCommandArticles(
          of: subcommand,
          namespace: navigation,
          to: &articles,
          localization: localization
        )
      }
    }
  }

  private func addGeneralArticle(
    to articles: inout [StrictString: Article],
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
