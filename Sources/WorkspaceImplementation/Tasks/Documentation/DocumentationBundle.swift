import Foundation

import WorkspaceConfiguration

internal struct DocumentationBundle {

  // MARK: - Static Properties

  internal static let fileName: String = "Documentation.docc"

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
    try outputGeneralArticle(
      to: outputDirectory,
      location: DocumentationBundle.aboutLocation,
      title: DocumentationBundle.about,
      content: about
    )
  }

  internal func outputGeneralArticle(
    to outputDirectory: URL,
    location: (LocalizationIdentifier) -> StrictString,
    title: (LocalizationIdentifier) -> StrictString,
    content: [LocalizationIdentifier: Markdown]
  ) throws {
    for localization in localizations {
      if let specifiedContent = content[localization] {
        let article = Article(title: title(localization), content: specifiedContent)
        let url = outputDirectory.appendingPathComponent(String(location(localization)))
        try article.source.save(to: url)
      }
    }
  }
}
