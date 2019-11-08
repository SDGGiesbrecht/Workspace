/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGExternalProcess

import SDGSwiftPackageManager
import SDGXcode

import WSValidation
import WSContinuousIntegration
import WSProofreading

extension PackageRepository {

  // MARK: - Testing

  public func build(
    for job: ContinuousIntegrationJob,
    validationStatus: inout ValidationStatus,
    output: Command.Output
  ) throws {

    let section = validationStatus.newSection()

    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Checking build for \(job.englishName)..." + section.anchor
        case .deutschDeutschland:
          return "Erstellung für \(job.deutscherName) wird geprüft ..." + section.anchor
        }
      }).resolved().formattedAsSectionHeader()
    )

    do {
      let buildCommand: (Command.Output) throws -> Bool
      switch job {
      case .macOS, .linux:
        buildCommand = { output in
          let log = try self.build(
            releaseConfiguration: false,
            staticallyLinkStandardLibrary: false,
            reportProgress: { output.print($0) }
          ).get()
          return ¬SwiftCompiler.warningsOccurred(during: log)
        }
      case .iOS, .watchOS, .tvOS:  // @exempt(from: tests) Unreachable from Linux.
        buildCommand = { output in
          let log = try self.build(
            for: job.buildSDK,
            reportProgress: { report in
              if let relevant = Xcode.abbreviate(output: report) {
                output.print(relevant)
              }
            }
          ).get()
          return ¬Xcode.warningsOccurred(during: log)
        }
      case .miscellaneous, .deployment:
        unreachable()
      }

      if try buildCommand(output) {
        validationStatus.passStep(
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "There are no compiler warnings for \(job.englishName)."
            case .deutschDeutschland:
              return "Es gibt keine Übersetzerwarnungen zu \(job.deutscherName)."
            }
          })
        )
      } else {
        validationStatus.failStep(
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "There are compiler warnings for \(job.englishName)."
                + section.crossReference.resolved(for: localization)
            case .deutschDeutschland:
              return "Es gibt Übersetzerwarnungen zu \(job.englishName)."
                + section.crossReference.resolved(for: localization)
            }
          })
        )
      }
    } catch {
      // @exempt(from: tests) Unreachable on Linux.
      var description = StrictString(error.localizedDescription)
      if let schemeError = error as? Xcode.SchemeError {
        switch schemeError {
        case .noPackageScheme:  // @exempt(from: tests)
          break
        case .xcodeError:  // @exempt(from: tests)
          description = ""  // Already printed.
        }
      }
      output.print(description.formattedAsError())

      validationStatus.failStep(
        message: UserFacing<
          StrictString,
          InterfaceLocalization
        >({ localization in  // @exempt(from: tests)
          switch localization {
          case .englishUnitedKingdom,
            .englishUnitedStates,
            .englishCanada:  // @exempt(from: tests)
            return "Build failed for \(job.englishName)."
              + section.crossReference.resolved(for: localization)
          case .deutschDeutschland:
            return "Erstellung für \(job.deutscherName) ist fehlgeschlagen."
              + section.crossReference.resolved(for: localization)
          }
        })
      )
    }
  }

  public func test(
    on job: ContinuousIntegrationJob,
    validationStatus: inout ValidationStatus,
    output: Command.Output
  ) throws {

    let section = validationStatus.newSection()

    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Testing on \(job.englishName)..." + section.anchor
        case .deutschDeutschland:
          return "Auf \(job.deutscherName) wird getestet ..." + section.anchor
        }
      }).resolved().formattedAsSectionHeader()
    )

    let testCommand: (Command.Output) -> Bool
    switch job {
    case .macOS, .linux:
      // @exempt(from: tests) Tested separately.
      testCommand = { output in
        do {
          _ = try self.test(reportProgress: { output.print($0) }).get()
          return true
        } catch {
          return false
        }
      }
    case .iOS, .watchOS, .tvOS:  // @exempt(from: tests) Unreachable from Linux.
      testCommand = { output in
        switch self.test(
          on: job.testSDK,
          derivedData: self.stableDerivedData,
          reportProgress: { report in
            if let relevant = Xcode.abbreviate(output: report) {
              output.print(relevant)
            }
          }
        )
        {
        case .failure(let error):
          var description = StrictString(error.localizedDescription)
          switch error {
          case .noPackageScheme:
            break
          case .xcodeError:
            description = ""  // Already printed.
          }
          output.print(description.formattedAsError())
          return false
        case .success:
          return true
        }
      }
    case .miscellaneous, .deployment:
      unreachable()
    }

    if testCommand(output) {
      validationStatus.passStep(
        message: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Tests pass on \(job.englishName)."
          case .deutschDeutschland:
            return "Teste werden auf \(job.deutscherName) bestanden."
          }
        })
      )
    } else {
      validationStatus.failStep(
        message: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Tests fail on \(job.englishName)."
              + section.crossReference.resolved(for: localization)
          case .deutschDeutschland:
            return "Teste werden auf \(job.deutscherName) nicht bestanden."
              + section.crossReference.resolved(for: localization)
          }
        })
      )
    }
  }

  public func validateCodeCoverage(
    on job: ContinuousIntegrationJob,
    validationStatus: inout ValidationStatus,
    output: Command.Output
  ) throws {

    let section = validationStatus.newSection()
    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Checking test coverage on \(job.englishName)..." + section.anchor
        case .deutschDeutschland:
          return "Testabdeckung auf \(job.deutscherName) wird geprüft ..."
        }
      }).resolved().formattedAsSectionHeader()
    )

    func failStepWithError(message: StrictString) {
      // @exempt(from: tests) Difficult to reach consistently.

      output.print(message.formattedAsError())

      validationStatus.failStep(
        message: UserFacing<
          StrictString,
          InterfaceLocalization
        >({ localization in  // @exempt(from: tests)
          switch localization {
          case .englishUnitedKingdom,
            .englishUnitedStates,
            .englishCanada:  // @exempt(from: tests)
            return "Test coverage could not be determined on \(job.englishName)."
              + section.crossReference.resolved(for: localization)
          case .deutschDeutschland:
            return
              "Testabdeckung auf \(job.englishName) konnte nicht verarbeitet werden."
              + section.crossReference.resolved(for: localization)
          }
        })
      )
    }

    do {
      let report: TestCoverageReport
      switch job {
      case .macOS, .linux:
        guard
          let fromPackageManager = try codeCoverageReport(
            ignoreCoveredRegions: true,
            reportProgress: { output.print($0) }
          ).get()
        else {  // @exempt(from: tests) Untestable in Xcode due to interference.
          failStepWithError(
            message: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return
                  "The package manager has not produced a test coverage report."
              case .deutschDeutschland:
                return
                  "Der Paketverwalter hat keinen Testabdeckungsbericht erstellt."
              }
            }).resolved()
          )
          return
        }
        report = fromPackageManager  // @exempt(from: tests)
      case .iOS, .watchOS, .tvOS:  // @exempt(from: tests) Unreachable from Linux.
        guard
          let fromXcode = try codeCoverageReport(
            on: job.testSDK,
            derivedData: stableDerivedData,
            ignoreCoveredRegions: true,
            reportProgress: { output.print($0) }
          ).get()
        else {
          failStepWithError(
            message: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Xcode has not produced a test coverage report."
              case .deutschDeutschland:
                return "Xcode erstellte keinen Testabdeckungsbericht erstellt."
              }
            }).resolved()
          )
          return
        }
        report = fromXcode
      case .miscellaneous, .deployment:
        unreachable()
      }

      var irrelevantFiles: Set<URL> = []
      for target in try package().get().targets {
        switch target.type {
        case .library, .systemModule:
          break  // Coverage matters.
        case .executable:
          // Not testable.
          for path in target.sources.paths {
            irrelevantFiles.insert(
              URL(fileURLWithPath: path.pathString).resolvingSymlinksInPath()
            )
          }
        case .test:
          // Coverage unimportant.
          for path in target.sources.paths {
            irrelevantFiles.insert(
              URL(fileURLWithPath: path.pathString).resolvingSymlinksInPath()
            )
          }
        }
      }
      let exemptPaths = try configuration(output: output).testing.exemptPaths.map({
        location.appendingPathComponent($0).resolvingSymlinksInPath()
      })

      let sameLineTokens = try configuration(output: output).testing.exemptionTokens.map {
        StrictString($0.token)
      }
      let previousLineTokens = try configuration(output: output).testing.exemptionTokens
        .filter({ $0.scope == .previousLine }).map { StrictString($0.token) }

      var passing = true
      files: for file in report.files {
        let resolved = file.file.resolvingSymlinksInPath()
        if resolved ∈ irrelevantFiles {
          continue files
        }
        for path in exemptPaths where resolved.is(in: path) {
          continue files
        }

        CommandLineProofreadingReporter.default.reportParsing(
          file: file.file.path(relativeTo: location),
          to: output
        )
        try autoreleasepool {
          let sourceFile = try String(from: file.file)
          regionLoop: for region in file.regions {
            let startLineIndex = region.region.lowerBound.line(in: sourceFile.lines)
            let startLine = sourceFile.lines[startLineIndex].line
            for token in sameLineTokens where startLine.contains(token.scalars) {
              continue regionLoop  // Ignore and move on.
            }
            let nextLineIndex = sourceFile.lines.index(after: startLineIndex)
            if nextLineIndex ≠ sourceFile.lines.endIndex {
              let nextLine = sourceFile.lines[nextLineIndex].line
              for token in previousLineTokens where nextLine.contains(token.scalars) {
                continue regionLoop  // Ignore and move on.
              }
            }
            // No ignore tokens.

            CommandLineProofreadingReporter.default.report(
              violation: region.region,
              in: sourceFile,
              to: output
            )
            passing = false
          }
        }
      }

      if passing {
        validationStatus.passStep(
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Test coverage is complete on \(job.englishName)."
            case .deutschDeutschland:
              return "Testabdeckung auf \(job.deutscherName) ist vollständig."
            }
          })
        )
      } else {
        validationStatus.failStep(
          message: UserFacing<
            StrictString,
            InterfaceLocalization
          >({ localization in  // @exempt(from: tests)
            switch localization {
            case .englishUnitedKingdom,
              .englishUnitedStates,
              .englishCanada:  // @exempt(from: tests)
              return "Test coverage is incomplete on \(job.englishName)."
                + section.crossReference.resolved(for: localization)
            case .deutschDeutschland:
              return "Testabdeckung auf \(job.deutscherName) ist unvollständig."
                + section.crossReference.resolved(for: localization)
            }
          })
        )
      }
    } catch {
      // @exempt(from: tests) Unreachable on Linux.
      failStepWithError(message: StrictString(error.localizedDescription))
    }
  }
}
