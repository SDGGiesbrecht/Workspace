/*
 GitConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(GitConfiguration)
/// Einstellungen zu Git.
public typealias GitEinstellungen = GitConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(GitConfiguration)
/// Options related to Git.
public struct GitConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(GitConfiguration.manage)
  /// Whether or not to manage the project’s Git configuration files.
  ///
  /// This is off by default.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(GitConfiguration.manage)
  /// Ob Arbeitsbereich die Git‐Konfigurationsdateien des Projekts verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(GitConfiguration.additionalGitIgnoreEntries)
  /// Additional entries to append to the standard gitignore file.
  public var additionalGitIgnoreEntries: [String] = []
  // @localization(🇩🇪DE) @crossReference(GitConfiguration.additionalGitIgnoreEntries)
  /// Weitere Einträge, die Arbeitsbereich zu der Standard‐Git‐Übergehen‐Datei.
  public var weitereEinträgeZuGitÜbergehen: [Zeichenkette] {
    get { return additionalGitIgnoreEntries }
    set { additionalGitIgnoreEntries = newValue }
  }
}
