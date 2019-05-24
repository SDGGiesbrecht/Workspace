/*
 CommandPage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGExportedCommandLineInterface
import SDGHTML

import WSProject

internal class CommandPage : Page {

    internal init(
        localization: LocalizationIdentifier,
        pathToSiteRoot: StrictString,
        navigationPath: [CommandInterfaceInformation],
        packageImport: StrictString?,
        index: StrictString,
        platforms: StrictString,
        command: CommandInterfaceInformation,
        copyright: StrictString,
        output: Command.Output) {

        let interface = command.interfaces[localization]!

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "..." + StrictString(interface.name) + "..."
            }
        }).resolved())

        let symbolType: StrictString
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                symbolType = "Command Line Tool"
            }
        } else {
            symbolType = "executable" // From “products: [.executable(...)]”
        }

        let navigationPathLinks = navigationPath.map { commandInformation in
            return (
                label: commandInformation.interfaces[localization]!.name,
                path: commandInformation.relativePagePath[localization]!
            )
        }

        var content: [StrictString] = []
        content.append(SymbolPage.generateDescriptionSection(contents: interface.description))
        content.append(CommandPage.generateDeclarationSection(localization: localization, interface: interface))

        super.init(
            localization: localization,
            pathToSiteRoot: pathToSiteRoot,
            navigationPath: SymbolPage.generateNavigationPath(
                localization: localization,
                pathToSiteRoot: pathToSiteRoot,
                navigationPath: navigationPathLinks),
            packageImport: packageImport,
            index: index,
            platforms: platforms,
            symbolImports: "",
            symbolType: symbolType,
            compilationConditions: nil,
            constraints: nil,
            title: interface.name,
            content: content.joinedAsLines(),
            extensions: "",
            copyright: copyright)
    }

    private static func generateDeclarationSection(
        localization: LocalizationIdentifier,
        interface: CommandInterface) -> StrictString {

        let command = ElementSyntax(
            "span",
            attributes: ["class": "command"],
            contents: interface.name,
            inline: true)

        let arguments = interface.arguments.map { argument in
            ElementSyntax(
                "span",
                attributes: ["class": "argument‐type"],
                contents: "[" + argument.name + "]",
                inline: true)
        }

        return SymbolPage.generateDeclarationSection(
            localization: localization,
            declaration: ElementSyntax(
                "code",
                attributes: ["class": "swift blockquote"],
                contents: ([command] + arguments).map({ $0.normalizedSource() }).joined(separator: " "),
                inline: true).normalizedSource())
    }

    private static func generateOptionsSection(
        localization: LocalizationIdentifier,
        interface: CommandInterface) -> StrictString {

        let heading: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            heading = "Options"
        }

        return SymbolPage.generateParameterLikeSection(
            heading: heading,
            entries: interface.options.map({ option in

                let optionElement = ElementSyntax(
                    "span",
                    attributes: ["class": "option"],
                    contents: interface.name,
                    inline: true)

                let type = ElementSyntax(
                    "span",
                    attributes: ["class": "argument‐type"],
                    contents: "[" + option.type.name + "]",
                    inline: true)

                let term = ElementSyntax(
                    "code",
                    attributes: ["class": "swift blockquote"],
                    contents: ([optionElement, type]).map({ $0.normalizedSource() }).joined(separator: " "),
                    inline: true).normalizedSource()

                let description = ElementSyntax("p", contents: option.description, inline: true).normalizedSource()
                return (term: term, description: description)
            }))
    }

    private static func generateArgumentTypesSection(
        localization: LocalizationIdentifier,
        interface: CommandInterface) -> StrictString {

        let heading: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            heading = "Argument Types"
        }

        var arguments: [StrictString: ArgumentInterface] = [:]
        for argument in interface.arguments {
            arguments[argument.identifier] = argument
        }
        for option in interface.options {
            arguments[option.type.identifier] = option.type
        }
        let sortedArguments = arguments.values.sorted(by: { $0.name < $1.name })

        return SymbolPage.generateParameterLikeSection(
            heading: heading,
            entries: sortedArguments.map({ argument in

                let argumentElement = ElementSyntax(
                    "span",
                    attributes: ["class": "argument‐type"],
                    contents: "[" + argument.name + "]",
                    inline: true)

                let term = ElementSyntax(
                    "code",
                    attributes: ["class": "swift blockquote"],
                    contents: argumentElement.normalizedSource(),
                    inline: true).normalizedSource()

                let description = ElementSyntax(
                    "p",
                    contents: argument.description,
                    inline: true).normalizedSource()
                return (term: term, description: description)
            }))
    }
}
