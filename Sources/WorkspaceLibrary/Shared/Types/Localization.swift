/*
 Localization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Localization : String {

    // MARK: - Initialization

    init(code: String) {
        if let localization = Localization(rawValue: code) {
            self = localization
        } else {
            for localization in Localization.all {
                if localization.aliases.contains(code) {
                    self = localization
                    return
                }
            }

            fatalError(message: [
                "Sorry, the localization “\(code)” is not supported yet.",
                "",
                "You can request it at:",
                "\(DocumentationLink.reportIssueLink)"
                ])
        }
    }

    // MARK: - Cases

    case englishUnitedKingdom = "en\u{2D}GB"
    case englishUnitedStates = "en\u{2D}US"
    case englishCanada = "en\u{2D}CA"
    case germanGermany = "de\u{2D}DE"
    case frenchFrance = "fr\u{2D}FR"

    static let all: [Localization] = [
        .englishUnitedKingdom,
        .englishUnitedStates,
        .englishCanada,
        .germanGermany,
        .frenchFrance
    ]

    // MARK: - Properties

    var code: String {
        return rawValue
    }

    var aliases: [String] {
        switch self {

        case .englishUnitedKingdom:
            return ["en"]
        case .germanGermany:
            return ["de"]
        case .frenchFrance:
            return ["fr"]

        case .englishUnitedStates, .englishCanada:
            return []
        }
    }
}
