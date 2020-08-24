/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceLocalizations
import WorkspaceConfiguration

extension WorkspaceConfiguration {

  internal func developmentInterfaceLocalization() -> InterfaceLocalization {
    let configuredLocalization = documentation.localizations
      .first.flatMap { InterfaceLocalization(reasonableMatchFor: $0.code) }
    return configuredLocalization ?? InterfaceLocalization.fallbackLocalization
  }
}
