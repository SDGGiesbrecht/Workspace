/*
 MockCommand.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import WorkspaceLocalizations

let mockCommand = Command(
  name: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "do‐something"
    case .deutschDeutschland:
      return "etwas‐tun"
    }
  }),
  description: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "does something."
    case .deutschDeutschland:
      return "tut etwas."
    }
  }),
  discussion: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Paragraph one.\nLine two.\n\nParagraph two."
    case .deutschDeutschland:
      return "Paragraf eins.\nZeile zwei.\n\nParagraf zwei."
    }
  }),
  subcommands: [mockSubcommand]
)

let mockOption = Option(
  name: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
      .deutschDeutschland:
      return "alternative"
    }
  }),
  description: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "An alternative."
    case .deutschDeutschland:
      return "Eine Alternative."
    }
  }),
  type: ArgumentType.string
)

let mockSubcommand = Command(
  name: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "subcommand"
    case .deutschDeutschland:
      return "unterbefehl"
    }
  }),
  description: UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "is an example subcommand."
    case .deutschDeutschland:
      return "ist ein Beispielsunterbefehl."
    }
  }),
  directArguments: [ArgumentType.string],
  options: [mockOption],
  execution: { _, _, _ in }
)
