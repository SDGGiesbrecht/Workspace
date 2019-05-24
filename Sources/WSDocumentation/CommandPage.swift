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
}
