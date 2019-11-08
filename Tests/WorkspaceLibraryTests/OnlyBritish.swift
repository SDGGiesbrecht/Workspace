/*
 OnlyBritish.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralTestImports

public enum OnlyBritish: String, InputLocalization, Localization {

  // MARK: - Cases

  case englishUnitedKingdom = "en\u{2D}GB"

  // MARK: - Localization

  public static let fallbackLocalization = OnlyBritish.englishUnitedKingdom
}
