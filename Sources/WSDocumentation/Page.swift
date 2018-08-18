/*
 Page.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct Page {

    // MARK: - Static Properties

    private static let template: StrictString = {
        var result = TextFile(mockFileWithContents: Resources.page, fileType: .html)
        result.header = ""
        return StrictString(result.contents)
    }()

    // MARK: - Initialization

    internal init(title: StrictString, localization: LocalizationIdentifier) {
        var mutable = Page.template
        mutable.replaceMatches(for: "[*localization code*]".scalars, with: localization.code.scalars)
        mutable.replaceMatches(for: "[*title*]", with: title)
        contents = mutable
    }

    // MARK: - Properties

    internal let contents: StrictString
}
