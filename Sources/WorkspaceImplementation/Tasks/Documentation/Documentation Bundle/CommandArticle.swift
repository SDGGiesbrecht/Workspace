/*
 CommandArticle.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    // MARK: - Static Methods

    internal static func title(for command: CommandInterface, in navigationPath: [CommandInterface]) -> StrictString {
      return navigationPath.appending(command).map({ $0.name }).joined(separator: " ")
    }

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
      var content: [StrictString] = []
      content.append(command.description)
      content.append(declarationSection())
      if let discussion = command.discussion {
        content.append(discussion)
      }
      content.append(subcommandsSection())
      content.append(optionsSection())
      content.append(argumentTypesSection())
      return Article(
        title: CommandArticle.title(for: command, in: navigationPath) ,
        content: content.joinedAsLines()
      )
    }

    private func declarationSection() -> StrictString {
      let commands: [StrictString] = navigationPath.appending(command)
        .map { command in
          return command.name
        }

      let arguments: [StrictString] = command.arguments.map { argument in
        return "[\(argument.name)]"
      }

      return [
        "",
        "```shell",
        (commands + arguments).joined(separator: " "),
        "```"
      ].joinedAsLines()
    }

    private func subcommandsSection() -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Subcommands"
      case .deutschDeutschland:
        heading = "Unterbefehle"
      }

      return definitionListSection(
        heading: heading,
        entries: command.subcommands
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

    private func optionsSection() -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Options"
      case .deutschDeutschland:
        heading = "Optionen"
      }

      return definitionListSection(
        heading: heading,
        entries: command.options
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

    private func argumentTypesSection() -> StrictString {

      let heading: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        heading = "Argument Types"
      case .deutschDeutschland:
        heading = "Argumentarte"
      }

      var arguments: [StrictString: ArgumentInterface] = [:]
      for argument in command.arguments {
        arguments[argument.identifier] = argument
      }
      for option in command.options where ¬option.isFlag {
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
        "",
        "### \(heading)",
        "",
      ].appending(contentsOf: list).joinedAsLines()
    }
  }
#endif
