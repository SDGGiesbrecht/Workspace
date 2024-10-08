/*
 SymbolDocumentation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGSwiftDocumentation

  import SymbolKit

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  extension Array where Element == SymbolDocumentation {

    internal func resolved(
      localizations: [LocalizationIdentifier]
    ) -> (
      documentation: [LocalizationIdentifier: SymbolGraph.LineList],
      crossReference: StrictString?,
      skipped: Set<LocalizationIdentifier>
    ) {
      var result: [LocalizationIdentifier: SymbolGraph.LineList] = [:]
      var parent: StrictString?
      var skipped: Set<LocalizationIdentifier> = []

      for documentation in self {
        for comment in documentation.developerComments.lines {
          let content = String(StrictString(comment.text)).scalars
          for match in content.matches(
            for: InterfaceLocalization.localizationDeclaration
          ) {
            let identifier = match.declarationArgument()
            let localization = LocalizationIdentifier(String(identifier))
            result[localization] = documentation.documentationComment
          }
          for match in content.matches(
            for: InterfaceLocalization.crossReferenceDeclaration
          ) {
            parent = match.declarationArgument()
          }
          for match in content.matches(for: InterfaceLocalization.notLocalizedDeclaration) {
            let identifier = match.declarationArgument()
            let localization = LocalizationIdentifier(String(identifier))
            skipped.insert(localization)
          }
        }
      }

      if localizations.count == 1,
        let onlyLocalization = localizations.first,
        result.isEmpty /* No localization tags. */
      {
        result[onlyLocalization] = last?.documentationComment
      }

      return (result, parent, skipped)
    }
  }
#endif
