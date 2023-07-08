/*
 CommandPage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGMathematics

  import SDGCommandLine
  import SDGExportedCommandLineInterface

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal struct CommandArticle {

    // MARK: - Initialization

    internal init(
      localization: LocalizationIdentifier,
      navigationPath: [CommandInterface],
      command: CommandInterface
    ) {
      self.localization = localization
      self.navigationPath = navigationPath
      self.command = command
    }

    // MARK: - Properties

    private let localization: LocalizationIdentifier
    private let navigationPath: [CommandInterface]
    private let command: CommandInterface

    // MARK: - Source

    internal func article() -> Article {

      let interface = command

      var content: [StrictString] = []
      content.append(interface.description)
      content.append(
        declarationSection(
          interface: interface
        )
      )
      if let discussion = interface.discussion {
        content.append(discussion)
      }
      content.append(
        subcommandsSection(
          interface: interface
        )
      )
      content.append(
        optionsSection(interface: interface)
      )
      content.append(
        argumentTypesSection(
          interface: interface
        )
      )

      return Article(
        title: interface.name,
        content: content.joinedAsLines()
      )
    }

    private func declarationSection(
      interface: CommandInterface
    ) -> StrictString {

      let commands: [StrictString] = navigationPath.map { command in
        return command.name
      }

      let arguments: [StrictString] = interface.arguments.map { argument in
        return "[\(argument.name)]"
      }

      return [
        "```shell",
        (commands + arguments).joined(separator: " "),
        "```"
      ].joinedAsLines()
    }

    internal func subcommandsDirectoryName() -> StrictString {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Subcommands"
      case .deutschDeutschland:
        return "Unterbefehle"
      }
    }

    private func subcommandsSection(
      interface: CommandInterface
    ) -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Subcommands"
      case .deutschDeutschland:
        heading = "Unterbefehle"
      }

      return definitionListSection(
        heading: heading,
        entries: interface.subcommands
          .sorted(by: { $0.name < $1.name })
          .map({ subcommand in
            let command: StrictString = "\(subcommand.name)"
            let arguments: [StrictString] = subcommand.arguments.map { argument in
              return "[\(argument.name)]"
            }
            let tokens = [command] + arguments
            let term = tokens.joined(separator: " ")
            let description = subcommand.description
            return (term: "`\(term)`", description: description)
          })
      )
    }

    private func optionsSection(
      interface: CommandInterface
    ) -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Options"
      case .deutschDeutschland:
        heading = "Optionen"
      }

      return definitionListSection(
        heading: heading,
        entries: interface.options
          .sorted(by: { $0.name < $1.name })
          .map({ option in

            let optionName: StrictString = "•\(option.name)"

            var tokens = [optionName]
            if ¬option.isFlag {
              tokens.append("[\(option.type.name)]")
            }

            let term = tokens.map({ $0 }).joined(separator: " ")
            return (term: "`\(term)`", description: option.description)
          })
      )
    }

    private func argumentTypesSection(
      interface: CommandInterface
    ) -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Argument Types"
      case .deutschDeutschland:
        heading = "Argumentarte"
      }

      var arguments: [StrictString: ArgumentInterface] = [:]
      for argument in interface.arguments {
        arguments[argument.identifier] = argument
      }
      for option in interface.options where ¬option.isFlag {
        arguments[option.type.identifier] = option.type
      }
      let sortedArguments = arguments.values
        .sorted(by: { $0.name < $1.name })

      return definitionListSection(
        heading: heading,
        entries: sortedArguments.map({ argument in
          return (term: "`\(argument.name)`", description: argument.description)
        })
      )
    }

    internal func definitionListSection(
      heading: StrictString,
      entries: [(term: StrictString, description: StrictString)]
    ) -> StrictString {
      guard ¬entries.isEmpty else {
        return ""
      }

      var list: [StrictString] = []
      for entry in entries {
        list.append("\u{2D} \(entry.term): \(entry.description)")
      }

      return [
        "### \(heading)",
        "",
      ].appending(contentsOf: list).joinedAsLines()
    }
  }
#endif
