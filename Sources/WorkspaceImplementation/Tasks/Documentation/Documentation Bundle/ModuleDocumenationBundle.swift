/*
 ModuleDocumenationBundle.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import OrderedCollections
import SDGText

import SDGSwiftDocumentation

import WorkspaceConfiguration

internal struct ModuleDocumentationBundle {

  // MARK: - Initialization

  internal init(
    developmentLocalization: LocalizationIdentifier,
    copyright: [LocalizationIdentifier?: StrictString],
    module: ModuleAPI,
    embedPackageBundle: PackageDocumentationBundle?
  ) {
    self.developmentLocalization = developmentLocalization
    self.copyright = copyright
    self.module = module
    self.embeddedPackageBundle = embedPackageBundle
  }

  // MARK: - Properties

  private let developmentLocalization: LocalizationIdentifier
  private let copyright: [LocalizationIdentifier?: StrictString]
  private let module: ModuleAPI
  private let embeddedPackageBundle: PackageDocumentationBundle?

  // MARK: - Output

  internal func write(to outputDirectory: URL) throws {
    try embeddedPackageBundle?.write(to: outputDirectory)
    var articles: OrderedDictionary<StrictString, Article> = [:]

    addLandingPage(to: &articles)

    try DocumentationBundle(
      developmentLocalization: developmentLocalization,
      copyright: copyright,
      articles: articles
    ).write(to: outputDirectory)
  }

  private func addLandingPage(to articles: inout OrderedDictionary<StrictString, Article>) {
    let name = StrictString(module.names.title)
    var content: [StrictString] = [
      module.documentation.last?.documentationComment.source() ?? "",
    ]
    articles["\(name).md"] = Article(
      title: "``\(name)``",
      content: content.joinedAsLines()
    )
  }
}
