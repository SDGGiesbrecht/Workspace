/*
 Document.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    private static let description
      = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "generates API documentation."
        case .deutschDeutschland:
          return "erstellt Dokumentation über die Programmierschnittstellen."
        }
      })

    private static let discussion
      = UserFacing<StrictString, InterfaceLocalization>({ localization in
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
            "By default, the generated documentation will be placed in a \(quotationMarks.0)docs\(quotationMarks.1) folder at the project root. The GitHub settings described in the following link can be adjusted to automatically host the documentation directly from the repository.",
            "",
            "https://help.github.com/articles/configuring\u{2D}a\u{2D}publishing\u{2D}source\u{2D}for\u{2D}github\u{2D}pages/#publishing\u{2D}your\u{2D}github\u{2D}pages\u{2D}site\u{2D}from\u{2D}a\u{2D}docs\u{2D}folder\u{2D}on\u{2D}your\u{2D}master\u{2D}branch",
            "",
            "(If you wish to avoid checking generated files into \(quotationMarks.0)master\(quotationMarks.1), see the documentation of the \(quotationMarks.0)encryptedTravisCIDeploymentKey\(quotationMarks.1) configuration option for a more advanced method.)"
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Die Dokumentation wird in einem „docs“‐Verzeichnis im Projektwurzel erstellt. Mit der unter dem folgenden Verweis beschriebenen GitHub‐Einstellungen, kann man die Dokumentation direkt vom Lager aus veröffentlichen.",
            "",
            "https://help.github.com/articles/configuring\u{2D}a\u{2D}publishing\u{2D}source\u{2D}for\u{2D}github\u{2D}pages/#publishing\u{2D}your\u{2D}github\u{2D}pages\u{2D}site\u{2D}from\u{2D}a\u{2D}docs\u{2D}folder\u{2D}on\u{2D}your\u{2D}master\u{2D}branch",
            "",
            "(Wenn Sie die erstellte Dateien nicht in „master“ eintragen wollen, siehen Sie die Dokumentation zu „verschlüsselterTravisCIVerteilungsSchlüssel“ für eine fortgeschrittene Methode.)"
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
                    "The package manifest does not define any products."
                  ].joinedAsLines()
                case .deutschDeutschland:
                  return [
                    "Nichts zu dokumentieren.",
                    "Die Paketenladeliste bestimmt keine Produkte."
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
