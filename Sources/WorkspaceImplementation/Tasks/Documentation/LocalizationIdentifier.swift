/*
 LocalizationIdentifier.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import WorkspaceLocalizations
import WorkspaceConfiguration

extension LocalizationIdentifier {

  internal var textDirection: TextDirection? {
    guard let supported = ContentLocalization(reasonableMatchFor: code) else {
      return nil
    }
    return supported.textDirection
  }

    internal static func localization(of file: URL, in outputDirectory: URL) -> AnyLocalization {
      let localizationDirectory = String(
        file.path(relativeTo: outputDirectory)
          .prefix(upTo: "/")?.contents ?? ""
      )
      let identifier = LocalizationIdentifier(localizationDirectory)
      if identifier.icon ≠ nil {
        return AnyLocalization(code: identifier.code)
      } else {
        return AnyLocalization(code: "und")
      }
    }
}
