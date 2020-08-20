/*
 ValidateBuild.swift

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
import SDGCollections
import WSGeneralImports

import WSProject
import WSValidation
import WSContinuousIntegration

extension Workspace.Validate {

  internal enum Build {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "build"
      case .deutschDeutschland:
        return "erstellung"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "validates the build, checking that it triggers no compiler warnings."
        case .deutschDeutschland:
          return "prüft die Erstellung, dass keine Übersetzungswarnungen auftreten."
        }
      })

    internal static let command = Command(
      name: name,
      description: description,
      directArguments: [],
      options: Workspace.standardOptions + [ContinuousIntegrationJob.option],
      execution: { (_, options: Options, output: Command.Output) throws in

        // #workaround(Swift 5.2.4, Web lacks Foundation.)
        #if !os(WASI)
          try validate(
            job: options.job,
            against: ContinuousIntegrationJob.buildJobs,
            for: options.project,
            output: output
          )

          #if !os(Linux)
            if try options.project.configuration(output: output).xcode.manage {
              try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
            }
          #endif
        #endif

        var validationStatus = ValidationStatus()

        try executeAsStep(
          options: options,
          validationStatus: &validationStatus,
          output: output
        )

        // #workaround(Swift 5.2.4, Web lacks Foundation.)
        #if !os(WASI)
          try validationStatus.reportOutcome(project: options.project, output: output)
        #endif
      }
    )

    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    #if !os(WASI)
      internal static func job(
        _ job: ContinuousIntegrationJob,
        isRelevantTo project: PackageRepository,
        andAvailableJobs validJobs: Set<ContinuousIntegrationJob>,
        output: Command.Output
      ) throws -> Bool {
        return try job ∈ validJobs
          ∧ ((try job.isRequired(by: project, output: output))
            ∧ job.platform == Platform.current)
      }

      internal static func validate(
        job: ContinuousIntegrationJob?,
        against validJobs: Set<ContinuousIntegrationJob>,
        for project: PackageRepository,
        output: Command.Output
      ) throws {
        if let specified = job,
          ¬(try Build.job(
            specified,
            isRelevantTo: project,
            andAvailableJobs: validJobs,
            output: output
          ))
        {
          throw Command.Error(
            description: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Invalid job."
              case .deutschDeutschland:
                return "Ungültige Aufgabe."
              }
            })
          )
        }
      }
    #endif

    internal static func executeAsStep(
      options: Options,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) throws {

      // #workaround(Swift 5.2.4, Web lacks Foundation.)
      #if !os(WASI)
        for job in ContinuousIntegrationJob.allCases
        where try options.job.includes(job: job)
          ∧ (try Build.job(
            job,
            isRelevantTo: options.project,
            andAvailableJobs: ContinuousIntegrationJob.buildJobs,
            output: output
          ))
        {
          purgingAutoreleased {

            options.project.build(
              for: job,
              validationStatus: &validationStatus,
              output: output
            )
          }
        }
      #endif
    }
  }
}
