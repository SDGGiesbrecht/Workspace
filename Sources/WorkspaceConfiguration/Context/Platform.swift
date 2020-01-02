/*
 Platform.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

import WSLocalizations

// @localization(🇩🇪DE) @crossReference(Platform)
/// Eine Schicht.
public typealias Schicht = Platform
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Platform)
/// A platform.
public enum Platform: String, Codable, CaseIterable {

  // MARK: - Cases

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// macOS.
  case macOS

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// Linux.
  case linux

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// iOS.
  case iOS

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// watchOS.
  case watchOS

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// tvOS.
  case tvOS

  // MARK: - Properties

  public func _isolatedName(for localization: ContentLocalization) -> StrictString {
    switch self {
    case .macOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "macOS"
      }
    case .linux:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Linux"
      }
    case .iOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "iOS"
      }
    case .watchOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "watchOS"
      }
    case .tvOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "tvOS"
      }
    }
  }
}
