import Foundation

import SDGText

internal struct ModuleDocumentationBundle {

  // MARK: - Initialization

  internal init(
    embedPackageBundle: PackageDocumentationBundle?
  ) {
    self.embeddedPackageBundle = embedPackageBundle
  }

  // MARK: - Properties

  private let embeddedPackageBundle: PackageDocumentationBundle?

  // MARK: - Output

  internal func write(to outputDirectory: URL) throws {
    try embeddedPackageBundle?.write(to: outputDirectory)
    var articles: [StrictString: Article] = [:]
    #warning("Placeholder")
    articles["Placeholder.md"] = Article(title: "Placeholder", content: "Placeholder.")
    try DocumentationBundle(articles: articles).write(to: outputDirectory)
  }
}
