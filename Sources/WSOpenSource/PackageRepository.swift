/*
 PackageRepository.swift

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
import WSExamples
import WSDocumentation

import SDGSwiftSource

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
    #if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
      if let documentation = try? PackageAPI.documentation(
        for: package().get()
      ).resolved(localizations: allLocalizations).documentation[
        localization]
      {

        if let description = documentation.descriptionSection {
          fromDocumentation.append(contentsOf: description.text.scalars)
        }
        for paragraph in documentation.discussionEntries {
          fromDocumentation.append(contentsOf: paragraph.text.scalars)
        }
      }
      readMe.replaceMatches(for: "#packageDocumentation".scalars, with: fromDocumentation)
    #endif

    // Word Elements

    for (key, example) in try examples(output: output) {
      readMe.replaceMatches(
        for: "\u{23}example(\(key))",
        with: [
          "```swift",
          StrictString(example),
          "```"
        ].joinedAsLines()
      )
    }

    var file = try TextFile(possiblyAt: location)
    file.body = String(readMe)
    try file.writeChanges(for: self, output: output)
  }

  public func refreshReadMe(output: Command.Output) throws {

    try refreshReadMe(
      at: location.appendingPathComponent("README.md"),
      for: try developmentLocalization(output: output),
      allLocalizations: try configuration(output: output).documentation.localizations,
      output: output
    )

    // Deprecated file locations.
    delete(location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
    for localization in try configuration(output: output).documentation.localizations {
      autoreleasepool {
        delete(
          ReadMeConfiguration._readMeLocation(for: location, localization: localization),
          output: output
        )
        delete(
          ReadMeConfiguration._relatedProjectsLocation(
            for: location,
            localization: localization
          ),
          output: output
        )
      }
    }
  }
}
