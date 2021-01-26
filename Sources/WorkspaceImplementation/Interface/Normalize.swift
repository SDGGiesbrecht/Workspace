/*
 Normalize.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
  internal enum Normalize {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom:
        return "normalise"
      case .englishUnitedStates, .englishCanada:
        return "normalize"
      case .deutschDeutschland:
        return "normalisieren"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return
            "normalises the project’s files by removing trailing whitespace, applying Unix newlines, performing canonical decomposition and formatting Swift files."
        case .englishUnitedStates, .englishCanada:
          return
            "normalizes the project’s files by removing trailing whitespace, applying Unix newlines, performing canonical decomposition and formatting Swift files."
        case .deutschDeutschland:
          return
            "normalisiert die Dateien des Projekt, in dem Leerzeichen vom Zeilenende entfernt werden, Unix‐Zeilenumbrüche eingetauscht werden, kanonische Zersetzung ausgeführt wird und Swift‐Dateien formatiert werden."
        }
      })

    private static let swiftFormatLink = "https://github.com/apple/swift\u{2D}format"
    private static let swiftFormatConfigurationLink =
      "https://github.com/apple/swift\u{2D}format/blob/0.50300.0/Sources/SwiftFormatConfiguration/Configuration.swift#L20"
    private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return
            [
              "The general formatting is done by applying Swift’s official formatter, known as swift‐format. More information about it is available at ‹\(Normalize.swiftFormatLink)›.",
              "",
              "Inside a Workspace configuration, the configuration for swift‐format is found under ‘proofreading.swiftFormatConfiguration’ and it uses the Swift API from its own SwiftFormatConfiguration module. See ‹\(Normalize.swiftFormatConfigurationLink)›.",
              "",
              "Setting the entire property to nil will completely disable swift‐format.",
            ].joinedAsLines()
        case .englishUnitedStates, .englishCanada:
          return [
            "The general formatting is done by applying Swift’s official formatter, known as swift‐format. More information about it is available at ‹\(Normalize.swiftFormatLink)›.",
            "",
            "Inside a Workspace configuration, the configuration for swift‐format is found under “proofreading.swiftFormatConfiguration” and it uses the Swift API from its own SwiftFormatConfiguration module. See ‹\(Normalize.swiftFormatConfigurationLink)›",
            "",
            "Setting the entire property to nil will completely disable swift‐format.",
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Für die algemeine Formatierung, wendet Arbeitsbereich das offiziele Formatierer an, der als swift‐format bekannt ist. Weitere Informationen über swift‐format sind bei ‹\(Normalize.swiftFormatLink)› erhältlich.",
            "",
            "Innerhalb eines Arbeitsberich‐Konfiguration befindet sich das swift‐format‐Konfiguration unter „korrektur.swiftFormatKonfiguration“ und es verwendet das Swift‐Programmierschnittstelle aus seinem eigenen SwiftFormatConfiguration‐Modul. Siehe ‹\(Normalize.swiftFormatConfigurationLink)›",
            "",
            "Wenn das ganze Eigenschaft auf nil eingestellt ist, wird swift‐format völlig ausgeschaltet.",
          ].joinedAsLines()
        }
      })

    internal static let command = Command(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: [],
      options: standardOptions,
      execution: { (_: DirectArguments, options: Options, output: Command.Output) throws in
        try executeAsStep(options: options, output: output)
      }
    )

    internal static func executeAsStep(options: Options, output: Command.Output) throws {

      if ¬options.runAsXcodeBuildPhase {
        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom:
              return "Normalising files..."
            case .englishUnitedStates, .englishCanada:
              return "Normalizing files..."
            case .deutschDeutschland:
              return "Deteien werden normalisiert ..."
            }
          }).resolved().formattedAsSectionHeader()
        )
      }

      #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
        try options.project.normalize(output: output)
      #endif
    }
  }
}
