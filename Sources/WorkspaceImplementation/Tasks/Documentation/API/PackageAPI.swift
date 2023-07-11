/*
 PackageAPI.swift

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
import SDGSwiftDocumentation

extension PackageAPI {

  internal func validateCoverage(documentationStatus: DocumentationStatus) {
    for graph in symbolGraphs() {
      for (_, symbol) in graph.graph.symbols {
        validateCoverage(ofSymbol: symbol, documentationStatus: documentationStatus)
      }
    }
  }

  private func validateCoverage(ofSymbol symbol: SymbolLike, documentationStatus: DocumentationStatus) {
    if let documentation = symbol.docComment {
    } else {
      #warning("Not implemented yet.")
      //documentationStatus.reportMissingDescription(symbol: symbol, navigationPath: <#T##[SymbolLike]#>, projectRoot: <#T##URL#>, localization: <#T##LocalizationIdentifier#>)
    }
  }
}
#endif
