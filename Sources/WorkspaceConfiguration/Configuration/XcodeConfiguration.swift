/*
 XcodeConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(XcodeConfiguration)
/// Einstellungen zu Xcode.
public typealias XcodeEinstellungen = XcodeConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(XcodeConfiguration)
/// Options related to Xcode.
public struct XcodeConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(XcodeConfiguration.manage)
  /// Whether or not to manage the Xcode project.
  ///
  /// This is off by default, but some tasks may throw errors if they require a compatible Xcode project and none is present.
  ///
  /// ```shell
  /// $ workspace refresh xcode
  /// ```
  ///
  /// An Xcode project can be managed manually instead, but it must correspond with the Package manifest. Where a customized Xcode project is needed, it is recommended to start with an automatically generated one and adjust it from there.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(XcodeConfiguration.manage)
  /// Ob Arbeitsbereich das Xcode‐Projekt verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus, aber manche Aufgaben können Fehler werfen wenn es kein passendes Xcode‐Projekt gibt.
  ///
  /// ```shell
  /// $ arbeitsbereich auffrischen xcode
  /// ```
  ///
  /// Ein Xcode‐Projekt kann auch von Hand verwaltet werden, aber es muss mit der Paketenladeliste übereinstimmen. Wenn ein maßgefertigtes Xcode‐Projekt benötigt ist, ist es empfohlen, mit einem automatisch erstellten anzufangen, un von dem Stand aus anzupassen.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }
}
