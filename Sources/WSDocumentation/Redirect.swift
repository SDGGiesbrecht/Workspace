/*
 Redirect.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import enum SDGHTML.HTML

import WSProject

internal struct Redirect {

    // MARK: - Static Properties

    private static let template: String = {
        var result = TextFile(mockFileWithContents: Resources.redirect, fileType: .html)
        result.header = ""
        return result.contents
    }()

    // MARK: - Initialization

    internal init(target: String) {
        var mutable = Redirect.template
        mutable.scalars.replaceMatches(for: "[*target*]".scalars, with: HTML.percentEncodeURLPath(HTML.escapeTextForAttribute(target)).scalars)
        contents = mutable
    }

    // MARK: - Properties

    internal let contents: String
}
