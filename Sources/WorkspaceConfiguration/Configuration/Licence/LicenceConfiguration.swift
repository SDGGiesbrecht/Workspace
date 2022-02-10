/*
 LicenceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(LicenceConfiguration)
/// Einstellungen zur Lizenz.
///
/// ```shell
/// $ arbeitsbereich auffrischen lizenz
/// ```
public typealias Lizenzeinstellungen = LicenceConfiguration
// @localization(🇺🇸EN) @crossReference(LicenceConfiguration)
/// Options related to licensing.
///
/// ```shell
/// $ workspace refresh license
/// ```
public typealias LicenseConfiguration = LicenceConfiguration
// @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(LicenceConfiguration)
/// Options related to licencing.
///
/// ```shell
/// $ workspace refresh licence
/// ```
public struct LicenceConfiguration: Codable {

  // @localization(🇺🇸EN)
  /// Whether or not to manage the project license.
  ///
  /// This is off by default.
  // @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(LicenceConfiguration.manage)
  /// Whether or not to manage the project licence.
  ///
  /// This is off by default.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(LicenceConfiguration.manage)
  /// Ob Arbeitsbereich das Projektlizenz verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(LicenceConfiguration.licence)
  /// The project licence.
  public var licence: Licence?
  // @localization(🇺🇸EN) @crossReference(LicenceConfiguration.licence)
  /// The project license.
  public var license: License? {
    get { return licence }
    set { licence = newValue }
  }
  // @localization(🇩🇪DE) @crossReference(LicenceConfiguration.licence)
  /// Die Projektlizenz.
  public var lizenz: Lizenz? {
    get { return licence }
    set { licence = newValue }
  }
}
