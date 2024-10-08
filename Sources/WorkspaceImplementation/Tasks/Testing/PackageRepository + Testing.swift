/*
 PackageRepository + Testing.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization
  import SDGExternalProcess

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftPackageManager
  import SDGXcode

  import WorkspaceLocalizations

  extension PackageRepository {

    // MARK: - Testing

    internal func build(
      for job: ContinuousIntegrationJob,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) {
      PackageRepository.with(environment: job.environmentVariable) {
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
          case .macOS, .ubuntu, .amazonLinux:
            buildCommand = { output in
              var log = try self.build(
                releaseConfiguration: false,
                reportProgress: { output.print($0) }
              ).get()

              let filtered = log.lines.filter { line in
                return
                  ¬(
                  // #workaround(Swift 5.8, Currently thrown by SwiftPM, losing its origin in a dependency.)
                  line.line.contains(
                    "maybe pkg\u{2D}config is not installed".scalars.literal()
                  )
                  ∨ line.line.contains(
                    "warning: couldn\u{27}t find pc file for sqlite3".scalars.literal()
                  )
                  )
              }
              log.lines = LineView<String>(filtered)

              return ¬SwiftCompiler.warningsOccurred(during: log)
            }
          case .windows, .web, .android, .miscellaneous, .deployment:
            unreachable()
          case .tvOS, .iOS, .watchOS:  // @exempt(from: tests) Unreachable from Linux.
            buildCommand = { output in
              var log = try self.build(
                for: job.buildPlatform,
                reportProgress: { report in
                  if let relevant = Xcode.abbreviate(output: report) {
                    output.print(relevant)
                  }
                }
              ).get()

              let filtered = log.components(separatedBy: "\n").filter { line in
                return
                  ¬(
                  // #workaround(SDGSwift 13.0.1, Toolchain’s fault and irrelevant, since tests only need to support the development environment.)
                  line.scalars.contains(
                    "/XCTest) was built for newer watchOS version".scalars.literal()
                  ) ∨ line.scalars.contains(
                    "libXCTestSwiftSupport.dylib) was built for newer watchOS version".scalars.literal()
                  )
                  // #workaround(Swift 5.8, Currently thrown by SwiftPM, losing its origin in a dependency.)
                  ∨ line.scalars.contains(
                    "warning: couldn\u{27}t find pc file for sqlite3".scalars.literal()
                  )
                  )
              }
              log = filtered.joined(separator: "\n")

              return ¬Xcode.warningsOccurred(during: log)
            }
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
            case .xcodeError:  // @exempt(from: tests)
              description = ""  // Already printed.
            case .foundationError, .noPackageScheme:  // @exempt(from: tests)
              break
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
    }

    @discardableResult internal func test(
      on job: ContinuousIntegrationJob,
      loadingCoverage: Bool,
      validationStatus: inout ValidationStatus,
      output: Command.Output
    ) -> TestCoverageReport? {
      PackageRepository.with(environment: job.environmentVariable) {
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

        let testCommand: (Command.Output) -> (succeeded: Bool, coverage: TestCoverageReport?)
        switch job {
        case .macOS, .ubuntu, .amazonLinux:
          // @exempt(from: tests) Tested separately.
          testCommand = { output in
            do {
              if loadingCoverage {
                let coverage = try self.testAndLoadCoverageReport(
                  ignoreCoveredRegions: true,
                  reportProgress: { output.print($0) }
                ).get()
                return (succeeded: true, coverage: coverage)
              } else {
                _ = try self.test(reportProgress: { output.print($0) }).get()
                return (succeeded: true, coverage: nil)
              }
            } catch {
              return (succeeded: false, coverage: nil)
            }
          }
        case .windows, .web, .android, .miscellaneous, .deployment:
          unreachable()
        case .tvOS, .iOS, .watchOS:  // @exempt(from: tests) Unreachable from Linux.
          testCommand = { output in
            switch self.test(
              on: job.testPlatform,
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
              case .xcodeError:
                description = ""  // Already printed.
              case .foundationError, .noPackageScheme:
                break
              }
              output.print(description.formattedAsError())
              return (succeeded: false, coverage: nil)
            case .success:
              if loadingCoverage {
                switch codeCoverageReport(
                  on: job.testPlatform,
                  ignoreCoveredRegions: true,
                  reportProgress: { output.print($0) }
                ) {
                case .failure(let error):
                  output.print(StrictString(error.localizedDescription).formattedAsError())
                  return (succeeded: true, coverage: nil)
                case .success(let coverage):
                  return (succeeded: true, coverage: coverage)
                }
              } else {
                return (succeeded: true, coverage: nil)
              }
            }
          }
        }

        let result = testCommand(output)
        if result.succeeded {
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
        return result.coverage
      }
    }

    internal func validate(
      testCoverage: TestCoverageReport?,
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
            return "Testabdeckung auf \(job.deutscherName) wird geprüft ..." + section.anchor
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
        guard let report = testCoverage else {
          failStepWithError(
            message: UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Tests have not produced a coverage report."
              case .deutschDeutschland:
                return "Teste haben keinen Testabdeckungsbericht erstellt."
              }
            }).resolved()
          )
          return
        }

        var irrelevantFiles: Set<URL> = []
        guard #available(macOS 10.15, *) else {
          throw SwiftPMUnavailableError()  // @exempt(from: tests)
        }
        for target in try package().get().targets {
          switch target.type {
          case .library, .systemModule, .binary:
            break  // Coverage matters.
          case .executable, .plugin, .snippet:
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
          // @exempt(from: tests) False positive with Swift 5.8.
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
            // @exempt(from: tests) False positive with Swift 5.8.
            continue files
          }

          CommandLineProofreadingReporter.default.reportParsing(
            file: file.file.path(relativeTo: location),
            to: output
          )
          try purgingAutoreleased {
            let sourceFile = try String(from: file.file)
            regionLoop: for region in file.regions {
              let convertedRegion = sourceFile.indices(of: region.region)
              let startLineIndex = convertedRegion.lowerBound.line(in: sourceFile.lines)
              let startLine = sourceFile.lines[startLineIndex].line
              for token in sameLineTokens where startLine.contains(token.scalars.literal()) {
                continue regionLoop  // Ignore and move on.
              }
              let nextLineIndex = sourceFile.lines.index(after: startLineIndex)
              if nextLineIndex ≠ sourceFile.lines.endIndex {
                let nextLine = sourceFile.lines[nextLineIndex].line
                for token in previousLineTokens where nextLine.contains(token.scalars.literal()) {
                  continue regionLoop  // Ignore and move on.
                }
              }
              // No ignore tokens.

              CommandLineProofreadingReporter.default.report(
                violation: convertedRegion,
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
#endif
