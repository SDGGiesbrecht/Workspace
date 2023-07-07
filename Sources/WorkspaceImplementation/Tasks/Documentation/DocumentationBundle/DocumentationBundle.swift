import Foundation

import SDGText

internal struct DocumentationBundle {

  // MARK: - Initialization

  internal init(
    articles: [StrictString: Article]
  ) {
    self.articles = articles
  }

  // MARK: - Properties

  private let articles: [StrictString: Article]

  // MARK: - Output

  internal func write(to outputDirectory: URL) throws {
    for (path, article) in articles {
      let url = outputDirectory.appendingPathComponent(String(path))
      try article.source.save(to: url)
    }
  }
}
