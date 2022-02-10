/*
 Dictionary.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension Dictionary where Key == LocalizationIdentifier {

  // @localization(🇩🇪DE)
  /// Greift auf den entsprechenden lokalisierten Wert zu.
  ///
  /// - Parameters:
  ///     - key: Die Lokalisation.
  // @localization(🇬🇧EN)
  /// Accesses the respective localised value.
  ///
  /// - Parameters:
  ///     - key: The localisation.
  // @localization(🇺🇸EN) @localization(🇨🇦EN)
  /// Accesses the respective localized value.
  ///
  /// - Parameters:
  ///     - key: The localization.
  public subscript<L>(_ key: L) -> Value? where L: Localization {
    get {
      return self[LocalizationIdentifier(key)]
    }
    set {
      self[LocalizationIdentifier(key)] = newValue
    }
  }
}
