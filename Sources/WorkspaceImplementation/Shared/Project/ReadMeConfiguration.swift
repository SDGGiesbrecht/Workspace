/*
 ReadMeConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceLocalizations
import WorkspaceConfiguration

extension ReadMeConfiguration {

  private static let documentationDirectoryName = "Documentation"
  private static func documentationDirectory(for project: URL) -> URL {
    return project.appendingPathComponent(documentationDirectoryName)
  }

  private static func locationOfDocumentationFile(
    named name: StrictString,
    for localization: LocalizationIdentifier,
    in project: URL
  ) -> URL {
    let icon = ContentLocalization.icon(for: localization.code) ?? "[\(localization.code)]"
    let fileName: StrictString = icon + " " + name + ".md"
    return documentationDirectory(for: project).appendingPathComponent(String(fileName))
  }

  internal static func readMeLocation(
    for project: URL,
    localization: LocalizationIdentifier
  ) -> URL {
    let name: StrictString
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      name = "Read Me"
    case .deutschDeutschland:
      name = "Lies mich"
    }
    return locationOfDocumentationFile(named: name, for: localization, in: project)
  }

  internal static func relatedProjectsLocation(
    for project: URL,
    localization: LocalizationIdentifier
  ) -> URL {
    let name: StrictString
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      name = "Related Projects"
    case .deutschDeutschland:
      name = "Verwandte Projekte"
    }
    return locationOfDocumentationFile(named: name, for: localization, in: project)
  }
}
