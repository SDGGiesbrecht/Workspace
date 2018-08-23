/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

internal class SymbolPage : Page {

    // MARK: - Initialization

    internal init(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, symbol: APIElement) {
        var content: StrictString = ""

        let symbolType: StrictString
        if symbol is PackageAPI {
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    symbolType = "Package"
                }
            } else {
                symbolType = "Package" // From “let ... = Package(...)”
            }
        } else {
            if BuildConfiguration.current == .debug {
                print("Unrecognized symbol type: \(type(of: symbol))")
            }
            symbolType = ""
        }

        if let documentation = symbol.documentation {
            if let description = documentation.descriptionSection {
                content.append(contentsOf: HTMLElement("div", attributes: ["class": "description"], contents: StrictString(description.renderedHTML()), inline: false).source)
            }
        }

        super.init(localization: localization, pathToSiteRoot: pathToSiteRoot, symbolType: symbolType, title: StrictString(symbol.name), content: content)
    }
}
