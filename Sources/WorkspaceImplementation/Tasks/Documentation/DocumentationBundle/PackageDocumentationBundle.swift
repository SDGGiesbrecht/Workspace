import WorkspaceConfiguration

internal struct PackageDocumentationBundle {

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

  // MARK: - Static Properties

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
    about: [LocalizationIdentifier: Markdown]
  ) {
    self.localizations = localizations
    self.about = about
  }

  // MARK: - Properties

  private let localizations: [LocalizationIdentifier]
  private let about: [LocalizationIdentifier: Markdown]

  // MARK: - Ouput

  internal func write(to outputDirectory: URL) throws {
    var articles: [StrictString: Article] = [:]
    addGeneralArticle(to: &articles, location: PackageDocumentationBundle.aboutLocation, title: PackageDocumentationBundle.about, content: about)
    try DocumentationBundle(articles: articles).write(to: outputDirectory)
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
