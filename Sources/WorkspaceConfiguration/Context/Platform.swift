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
public enum Platform: String, Codable, CaseIterable, OrderedEnumeration {

  // MARK: - Cases

  // These are sorted (and iterated) by date.

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// macOS.
  case macOS  // 1976‐04‐11 (Apple Computer)

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// Windows.
  case windows  // 1981‐08‐12 (MS‐DOS)

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Platform.web)
  /// Web (through WebAssembly).
  case web  // 1991‐08‐06
  // @localization(🇩🇪DE) @crossReference(Platform.web)
  /// Netz (durch WebAssembly).
  public static var netz: Platform {
    return web
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// Linux.
  case linux  // 1991‐09‐17

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// tvOS.
  case tvOS  // 2007‐01‐09 (Apple TV Software)

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// iOS.
  case iOS  // 2007‐06‐29

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// Android.
  case android  // 2008‐09‐23

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
  /// watchOS.
  case watchOS  // 2015‐04‐24

  // MARK: - Properties

  public func _isolatedName(for localization: ContentLocalization) -> StrictString {
    switch self {
    case .macOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "macOS"
      }
    case .windows:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Windows"
      }
    case .web:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Web"
      case .deutschDeutschland:
        return "Netz"
      }
    case .linux:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Linux"
      }
    case .tvOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "tvOS"
      }
    case .iOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "iOS"
      }
    case .android:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Android"
      }
    case .watchOS:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "watchOS"
      }
    }
  }
}
