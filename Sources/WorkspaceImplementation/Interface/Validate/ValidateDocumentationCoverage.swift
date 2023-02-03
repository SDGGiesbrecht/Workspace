/*
 ValidateDocumentationCoverage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import WorkspaceLocalizations

  extension Workspace.Validate {

    internal enum DocumentationCoverage {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "documentation‐coverage"
        case .deutschDeutschland:
          return "dokumentationsabdeckung"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              "validates documentation coverage, checking that every public symbol in every library product is documented."
          case .deutschDeutschland:
            return
              "prüft die Dokumentationsabdeckung, dass jedes öffentliche Symbol von jede Biblioteksprodukt dokumentiert ist."
          }
        })

      internal static let command = Command(
        name: name,
        description: description,
        directArguments: [],
        options: Workspace.standardOptions,
        execution: { (_, options: Options, output: Command.Output) throws in

          var validationStatus = ValidationStatus()
          try executeAsStep(
            options: options,
            validationStatus: &validationStatus,
            output: output
          )

          if ¬validationStatus.validatedSomething {
            validationStatus.passStep(
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return "No library products to document."
                case .deutschDeutschland:
                  return "Keine Biblioteksprodukte zum Dokumentieren."
                }
              })
            )
          }

          try validationStatus.reportOutcome(project: options.project, output: output)
        }
      )

      internal static func executeAsStep(
        options: Options,
        validationStatus: inout ValidationStatus,
        output: Command.Output
      ) throws {
        try options.project.validateDocumentationCoverage(
          validationStatus: &validationStatus,
          output: output
        )
      }
    }
  }
#endif
