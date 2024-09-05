/*
 PackageAPI.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
import Foundation

import SDGLogic

import SDGSwiftDocumentation
import SDGSwiftSource

extension PackageAPI {

  internal func validateCoverage(
    documentationStatus: DocumentationStatus,
    projectRoot: URL
  ) {
    let editableModules = modules.map { $0.names.title }
    validateCoverage(
      ofSymbol: self,
      documentationStatus: documentationStatus,
      projectRoot: projectRoot,
      editableModules: editableModules
    )
    for library in libraries {
      validateCoverage(
        ofSymbol: library,
        documentationStatus: documentationStatus,
        projectRoot: projectRoot,
        editableModules: editableModules
      )
    }
    for module in modules {
      validateCoverage(
        ofSymbol: module,
        documentationStatus: documentationStatus,
        projectRoot: projectRoot,
        editableModules: editableModules
      )
    }
    for graph in symbolGraphs() {
      for (_, symbol) in graph.graph.symbols
        .sorted(by: { ($0.value.names.title, $0.key) < ($1.value.names.title, $1.key) }) {
        validateCoverage(
          ofSymbol: symbol,
          documentationStatus: documentationStatus,
          projectRoot: projectRoot,
          editableModules: editableModules
        )
      }
    }
  }

  private func validateCoverage(
    ofSymbol symbol: SymbolLike,
    documentationStatus: DocumentationStatus,
    projectRoot: URL,
    editableModules: [String]
  ) {
    if symbol.docComment == nil,
      symbol.hasEditableDocumentation(editableModules: editableModules) {
        documentationStatus.reportMissingDescription(symbol: symbol, projectRoot: projectRoot)
    }
  }
}
#endif
