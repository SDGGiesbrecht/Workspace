/*
 ValidateTestCoverage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
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

  enum TestCoverage {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "test‐coverage"
      case .deutschDeutschland:
        return "testabdeckung"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return
            "validates test coverage, checking that every code path is reached by the project’s tests."
        case .deutschDeutschland:
          return "prüft die Testabdeckung, dass jede Quellweg durch Teste erreicht wird."
        }
      })

    static let command = Command(
      name: name,
      description: description,
      directArguments: [],
      options: Workspace.standardOptions + [ContinuousIntegrationJob.option],
      execution: { (_, options: Options, output: Command.Output) throws in

        #if !os(Linux)
          if try options.project.configuration(output: output).xcode.manage {
            try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
          }
        #endif

        try Build.validate(
          job: options.job,
          against: ContinuousIntegrationJob.coverageJobs,
          for: options.project,
          output: output
        )

        var validationStatus = ValidationStatus()

        try executeAsStep(
          options: options,
          validationStatus: &validationStatus,
          output: output
        )

        try validationStatus.reportOutcome(project: options.project, output: output)
      }
    )

    static func executeAsStep(
      options: Options,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) throws {

      for job in ContinuousIntegrationJob.allCases
      where try options.job.includes(job: job) ∧ (
        try Build.job(
          job,
          isRelevantTo: options.project,
          andAvailableJobs: ContinuousIntegrationJob.coverageJobs,
          output: output
        )
      ) {
        try autoreleasepool {

          if try options.project.configuration(output: output).continuousIntegration
            .skipSimulatorOutsideContinuousIntegration,
            options.job == nil,  // Not in continuous integration.
            job ∈ ContinuousIntegrationJob.simulatorJobs
          {
            // @exempt(from: tests) Tested separately.
            return  // and continue loop.
          }

          #if DEBUG
            if job ∈ ContinuousIntegrationJob.simulatorJobs,
              ProcessInfo.processInfo.environment["SIMULATOR_UNAVAILABLE_FOR_TESTING"]
                ≠ nil
            {  // Simulators are not available to all CI jobs and must be tested separately.
              return  // and continue loop.
            }
          #endif

          try options.project.test(
            on: job,
            validationStatus: &validationStatus,
            output: output
          )
          try options.project.validateCodeCoverage(
            on: job,
            validationStatus: &validationStatus,
            output: output
          )
        }
      }
    }
  }
}
