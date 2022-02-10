/*
 RepositoryConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceLocalizations

// @localization(🇩🇪DE) @crossReference(RepositoryConfiguration)
/// Einstellungen zum Lager.
public typealias Lagerseinstellungen = RepositoryConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(RepositoryConfiguration)
/// Options related to the project repository.
public struct RepositoryConfiguration: Codable {

  // @localization(🇩🇪DE) @crossReference(RepositoryConfiguration.ignoredFileTypes)
  /// Eine Menge von Dateinamenserweiterungen, die Quellverarbeitung übergehen soll.
  ///
  /// Diese Erweiterungen werden keine Vorspänne bekommen, und werden nicht Korrektur gelesen.
  ///
  /// Arbeitsbereich übergeht automatisch Dateiarten, die es nicht versteht, aber es zeigt dafür Warnungen. Diese Warnungen können abgedämpft werden, in dem die Dateiart zu dieser Liste zugefügt wird. Für Standardarten, die mit Swift‐Projekte zu tun haben, bitte [Unterstützung beantragen](https://github.com/SDGGiesbrecht/Workspace/issues).
  public var übergegangeneDateiarten: Menge<Zeichenkette> {
    get { return ignoredFileTypes }
    set { ignoredFileTypes = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(RepositoryConfiguration.ignoredFileTypes)
  /// A set of file extensions which source operations should ignore.
  ///
  /// These will not receive headers or be proofread.
  ///
  /// Workspace automatically skips files it does not understand, but it prints a warning first. These warnings can be silenced by adding the file type to this list. For standard file types related to Swift projects, please [request that support be added](https://github.com/SDGGiesbrecht/Workspace/issues).
  public var ignoredFileTypes: Set<String> = [
    "04",
    "cfg",
    "cmake",
    "dsidx",
    "DS_Store",
    "dtrace",
    "entitlements",
    "gyb",
    "gz",
    "icns",
    "in",
    "inc",
    "llbuild",
    "LLVM",
    "modulemap",
    "ninja",
    "nojekyll",
    "pep8",
    "pc",
    "pdf",
    "plist",
    "pins",
    "png",
    "resolved",
    "svg",
    "swift\u{2D}build",
    "testspec",
    "tgz",
    "txt",
    "TXT",
    "xcconfig",
    "xcsettings",
    "xcworkspacedata",
  ]

  public static func _refreshScriptMacOSFileName(
    localization: InterfaceLocalization
  ) -> StrictString {
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Refresh (macOS).command"
    case .deutschDeutschland:
      return "Auffrischen (macOS).command"
    }
  }
  public static func _refreshScriptLinuxFileName(
    localization: InterfaceLocalization
  ) -> StrictString {
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Refresh (Linux).sh"
    case .deutschDeutschland:
      return "Auffrischen (Linux).sh"
    }
  }

  // @localization(🇩🇪DE) @crossReference(RepositoryConfiguration.ignoredPaths)
  /// Pfade, die Quellverarbeitung übergehen soll.
  ///
  /// Files in these paths will not receive headers or be proofread.
  ///
  /// The paths must be specified relative to the package root.
  public var übergegangenePfade: Menge<Zeichenkette> {
    get { return ignoredPaths }
    set { ignoredPaths = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(RepositoryConfiguration.ignoredPaths)
  /// Paths which source operations should ignore.
  ///
  /// Dateien unter diesen Pfaden werden keine Vorspänne bekommen, und werden nicht Korrektur gelesen.
  ///
  /// Die Pfade sind vom Paketenwurzel ausgehend.
  public var ignoredPaths: Set<String> = {
    var paths: Set<String> = [
      "docs"
    ]
    for localization in InterfaceLocalization.allCases {
      paths.insert(
        String(RepositoryConfiguration._refreshScriptMacOSFileName(localization: localization))
      )
      paths.insert(
        String(RepositoryConfiguration._refreshScriptLinuxFileName(localization: localization))
      )
    }
    return paths
  }()
}
