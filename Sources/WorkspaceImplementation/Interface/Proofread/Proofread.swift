/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

extension Workspace {
  internal enum Proofread {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "proofread"
      case .deutschDeutschland:
        return "korrekturlesen"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "proofreads the project’s source for style violations."
        case .deutschDeutschland:
          return "liest die Projektquellenstyl Korrektur."
        }
      })

    internal static let runAsXcodeBuildPhase = SDGCommandLine.Option(
      name: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "xcode"
        }
      }),
      description: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "behaves as an Xcode build phase."
        case .deutschDeutschland:
          return "verhält sich wie ein Xcode‐Erstellungsschritt."
        }
      }),
      type: ArgumentType.boolean
    )

    internal static let command = Command(
      name: name,
      description: description,
      directArguments: [],
      options: standardOptions + [runAsXcodeBuildPhase],
      execution: { (_: DirectArguments, options: Options, output: Command.Output) throws in
        var validationStatus = ValidationStatus()
        try executeAsStep(
          normalizingFirst: true,
          options: options,
          validationStatus: &validationStatus,
          output: output
        )

        if ¬options.runAsXcodeBuildPhase {  // Xcode should keep building anyway.
          // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
          #if !os(WASI)
            try validationStatus.reportOutcome(project: options.project, output: output)
          #endif
        }
      }
    )

    internal static func executeAsStep(
      normalizingFirst: Bool,
      options: Options,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) throws {

      // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
      #if !os(WASI)
        if try options.project.configuration(output: output).normalize {
          try Workspace.Normalize.executeAsStep(options: options, output: output)
        }
      #endif

      let section = validationStatus.newSection()

      if ¬options.runAsXcodeBuildPhase {
        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Proofreading source code..." + section.anchor
            case .deutschDeutschland:
              return "Quelltext Korrektur wird gelesen ..."
            }
          }).resolved().formattedAsSectionHeader()
        )
      }

      let reporter: ProofreadingReporter
      if options.runAsXcodeBuildPhase {
        reporter = XcodeProofreadingReporter.default
      } else {
        reporter = CommandLineProofreadingReporter.default
      }

      // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
      #if !os(WASI)
        if try options.project.proofread(reporter: reporter, output: output) {
          validationStatus.passStep(
            message: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Source code passes proofreading."
              case .deutschDeutschland:
                return "Quelltext besteht das Korrekturlesen."
              }
            })
          )
        } else {
          validationStatus.failStep(
            message: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Source code fails proofreading."
                  + section.crossReference.resolved(for: localization)
              case .deutschDeutschland:
                return "Der Quelltext besteht das Korrekturlesen nicht."
                  + section.crossReference.resolved(for: localization)
              }
            })
          )
        }
      #endif
    }
  }
}
