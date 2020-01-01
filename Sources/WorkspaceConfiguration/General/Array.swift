/*
 Array.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension Array where Element: StringFamily {

  // @localization(🇩🇪DE) @crossReference(Array.joinedAsLines())
  /// Verbindet ein Feld von Zeichenketten, damit jeder Eintrag des Felds zu eine Zeile der Zeichenkette wird.
  public func verbundenAlsZeile() -> Element {
    return joinedAsLines()
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Array.joinedAsLines())
  /// Joins an array of strings so that each entry in the array is a line of the string.
  public func joinedAsLines() -> Element {
    return joined(separator: "\n" as Element)
  }
}
