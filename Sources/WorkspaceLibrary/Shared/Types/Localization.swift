/*
 Localization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Localization : Hashable {

    // MARK: - Initialization

    init(code: String) {
        if let result = SupportedLocalization(code: code) {
            self = .supported(result)
        } else {
            self = .unsupported(code)
        }
    }

    // MARK: - Cases

    case supported(SupportedLocalization)
    case unsupported(String)

    // MARK: - Properties

    var code: String {
        switch self {
        case .supported(let localization):
            return localization.code
        case .unsupported(let code):
            return code
        }
    }

    var userFacingCode: String {
        switch self {
        case .supported(let localization):
            switch localization {
            case .englishUnitedKingdom:
                return "🇬🇧EN"
            case .englishUnitedStates:
                return "🇺🇸EN"
            case .englishCanada:
                return "🇨🇦EN"
            case .germanGermany:
                return "🇩🇪DE"
            case .frenchFrance:
                return "🇫🇷FR"
            case .greekGreece:
                return "🇬🇷ΕΛ"
            case .hebrewIsrael:
                return "🇮🇱עב"
            }
        case .unsupported(let code):
            return code
        }
    }

    var supported: SupportedLocalization? {
        switch self {
        case .supported(let result):
            return result
        case .unsupported:
            return nil
        }
    }

    // MARK: - Equatable

    static func == (lhs: Localization, rhs: Localization) -> Bool {
        return lhs.code == rhs.code
    }

    // MARK: - Hashable

    var hashValue: Int {
        return code.hashValue
    }

    // MARK: - Supported

    enum SupportedLocalization : String {

        // MARK: - Initialization

        init?(code: String) {

            if let result = SupportedLocalization(rawValue: code) {
                self = result
            } else if let result = SupportedLocalization.aliases[code] {
                self = result
            } else {
                return nil
            }
        }

        // MARK: - Cases

        case englishUnitedKingdom = "en\u{2D}GB"
        case englishUnitedStates = "en\u{2D}US"
        case englishCanada = "en\u{2D}CA"

        case germanGermany = "de\u{2D}DE"

        case frenchFrance = "fr\u{2D}FR"

        case greekGreece = "el\u{2D}GR"

        case hebrewIsrael = "he\u{2D}IL"

        private static let aliases: [String: SupportedLocalization] = [
            "en": .englishUnitedKingdom,
            "de": .germanGermany,
            "fr": .frenchFrance,
            "el": .greekGreece,
            "he": .hebrewIsrael
        ]

        // MARK: - Properties

        var code: String {
            return rawValue
        }
    }
}
