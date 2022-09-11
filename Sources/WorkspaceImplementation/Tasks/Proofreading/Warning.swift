/*
 Warning.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

  internal protocol Warning: TextRule {
    static var trigger: UserFacing<StrictString, InterfaceLocalization> { get }
    static func message(
      for details: StrictString,
      in project: PackageRepository,
      output: Command.Output
    ) throws -> UserFacing<StrictString, InterfaceLocalization>?
  }

  extension Warning {

    internal static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) throws {
      if file.location.lastPathComponent == "ProofreadingRule.swift" {
        // @exempt(from: tests)
        return
      }

      var handledViolations: Set<Range<String.ScalarView.Index>> = []
      for localizedTrigger in InterfaceLocalization.allCases.map({ trigger.resolved(for: $0) }) {

        let marker = ("#\(localizedTrigger)(", ")")

        var index = file.contents.scalars.startIndex
        while let match = file.contents.scalars[index..<file.contents.scalars.endIndex]
          .firstMatch(
            for: NestingPattern(
              opening: marker.0.scalars.literal(),
              closing: marker.1.scalars.literal()
            )
          )
        {
          index = match.contents.bounds.upperBound
          if match.contents.bounds ∉ handledViolations {
            handledViolations.insert(match.contents.bounds)

            var details = StrictString(match.levelContents.contents)
            details.trimMarginalWhitespace()

            if let description = try message(for: details, in: project, output: output) {
              reportViolation(
                in: file,
                at: match.contents.bounds,
                message: description,
                status: status
              )
            }
          }
        }
      }
    }
  }
#endif
