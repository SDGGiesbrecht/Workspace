/*
 ContentLocalization.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

public enum ContentLocalization: String, Codable, InputLocalization {

  // MARK: - Cases

  case englishUnitedKingdom = "en\u{2D}GB"
  case englishUnitedStates = "en\u{2D}US"
  case englishCanada = "en\u{2D}CA"

  case deutschDeutschland = "de\u{2D}DE"

  // MARK: - Localization

  public static let fallbackLocalization: ContentLocalization = .englishUnitedKingdom
}
