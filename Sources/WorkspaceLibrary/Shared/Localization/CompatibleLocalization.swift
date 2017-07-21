/*
 CompatibleLocalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

/// A localization that Workspace can interact with user content in.
enum CompatibleLocalization : String, Localization {

    // MARK: - Cases

    case englishUnitedKingdom = "en\u{2D}GB"
    case englishUnitedStates = "en\u{2D}US"
    case englishCanada = "en\u{2D}CA"

    case deutschDeutschland = "de\u{2D}DE"

    case françaisFrance = "fr\u{2D}FR"

    case ελληνικάΕλλάδα = "el\u{2D}GR"

    case עברית־ישראל = "he\u{2D}IL"

    // MARK: - Properties

    var icon: StrictString {
        switch self {
        case .englishUnitedKingdom:
            return "🇬🇧EN"
        case .englishUnitedStates:
            return "🇺🇸EN"
        case .englishCanada:
            return "🇨🇦EN"
        case .deutschDeutschland:
            return "🇩🇪DE"
        case .françaisFrance:
            return "🇫🇷FR"
        case .ελληνικάΕλλάδα:
            return "🇬🇷ΕΛ"
        case .עברית־ישראל:
            return "🇮🇱עב"
        }
    }

    // MARK: - Localization

    static let fallbackLocalization = CompatibleLocalization.englishCanada
}
