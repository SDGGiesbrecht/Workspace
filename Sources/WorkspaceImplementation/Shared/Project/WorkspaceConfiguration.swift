/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGLocalization

import WorkspaceLocalizations
import WorkspaceConfiguration

extension WorkspaceConfiguration {

  internal func developmentInterfaceLocalization() -> InterfaceLocalization {
    let configuredLocalization = documentation.localizations
      .first.flatMap { InterfaceLocalization(reasonableMatchFor: $0.code) }
    return configuredLocalization ?? InterfaceLocalization.fallbackLocalization
  }

  internal var localizationsOrSystemFallback: [LocalizationIdentifier] {
    return documentation._localizationsOrSystemFallback
  }

  internal static func configurationLink(for localization: InterfaceLocalization) -> StrictString {
    let path: StrictString
    switch localization {
    case .englishUnitedKingdom:
      path = "🇬🇧EN/Types/WorkspaceConfiguration"
    case .englishUnitedStates:
      path = "🇺🇸EN/Types/WorkspaceConfiguration"
    case .englishCanada:
      path = "🇨🇦EN/Types/WorkspaceConfiguration"
    case .deutschDeutschland:
      path = "🇩🇪DE/Typen/ArbeitsbereichKonfiguration"
    }
    return "https://sdggiesbrecht.github.io/Workspace/\(path).html"
  }

  internal static func configurationRecommendation(
    for property: StrictString,
    localization: InterfaceLocalization
  ) -> StrictString {
    let link = configurationLink(for: localization)
    switch localization {
    case .englishUnitedKingdom:
      return "(Configure it under ‘\(property)’. See \(link).)"
    case .englishUnitedStates, .englishCanada:
      return "(Configure it under “\(property)”. See \(link).)"
    case .deutschDeutschland:
      return "(Es ist unter „\(property)“ zu konfigurieren. Siehe \(link))"
    }
  }
}
