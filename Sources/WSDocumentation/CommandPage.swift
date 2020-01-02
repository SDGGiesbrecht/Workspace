/*
 CommandPage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
import WSGeneralImports

import SDGExportedCommandLineInterface
import SDGHTML
import SDGSwiftSource

import WSProject

internal class CommandPage: Page {

  internal init(
    localization: LocalizationIdentifier,
    allLocalizations: [LocalizationIdentifier],
    pathToSiteRoot: StrictString,
    package: APIElement,
    navigationPath: [CommandInterfaceInformation],
    packageImport: StrictString?,
    index: StrictString,
    platforms: StrictString,
    command: CommandInterfaceInformation,
    copyright: StrictString,
    output: Command.Output
  ) {

    let interface = command.interfaces[localization]!

    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "...\(StrictString(interface.name))..."
        case .deutschDeutschland:
          return "... \(StrictString(interface.name)) ..."
        }
      }).resolved()
    )

    let symbolType: StrictString
    if navigationPath.count ≤ 1 {
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          symbolType = "Command Line Tool"
        case .deutschDeutschland:
          symbolType = "Befehlszeilenprogramm"
        }
      } else {
        symbolType = "executable"  // From “products: [.executable(...)]”
      }
    } else {
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        symbolType = "Subcommand"
      case .deutschDeutschland:
        symbolType = "Unterbefehl"
      }
    }

    var navigationPathLinks = navigationPath.map { commandInformation in
      return (
        label: commandInformation.interfaces[localization]!.name,
        path: commandInformation.relativePagePath[localization]!
      )
    }
    navigationPathLinks.prepend(
      (
        StrictString(package.name.source()),
        package.relativePagePath[localization]!
      )
    )

    var content: [StrictString] = []
    content.append(
      SymbolPage.generateDescriptionSection(
        contents: HTML.escapeTextForCharacterData(interface.description)
      )
    )
    content.append(
      CommandPage.generateDeclarationSection(
        navigationPath: navigationPath,
        localization: localization,
        interface: interface
      )
    )
    content.append(
      CommandPage.generateDiscussionSection(localization: localization, interface: interface)
    )
    content.append(
      CommandPage.generateSubcommandsSection(localization: localization, interface: interface)
    )
    content.append(
      CommandPage.generateOptionsSection(localization: localization, interface: interface)
    )
    content.append(
      CommandPage.generateArgumentTypesSection(
        localization: localization,
        interface: interface
      )
    )

    super.init(
      localization: localization,
      pathToSiteRoot: pathToSiteRoot,
      navigationPath: SymbolPage.generateNavigationPath(
        localization: localization,
        pathToSiteRoot: pathToSiteRoot,
        allLocalizations: allLocalizations.map({ localization in
          return (
            localization: localization, path: command.relativePagePath[localization]!
          )
        }),
        navigationPath: navigationPathLinks
      ),
      packageImport: packageImport,
      index: index,
      sectionIdentifier: .tools,
      platforms: platforms,
      symbolImports: "",
      symbolType: symbolType,
      compilationConditions: nil,
      constraints: nil,
      title: interface.name,
      content: content.joinedAsLines(),
      extensions: "",
      copyright: copyright
    )
  }

  private static func generateDeclarationSection(
    navigationPath: [CommandInterfaceInformation],
    localization: LocalizationIdentifier,
    interface: CommandInterface
  ) -> StrictString {

    let commands: [ElementSyntax] = navigationPath.map { command in
      let name = command.interfaces[localization]!.name
      return ElementSyntax(
        "span",
        attributes: ["class": "command"],
        contents: HTML.escapeTextForCharacterData(name),
        inline: true
      )
    }

    let arguments = interface.arguments.map { argument in
      return ElementSyntax(
        "span",
        attributes: ["class": "argument‐type"],
        contents: "[" + HTML.escapeTextForCharacterData(argument.name) + "]",
        inline: true
      )
    }

    return SymbolPage.generateDeclarationSection(
      localization: localization,
      declaration: ElementSyntax(
        "code",
        attributes: ["class": "swift blockquote"],
        contents: (commands + arguments).map({ $0.normalizedSource() })
          .joined(separator: " "),
        inline: true
      ).normalizedSource()
    )
  }

  private static func generateDiscussionSection(
    localization: LocalizationIdentifier,
    interface: CommandInterface
  ) -> StrictString {

    var discussion: StrictString? = interface.discussion
      .map({ HTML.escapeTextForCharacterData($0) })
    discussion?.replaceMatches(for: "\n\n", with: "</p><p>")
    discussion?.replaceMatches(for: "\n", with: "<br>")

    if let content = discussion {
      discussion = ElementSyntax("p", contents: content, inline: false).normalizedSource()
    }

    return SymbolPage.generateDiscussionSection(
      localization: localization,
      symbol: nil,
      content: discussion
    )
  }

  internal static func subcommandsDirectoryName(
    for localization: LocalizationIdentifier
  ) -> StrictString {
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Subcommands"
    case .deutschDeutschland:
      return "Unterbefehle"
    }
  }

  private static func generateSubcommandsSection(
    localization: LocalizationIdentifier,
    interface: CommandInterface
  ) -> StrictString {

    let heading: StrictString
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      heading = "Subcommands"
    case .deutschDeutschland:
      heading = "Unterbefehle"
    }

    return SymbolPage.generateParameterLikeSection(
      heading: heading,
      entries: interface.subcommands
        .sorted(by: { $0.name < $1.name })
        .map({ subcommand in

          let command = ElementSyntax(
            "span",
            attributes: ["class": "command"],
            contents: HTML.escapeTextForCharacterData(subcommand.name),
            inline: true
          )

          let arguments = subcommand.arguments.map { argument in
            ElementSyntax(
              "span",
              attributes: ["class": "argument‐type"],
              contents: "[" + HTML.escapeTextForCharacterData(argument.name) + "]",
              inline: true
            )
          }
          let tokens = [command] + arguments

          var link = Page.sanitize(fileName: interface.name)
          link += "/"
          link += CommandPage.subcommandsDirectoryName(for: localization)
          link += "/"
          link += subcommand.name
          link += ".html"

          let term = ElementSyntax(
            "a",
            attributes: ["href": HTML.percentEncodeURLPath(link)],
            contents: ElementSyntax(
              "code",
              attributes: ["class": "swift code"],
              contents: tokens.map({ $0.normalizedSource() }).joined(separator: " "),
              inline: true
            ).normalizedSource(),
            inline: true
          ).normalizedSource()

          let description = ElementSyntax(
            "p",
            contents: HTML.escapeTextForCharacterData(subcommand.description),
            inline: true
          ).normalizedSource()
          return (term: term, description: description)
        })
    )
  }

  private static func generateOptionsSection(
    localization: LocalizationIdentifier,
    interface: CommandInterface
  ) -> StrictString {

    let heading: StrictString
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      heading = "Options"
    case .deutschDeutschland:
      heading = "Optionen"
    }

    return SymbolPage.generateParameterLikeSection(
      heading: heading,
      entries: interface.options
        .sorted(by: { $0.name < $1.name })
        .map({ option in

          let optionElement = ElementSyntax(
            "span",
            attributes: ["class": "option"],
            contents: "•" + HTML.escapeTextForCharacterData(option.name),
            inline: true
          )

          var tokens = [optionElement]
          if ¬option.isFlag {
            tokens.append(
              ElementSyntax(
                "span",
                attributes: ["class": "argument‐type"],
                contents: "["
                  + HTML.escapeTextForCharacterData(option.type.name)
                  + "]",
                inline: true
              )
            )
          }

          let term = ElementSyntax(
            "code",
            attributes: ["class": "swift code"],
            contents: tokens.map({ $0.normalizedSource() }).joined(separator: " "),
            inline: true
          ).normalizedSource()

          let description = ElementSyntax(
            "p",
            contents: HTML.escapeTextForCharacterData(option.description),
            inline: true
          ).normalizedSource()
          return (term: term, description: description)
        })
    )
  }

  private static func generateArgumentTypesSection(
    localization: LocalizationIdentifier,
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

    return SymbolPage.generateParameterLikeSection(
      heading: heading,
      entries: sortedArguments.map({ argument in

        let argumentElement = ElementSyntax(
          "span",
          attributes: ["class": "argument‐type"],
          contents: "[" + HTML.escapeTextForCharacterData(argument.name) + "]",
          inline: true
        )

        let term = ElementSyntax(
          "code",
          attributes: ["class": "swift code"],
          contents: argumentElement.normalizedSource(),
          inline: true
        ).normalizedSource()

        let description = ElementSyntax(
          "p",
          contents: HTML.escapeTextForCharacterData(argument.description),
          inline: true
        ).normalizedSource()
        return (term: term, description: description)
      })
    )
  }
}
