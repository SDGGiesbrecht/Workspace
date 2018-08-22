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

import WSProject

internal class SymbolPage : Page {

    // MARK: - Initialization

    internal init(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, symbol: Symbol) {
        super.init(localization: localization, pathToSiteRoot: pathToSiteRoot, title: StrictString(symbol.name), content: "")
    }
}
