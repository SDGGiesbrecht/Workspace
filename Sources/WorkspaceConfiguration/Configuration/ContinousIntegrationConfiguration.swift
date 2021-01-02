/*
 ContinousIntegrationConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(ContinuousIntegrationConfiguration)
/// Einstellungen zu fortlaufenden Einbindung.
public typealias EinstellungenFortlaufenderEinbindung = ContinuousIntegrationConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ContinuousIntegrationConfiguration)
/// Options related to continuous integration.
public struct ContinuousIntegrationConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ContinuousIntegrationConfiguration.manage)
  /// Whether or not to manage continuous integration.
  ///
  /// This is off by default.
  ///
  /// ```shell
  /// $ workspace refresh continuous‐integration
  /// ```
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(ContinuousIntegrationConfiguration.manage)
  /// Ob Arbeitsbereich fortlaufende Einbindung verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  ///
  /// ```shell
  /// $ arbeitsbereich auffrischen fortlaufende‐einbindung
  /// ```
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ContinuousIntegrationConfiguration.skipSimulatorOutsideContinuousIntegration)
  /// Whether or not to skip simulator tasks when running them locally.
  ///
  /// This is off by default.
  ///
  /// Because booting and switching the simulator often takes longer than all the other tasks combined, this option is available to skip actions requiring the simulator. It can save a lot of time for projects where there are very few differences between the macOS tests and those of the other Apple platforms.
  ///
  /// **This option only takes effect when running locally. Workspace still performs all tasks during continuous integration.**
  public var skipSimulatorOutsideContinuousIntegration: Bool = false
  // @localization(🇩🇪DE)
  // @crossReference(ContinuousIntegrationConfiguration.skipSimulatorOutsideContinuousIntegration)
  /// Ob Simulatoraufgaben übersprungen werden soll, wenn Arbeitsbereich auf einem lokalen Gerät läuft.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  ///
  /// Weil das Hochfahren oder Umschalten des Simulators oft länger dauert als alle andere Aufgaben zusammen, diese Einstellung ist vorhanden um Simulatoraufgaben zu überspringen. Für Projekte mit wenige unterschiede zwischen macOS und den anderen Schichten von Apple kann es viel Zeit sparen.
  ///
  /// **Diese Einstellung tretet nur in Kraft auf einem lokalen Gerät. Arbeitsbereich führt immer noch alle Aufgaben während fortlaufenden Einbindung aus.**
  public var auserhalbFortlaufenderEinbindungSimulatorÜberspringen: Bool {
    get { return skipSimulatorOutsideContinuousIntegration }
    set { skipSimulatorOutsideContinuousIntegration = newValue }
  }
}
