/*
 Document.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSValidation

import WSDocumentation

extension Workspace {
  enum Document {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "document"
      case .deutschDeutschland:
        return "dokumentieren"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "generates API documentation."
        case .deutschDeutschland:
          return "erstellt Dokumentation über die Programmierschnittstellen."
        }
      })

    private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          let quotationMarks: (StrictString, StrictString)
          switch localization {
          case .englishUnitedKingdom:
            quotationMarks = ("‘", "’")
          case .englishUnitedStates, .englishCanada:
            quotationMarks = ("“", "”")
          case .deutschDeutschland:
            unreachable()
          }
          return [
            "By default, the generated documentation will be placed in a \(quotationMarks.0)docs\(quotationMarks.1) folder at the project root. Projects on GitHub can instead activate the \(quotationMarks.0)serveFromGitHubPagesBranch\(quotationMarks.1) configuration setting to automatically host the documentation with GitHub Pages."
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Normaleweise wird die Dokumentation in einem „docs“‐Verzeichnis im Projektwurzel erstellt. Projekt auf GitHub können stattdessen die „durchGitHubSeitenVeröffentlichen“ konfigurationseinstellung einschalten, um die Dokumentation durch GitHub Seiten automatisch zu veröffentlichen."
          ].joinedAsLines()
        }
      })

    static let command = Command(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: [],
      options: standardOptions,
      execution: { (_, options: Options, output: Command.Output) throws in

        var validationStatus = ValidationStatus()
        let outputDirectory = options.project.defaultDocumentationDirectory
        try executeAsStep(
          outputDirectory: outputDirectory,
          options: options,
          validationStatus: &validationStatus,
          output: output
        )

        guard validationStatus.validatedSomething else {
          throw Command.Error(
            description:
              UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return [
                    "Nothing to document.",
                    "The package manifest does not define any products.",
                  ].joinedAsLines()
                case .deutschDeutschland:
                  return [
                    "Nichts zu dokumentieren.",
                    "Die Paketenladeliste bestimmt keine Produkte.",
                  ].joinedAsLines()
                }
              })
          )
        }
        try validationStatus.reportOutcome(project: options.project, output: output)
      }
    )

    static func executeAsStep(
      outputDirectory: URL,
      options: Options,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) throws {
      try options.project.document(
        outputDirectory: outputDirectory,
        validationStatus: &validationStatus,
        output: output
      )
    }
  }
}
