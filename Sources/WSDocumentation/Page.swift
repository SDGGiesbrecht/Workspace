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

internal class Page {

    internal static func sanitize(fileName: StrictString) -> StrictString {
        // U+0000 is invalid to begin with.

        // U+002F
        // Brackets are not valid in either identifiers or operators, so no name clashes.
        return fileName.replacingMatches(for: "/".scalars, with: "[U+002F]".scalars)
    }

    // MARK: - Static Properties

    private static let template: StrictString = {
        var result = TextFile(mockFileWithContents: Resources.page, fileType: .html)
        result.header = ""
        return StrictString(result.contents)
    }()

    private static func watermark(localization: LocalizationIdentifier) -> StrictString {
        let resolved = localization._bestMatch

        // #workaround(Until self‐generated documentation is live—it can then be localized too.)
        let targetURL: StrictString = "https://github.com/SDGGiesbrecht/Workspace#workspace"

        let name: StrictString
        switch resolved {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            name = "Workspace"
        }

        let link = HTMLElement("a", attributes: ["href": targetURL], contents: name, inline: true).source

        let generatedUsing: StrictString
        switch resolved {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            generatedUsing = "Generated using " + link + "."
        }

        let sdg: StrictString
        switch resolved {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            sdg = HTMLElement("span", attributes: ["lang": "la-IT"], contents: "Soli Deo gloria.", inline: true).source
        }

        return HTMLElement("p", attributes: [
            "lang": StrictString(resolved.code),
            "dir": StrictString(resolved.textDirection.htmlAttribute)
            ], contents: generatedUsing + " " + sdg, inline: true).source
    }

    // MARK: - Initialization

    internal init(localization: LocalizationIdentifier, pathToSiteRoot: StrictString, navigationPath: StrictString, symbolType: StrictString?, compilationConditions: StrictString?, title: StrictString, content: StrictString, copyright: StrictString) {
        var mutable = Page.template
        mutable.replaceMatches(for: "[*localization*]".scalars, with: localization.code.scalars)
        mutable.replaceMatches(for: "[*text direction*]".scalars, with: localization.textDirection.htmlAttribute.scalars)

        mutable.replaceMatches(for: "[*navigation path*]", with: navigationPath.scalars)

        let symbolTypeLabel: StrictString
        if let specified = symbolType {
            symbolTypeLabel = HTMLElement("div", attributes: ["class": "symbol‐type"], contents: specified, inline: true).source
        } else {
            symbolTypeLabel = ""
        }
        mutable.replaceMatches(for: "[*symbol type*]", with: symbolTypeLabel)

        let conditions: StrictString
        if let specified = compilationConditions {
            conditions = specified
        } else {
            conditions = ""
        }
        mutable.replaceMatches(for: "[*compilation conditions*]", with: conditions)

        mutable.replaceMatches(for: "[*title*]", with: title)
        mutable.replaceMatches(for: "[*site root*]".scalars, with: pathToSiteRoot)

        mutable.replaceMatches(for: "[*content*]", with: content)

        mutable.replaceMatches(for: "[*copyright*]", with: HTMLElement("p", contents: copyright, inline: false).source)
        mutable.replaceMatches(for: "[*workspace*]", with: Page.watermark(localization: localization))
        contents = mutable
    }

    // MARK: - Properties

    internal let contents: StrictString
}
