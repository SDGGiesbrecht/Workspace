/*
 ValidateAll.swift

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
  import Foundation

  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import WorkspaceLocalizations
  import WorkspaceProjectConfiguration

  extension Workspace.Validate {

    internal enum All {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "all"
        case .deutschDeutschland:
          return "alles"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "performs all configured validation checks."
          case .deutschDeutschland:
            return "führt alle eingestellte Prüfungen aus."
          }
        })

      internal static let command = Command(
        name: name,
        description: description,
        directArguments: [],
        options: Workspace.standardOptions + [
          ContinuousIntegrationJob.option
        ],
        execution: { arguments, options, output in

          var validationStatus = ValidationStatus()

          if options.job == .deployment {
            try executeAsStep(
              validationStatus: &validationStatus,
              arguments: arguments,
              options: options,
              output: output
            )
          } else {
            try executeAsStep(
              validationStatus: &validationStatus,
              arguments: arguments,
              options: options,
              output: output
            )
          }
        }
      )

      internal static func executeAsStep(
        validationStatus: inout ValidationStatus,
        arguments: DirectArguments,
        options: Options,
        output: Command.Output
      ) throws {

        if ¬ProcessInfo.isInContinuousIntegration {
          // @exempt(from: tests)
          try Workspace.Refresh.All.executeAsStep(
            withArguments: arguments,
            options: options,
            output: output
          )
        }

        let projectName = try options.project.localizedIsolatedProjectName(output: output)
        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom:
              return "Validating ‘\(projectName)’..."
            case .englishUnitedStates, .englishCanada:
              return "Validating “\(projectName)”..."
            case .deutschDeutschland:
              return "„\(projectName)“ wird geprüft ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        // Proofread
        if options.job == .miscellaneous ∨ options.job == nil {
          try Workspace.Proofread.Proofread.executeAsStep(
            normalizingFirst: false,
            options: options,
            validationStatus: &validationStatus,
            output: output
          )
        }

        // Build
        if try options.project.configuration(output: output).testing.prohibitCompilerWarnings {
          try Workspace.Validate.Build.executeAsStep(
            options: options,
            validationStatus: &validationStatus,
            output: output
          )
        }

        #warning("Debugging...")
        return

        // Test
        if try options.project.configuration(output: output).testing.enforceCoverage {
          if let job = options.job,
            job ∉ ContinuousIntegrationJob.coverageJobs
          {
            // Coverage impossible to check.
            try Workspace.Test.executeAsStep(
              options: options,
              validationStatus: &validationStatus,
              output: output
            )
          } else {
            // Check coverage.
            try Workspace.Validate.TestCoverage.executeAsStep(
              options: options,
              validationStatus: &validationStatus,
              output: output
            )
          }
        } else {
          // Coverage irrelevant.
          try Workspace.Test.executeAsStep(
            options: options,
            validationStatus: &validationStatus,
            output: output
          )
        }

        // Document
        if options.job.includes(job: .miscellaneous) {
          if try ¬options.project.configuration(output: output).documentation.api.generate
            ∨ options.project.configuration(output: output).documentation.api
            .serveFromGitHubPagesBranch,
            try options.project.configuration(output: output).documentation.api
              .enforceCoverage
          {
            try Workspace.Validate.DocumentationCoverage.executeAsStep(
              options: options,
              validationStatus: &validationStatus,
              output: output
            )
          } else if try options.project.configuration(output: output).documentation.api
            .generate
          {
            try Workspace.Document.executeAsStep(
              outputDirectory: options.project.defaultDocumentationDirectory,
              options: options,
              validationStatus: &validationStatus,
              output: output
            )
          }
        }

        if options.job.includes(job: .deployment),
          try options.project.configuration(output: output).documentation.api.generate
        {
          try Workspace.Document.executeAsStep(
            outputDirectory: options.project.defaultDocumentationDirectory,
            options: options,
            validationStatus: &validationStatus,
            output: output
          )
        }

        // Custom
        for task in try options.project.configuration(output: output).customValidationTasks {
          let state = validationStatus.newSection()
          output.print(
            UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom:
                return "Executing custom validation: ‘\(task.executable)’..."
                  + state.anchor
              case .englishUnitedStates, .englishCanada:
                return "Executing custom validation: “\(task.executable)”..."
                  + state.anchor
              case .deutschDeutschland:
                return "Sonderprüfung wird ausgeführt: „\(task.executable)“ ..."
                  + state.anchor
              }
            }).resolved().formattedAsSectionHeader()
          )
          do {
            try task.execute(output: output)
            validationStatus.passStep(
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom:
                  return "Custom validation passes: ‘\(task.executable)’"
                case .englishUnitedStates, .englishCanada:
                  return "Custom validation passes: “\(task.executable)”"
                case .deutschDeutschland:
                  return "Sonderprüfung wurde bestanden: “\(task.executable)”"
                }
              })
            )
          } catch {
            validationStatus.failStep(
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom:
                  return "Custom validation fails: ‘\(task.executable)’"
                    + state.crossReference.resolved(for: localization)
                case .englishUnitedStates, .englishCanada:
                  return "Custom validation fails: “\(task.executable)”"
                    + state.crossReference.resolved(for: localization)
                case .deutschDeutschland:
                  return "Sonderprüfung wurde nicht bestanden: “\(task.executable)”"
                    + state.crossReference.resolved(for: localization)
                }
              })
            )
          }
        }

        // State
        if ProcessInfo.isInContinuousIntegration
          ∧ ProcessInfo.isPullRequest  // @exempt(from: tests)
          ∧ ¬_isDuringSpecificationTest  // @exempt(from: tests)
        {
          // @exempt(from: tests) Only reachable during pull request.

          let state = validationStatus.newSection()

          output.print(
            UserFacing<
              StrictString,
              InterfaceLocalization
            >({ localization in  // @exempt(from: tests)
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Validating project state..." + state.anchor
              case .deutschDeutschland:
                return "Projektstand wird geprüft ..." + state.anchor
              }
            }).resolved().formattedAsSectionHeader()
          )

          let difference = try options.project.uncommittedChanges().get()
          if ¬difference.isEmpty {
            output.print(difference.separated())

            validationStatus.failStep(
              message: UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return
                    "The project is out of date. Please validate before committing."
                    + state.crossReference.resolved(for: localization)
                case .deutschDeutschland:
                  return "Das Projektstand ist veraltet. Bitte prüfen vor übergeben."
                    + state.crossReference.resolved(for: localization)
                }
              })
            )
          } else {
            validationStatus.passStep(
              message: UserFacing({ localization in  // @exempt(from: tests)
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return "The project is up to date."
                case .deutschDeutschland:
                  return "Das Projekt ist auf dem neuesten Stand."
                }
              })
            )
          }
        }

        output.print("Summary".formattedAsSectionHeader())

        // Workspace
        if ¬_isDuringSpecificationTest,
          let update = try Workspace.CheckForUpdates.checkForUpdates(output: output)
        {
          // @exempt(from: tests) Determined externally.
          output.print(
            UserFacing<
              StrictString,
              InterfaceLocalization
            >({ localization in  // @exempt(from: tests)
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return [
                  "This validation used Workspace \(Metadata.latestStableVersion.string()), which is no longer up to date.",
                  "\(update.string()) is available.",
                ].joinedAsLines()
              case .deutschDeutschland:
                return [
                  "Diese Prüfung hat Abreitsbereich \(Metadata.latestStableVersion.string()) verwendet, das nicht auf dem neuesten Stand ist.",
                  "\(update.string()) ist erhältlich.",
                ].joinedAsLines()
              }
            }).resolved().formattedAsWarning().separated()
          )
        }

        try validationStatus.reportOutcome(project: options.project, output: output)
      }
    }
  }

  internal var _isDuringSpecificationTest: Bool = false
#endif
