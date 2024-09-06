/*
 PackageRepository + Open Source.swift

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
  import SDGControlFlow
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  extension PackageRepository {

    private func refreshReadMe(
      at location: URL,
      for localization: LocalizationIdentifier,
      allLocalizations: [LocalizationIdentifier],
      output: Command.Output
    ) throws {

      guard var readMe = try readMe(output: output)[localization] else {
        throw Command.Error(
          description: UserFacing<StrictString, InterfaceLocalization>({ errorLocalization in
            switch errorLocalization {
            case .englishUnitedKingdom:
              return
                "There is no read‐me for ‘\(arbitraryDescriptionOf: localization)’. (documentation.readMe.contents)"
            case .englishUnitedStates, .englishCanada:
              return
                "There is no read‐me for “\(arbitraryDescriptionOf: localization)”. (documentation.readMe.contents)"
            case .deutschDeutschland:
              return
                "Das Lies‐mich für „\(arbitraryDescriptionOf: localization)“ fehlt. (dokumentation.liesMich.inhalt"
            }
          })
        )
      }

      var fromDocumentation: StrictString = ""
      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      if let packageName = try? packageName(),
        let documentation = documentation(packageName: String(packageName))
          .resolved(localizations: allLocalizations).documentation[localization]
      {
        fromDocumentation.append(
          contentsOf: documentation.lines.lazy
            .map({ StrictString($0.text) })
            .joined(separator: "\n")
        )
      }
      readMe.replaceMatches(for: "#packageDocumentation".scalars.literal(), with: fromDocumentation)

      // Word Elements

      for (key, example) in try examples(output: output) {
        readMe.replaceMatches(
          for: "\u{23}example(\(key))",
          with: [
            "```swift",
            StrictString(example),
            "```",
          ].joinedAsLines()
        )
      }

      var file = try TextFile(possiblyAt: location)
      file.body = String(readMe)
      try file.writeChanges(for: self, output: output)
    }

    internal func refreshReadMe(output: Command.Output) throws {

      try refreshReadMe(
        at: location.appendingPathComponent("README.md"),
        for: try developmentLocalization(output: output),
        allLocalizations: try configuration(output: output).documentation.localizations,
        output: output
      )
    }
  }
#endif
