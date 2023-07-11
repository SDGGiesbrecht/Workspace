/*
 LibraryArticle.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SDGText

import SDGSwiftDocumentation

internal struct LibraryArticle {

  // MARK: - Initialization

  internal init(
    library: LibraryAPI,
    hostingBasePath: String
  ) {
    self.library = library
    self.hostingBasePath = hostingBasePath
  }

  // MARK: - Properties

  private let library: LibraryAPI
  private let hostingBasePath: String

  // MARK: - Output

  internal func article() -> Article {
    var content: [StrictString] = []
    if let documentation = library.documentation.last {
      content.append(documentation.documentationComment.source())
    }
    content.append(contentsOf: [
      "",
      "### Modules",
      "",
    ])
    for module in library.modules {
      let directory = DocumentationBundle.sanitize(title: StrictString(module.lowercased()))
      content.append("\u{2D} [`\(module)`](/\(hostingBasePath)/\(module)/documentation/\(directory))")
    }
    return Article(
      title: StrictString(library.names.title),
      content: content.joinedAsLines()
    )
  }
}
#endif
