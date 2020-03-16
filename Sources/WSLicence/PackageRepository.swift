/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

extension PackageRepository {

  public func refreshLicence(output: Command.Output) throws {

    guard let licence = try configuration(output: output).licence.licence else {
      throw Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishCanada:
            return "No licence has been selected. (licence.licence)"
          case .englishUnitedStates:
            return "No license has been selected. (license.license)"
          case .deutschDeutschland:
            return "Keine Lizenz wurde ausgewählt. (lizenz.lizenz)"
          }
        })
      )
    }

    var text = licence.text

    var file = try TextFile(possiblyAt: location.appendingPathComponent("LICENSE.md"))
    let oldContents = file.contents

    let copyright = WSProject.copyright(fromText: oldContents)
    let projectName = try self.projectName(
      in: LocalizationIdentifier(InterfaceLocalization.englishUnitedStates.code),
      output: output
    )
    var authors: StrictString = "the \(projectName) project contributors"
    if let configuredAuthor = try configuration(output: output).documentation.primaryAuthor {
      authors = configuredAuthor + " and " + authors
    }

    text.scalars.replaceMatches(for: "#copyright".scalars, with: copyright)
    text.scalars.replaceMatches(for: "#authors".scalars, with: authors)

    file.contents = String(text)
    try file.writeChanges(for: self, output: output)

    // Delete alternate licence files to prevent duplicates.
    delete(location.appendingPathComponent("LICENSE.txt"), output: output)
  }
}
