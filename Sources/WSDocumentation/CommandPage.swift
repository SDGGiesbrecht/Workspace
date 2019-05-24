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

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "..." + StrictString(command.interfaces[localization]!.name) + "..."
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

        var content: [StrictString] = ["[Content]"]
        content.append(ElementSyntax(
            "div",
            attributes: ["class": "description"],
            contents: ElementSyntax(
                "p",
                contents: command.interfaces[localization]!.description,
                inline: false).normalizedSource(),
            inline: false).normalizedSource())

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
            title: command.interfaces[localization]!.name,
            content: content.joinedAsLines(),
            extensions: "",
            copyright: copyright)
    }
}
