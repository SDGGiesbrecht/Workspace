/*
 Output.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
import SDGText

import SDGCommandLine

import SDGSwift

extension Command.Output {

    internal func succeed(message: StrictString, project: PackageRepository) throws {
      try listWarnings(for: project)
      print(message.formattedAsSuccess().separated())
    }

    internal func listWarnings(for project: PackageRepository) throws {
      if let noLocalizationSpecified = PackageRepository.localizationFallbackWarning() {
        print(noLocalizationSpecified.formattedAsWarning().separated())
      }
      if let unsupportedFiles = try FileType.unsupportedTypesWarning(for: project, output: self) {
        print(unsupportedFiles.formattedAsWarning().separated())
      }
    }
}
#endif
