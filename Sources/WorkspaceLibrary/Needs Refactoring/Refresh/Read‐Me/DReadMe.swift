/*
 DReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct ReadMe {

    static let skipInJazzy = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    static func readMeFilename(localization: ArbitraryLocalization?) -> StrictString {
        if let particular = localization {
            var name: StrictString
            if let specific = particular.compatible {
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    name = "Read Me.md"
                case .deutschDeutschland:
                    name = "Lies mich.md"
                case .françaisFrance:
                    name = "Lisez moi.md"
                case .ελληνικάΕλλάδα:
                    name = "Με διαβάστε.md"
                case .עברית־ישראל:
                    name = "קרא אותי.md"
                }
            } else {
                name = "Read Me.md"
            }
            return particular.icon + " " + name
        }
        return "Read Me.md"
    }
    static func readMePath(localization: ArbitraryLocalization?) -> RelativePath {
        if localization ≠ nil {
            return RelativePath("Documentation/\(readMeFilename(localization: localization))")
        } else {
            return RelativePath("README.md")
        }
    }
    static func relatedProjectsFilename(localization: ArbitraryLocalization?) -> StrictString {
        if let particular = localization {
            var name: StrictString
            if let specific = particular.compatible {
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    name = "Related Projects.md"
                case .deutschDeutschland:
                    name = "Verwandte Projekte.md"
                case .françaisFrance:
                    name = "Projets liés.md"
                case .ελληνικάΕλλάδα:
                    name = "Συγγενικά έργα.md"
                case .עברית־ישראל:
                    name = "מיזמים קשורים.md"
                }
            } else {
                name = "Related Projects.md"
            }
            return particular.icon + " " + name
        }
        return "Related Projects.md"
    }
    static func relatedProjectsPath(localization: ArbitraryLocalization?) -> RelativePath {
        if localization ≠ nil {
            return RelativePath("Documentation/\(relatedProjectsFilename(localization: localization))")
        } else {
            if let development = Configuration.developmentLocalization {
                return relatedProjectsPath(localization: development)
            } else {
                return RelativePath("Documentation/\(relatedProjectsFilename(localization: localization))")
            }
        }
    }

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static func defaultReadMeTemplate(localization: ArbitraryLocalization?, output: inout Command.Output) throws -> String {
        let translation = Configuration.resolvedLocalization(for: localization)

        var readMe: [String] = []

        if ¬Configuration.localizations.isEmpty {
            readMe += [
                "[_Localization Links_]",
                ""
            ]
        }

        if Configuration.documentationURL ≠ nil {
            readMe += [
                "[_API Links_]",
                ""
            ]
        }

        readMe += [
            "# [_Project_]"
        ]

        if Configuration.shortProjectDescription(localization: localization) ≠ nil {
            readMe += [
                "",
                "[_Short Description_]"
            ]
        }

        if Configuration.quotation ≠ nil {
            readMe += [
                "",
                "[_Quotation_]"
            ]
        }

        if Configuration.featureList(localization: localization) ≠ nil {
            let features: String
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    features = "Features"
                case .deutschDeutschland:
                    features = "Merkmale"
                case .françaisFrance:
                    features = "Fonctionnalités"
                case .ελληνικάΕλλάδα:
                    features = "Χαρακτηριστικά"
                case .עברית־ישראל:
                    features = "תכונות"
                }
            default:
                features = "Features"
            }

            readMe += [
                "",
                "## \(features)",
                "",
                "[_Features_]"
            ]
        }

        if ¬Configuration.relatedProjects(localization: translation).isEmpty {
            readMe += [
                "",
                "[_Related Projects_]"
            ]
        }

        if (try? Configuration.installationInstructions(localization: localization, output: &output))! ≠ nil {
            readMe += [
                "",
                "[_Installation Instructions_]"
            ]
        }

        var readMeExampleExists = false
        for (key, _) in Examples.examples {
            if key.hasPrefix("Read‐Me") {
                readMeExampleExists = true
                break
            }
        }
        if readMeExampleExists {
            let example: String
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    example = "Example Usage"
                case .deutschDeutschland:
                    example = "Verwendungsbeispiel"
                case .françaisFrance:
                    example = "Example d’utilisation"
                case .ελληνικάΕλλάδα:
                    example = "Παράδειγμα χρήσης"
                case .עברית־ישראל:
                    example = "דוגמת שימוש"
                }
            default:
                example = "Example Usage"
            }

            readMe += [
                "",
                "## \(example)",
                "",
                "```swift",
                "[\u{5F}Example Usage_]",
                "```"
            ]
        }

        if Configuration.otherReadMeContent ≠ nil {
            readMe += [
                "",
                "[_Other_]"
            ]
        }

        if Configuration.sdg {
            func english(translation: ArbitraryLocalization) throws -> [String] {
                return [
                    "",
                    "## About",
                    "",
                    "The \(try Repository.packageRepository.projectName(output: &output)) project is maintained by Jeremy David Giesbrecht.",
                    "",
                    "If \(try Repository.packageRepository.projectName(output: &output)) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
                    "",
                    "If \(try Repository.packageRepository.projectName(output: &output)) saves you time, consider devoting some of it to [contributing](\(Configuration.requiredRepositoryURL)) back to the project.",
                    "",
                    format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "For the worker is worthy of his wages.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                ]
            }
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    readMe += try english(translation: translation)
                case .deutschDeutschland:
                    readMe += [
                        "",
                        "## Über",
                        "",
                        "Das \(try Repository.packageRepository.projectName(output: &output))‐Projekt wird von Jeremy David Giesbrecht erhalten.",
                        "",
                        "Wenn \(try Repository.packageRepository.projectName(output: &output)) Ihnen Geld sparrt, denken Sie darüber, etwas davon zu [spenden](https://paypal.me/JeremyGiesbrecht).",
                        "",
                        "Wenn \(try Repository.packageRepository.projectName(output: &output)) Inhen Zeit sparrt, denken Sie darüber, etwas davon zu gebrauchen, um zum Projekt [beizutragen](\(Configuration.requiredRepositoryURL)).",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "Denn der Arbeiter ist seines Lohns würdig.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                    ]
                case .françaisFrance:
                    readMe += [
                        "",
                        "## À propos",
                        "",
                        "Le projet \(try Repository.packageRepository.projectName(output: &output)) est maintenu par Jeremy David Giesbrecht.",
                        "",
                        "Si \(try Repository.packageRepository.projectName(output: &output)) vous permet d’économiser de l’argent, considérez à en [donner](https://paypal.me/JeremyGiesbrecht).",
                        "",
                        "Si \(try Repository.packageRepository.projectName(output: &output)) vous permet d’économiser du temps, considérez à en utiliser à [contribuer](\(Configuration.requiredRepositoryURL)) au projet.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "Car le travailleur est digne de son salaire.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                    ]
                case .ελληνικάΕλλάδα:
                    readMe += [
                        "",
                        "## Πληροφορίες",
                        "",
                        "Το \(try Repository.packageRepository.projectName(output: &output)) έργο διατηρείται από τον Τζέρεμι Ντάβιτ Γκίσμπρεχτ (Jeremy David Giesbrecht).",
                        "",
                        // οικονομώ
                        "Αν το \(try Repository.packageRepository.projectName(output: &output)) οικονομάει το χρήματα σας, σκεφτείτε να [δορίζετε](https://paypal.me/JeremyGiesbrecht) μερικά από αυτά.",
                        "",
                        "Αν το \(try Repository.packageRepository.projectName(output: &output)) οικονομάει τον χρόνο σας, σκεφτείτε να τον κάνετε χρήτη μερικού από αυτό ώστε να [συνεισφέρετε](\(Configuration.requiredRepositoryURL)) του έργου.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: nil, url: "https://www.bible.com/bible/209/LUK.10.byz04", citation: "\u{200E}ישוע/Ιεσούα")
                    ]
                case .עברית־ישראל:
                    readMe += [
                        "",
                        "## אודות",
                        "",
                        "⁨\(try Repository.packageRepository.projectName(output: &output))⁩ המיזם מתוחזק על ידי ג׳רמי דוויט גיסברכט (⁧Jeremy David Giesbrecht⁩).",
                        "",
                        "אם ⁨\(try Repository.packageRepository.projectName(output: &output))⁩ עוזר לך לחסוך כסף, תשקול [לתרום](https://paypal.me/JeremyGiesbrecht) את חלק מזה.",
                        "",
                        "אם ⁨\(try Repository.packageRepository.projectName(output: &output))⁩ עוזר לך לחסוך זמן, תשקול להשתמש את חלק מזה [לתרום](\(Configuration.requiredRepositoryURL)) למיזם.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "כי ראוי הפועל לשכרו.", url: "https://www.bible.com/bible/380/LUK.10_1.HRNT", citation: "ישוע")
                    ]
                }
            default:
                readMe += try english(translation: .compatible(.englishCanada))
            }
        }

        return join(lines: readMe)
    }

    static func formatQuotationURL(chapter: String, originalKey: String, localization: ArbitraryLocalization?) -> String {
        var translationCode = "NIV"
        if let specific = localization {
            switch specific {
            case .compatible(let supported):
                switch supported {
                case .englishUnitedKingdom:
                    translationCode = "NIVUK"
                case .englishUnitedStates, .englishCanada:
                    translationCode = "NIV"
                case .deutschDeutschland:
                    translationCode = "SCH2000"
                case .françaisFrance:
                    translationCode = "SG21"
                case .ελληνικάΕλλάδα:
                    fatalError(message: ["TGV is unavailable in side‐by‐side."])
                case .עברית־ישראל:
                    fatalError(message: ["Hebrew is unavailable in side‐by‐side."])
                }
            default:
                fatalError(message: ["\(specific) does not have a corresponding translation yet."])
            }
        }

        let sanitizedChapter = chapter.replacingOccurrences(of: " ", with: "+")
        return "https://www.biblegateway.com/passage/?search=\(sanitizedChapter)&version=\(originalKey);\(translationCode)"
    }

    static func defaultQuotationURL(localization: ArbitraryLocalization?) -> String {
        if let chapter = Configuration.quotationChapter {
            return formatQuotationURL(chapter: chapter, originalKey: Configuration.quotationOriginalKey, localization: localization)
        } else {
            return Configuration.noValue
        }
    }

    static func localizationLinksMarkup(localization: ArbitraryLocalization?) -> String {
        var links: [String] = []
        for targetLocalization in Configuration.localizations {
            let link = targetLocalization.icon
            var url: StrictString
            if localization == nil {
                url = StrictString(readMePath(localization: targetLocalization).string)
            } else {
                url = readMeFilename(localization: targetLocalization)
            }
            url.replaceMatches(for: " ".scalars, with: "%20".scalars)

            links.append("[\(link)](\(url))")
        }
        return links.joined(separator: " • ") + " " + skipInJazzy
    }

    static func apiLinksMarkup(localization: ArbitraryLocalization?, output: inout Command.Output) throws -> String {
        let translation = Configuration.resolvedLocalization(for: localization)

        let urlString = Configuration.requiredDocumentationURL

        guard let url = URL(string: urlString) else {
            fatalError(message: [
                "The configured “Documentation URL” is invalid.",
                "",
                urlString
                ])
        }

        let apis: String
        switch translation {
        case .compatible(let specific):
            switch specific {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                apis = "APIs:"
            case .deutschDeutschland:
                apis = "SAPs:"
            case .françaisFrance:
                apis = "IPA :"
            case .ελληνικάΕλλάδα:
                apis = "ΔΠΕ:"
            case .עברית־ישראל:
                apis = "מת״י:"
            }
        case .unrecognized:
            return try apiLinksMarkup(localization: .compatible(.englishCanada), output: &output)
        }

        let libraries = try Repository.packageRepository.libraryProductTargets(output: &output)
        if url.lastPathComponent ∈ libraries {

            let root = url.deletingLastPathComponent().absoluteString
            let links = libraries.sorted().map() {
                return "[\($0)](\(root)\($0))"
            }
            return "\(apis) \(links.joined(separator: " • "))"
        } else {
            if libraries.isEmpty {
                return ""
            } else {
                return "[\(apis) \(libraries.sorted().joined(separator: " • "))](\(urlString))"
            }

        }
    }

    static func format(quotation: String, translation possibleTranslation: String?, url possibleURL: String?, citation possibleCitation: String?) -> String {
        var result = quotation.replacingOccurrences(of: "\n", with: "<br>")
        if let translation = possibleTranslation {
            result += "<br>"
            result += translation.replacingOccurrences(of: "\n", with: "<br>")
        }
        if let url = possibleURL {
            result = "[\(result)](\(url))"
        }
        if let citation = possibleCitation {
            let indent = [String](repeating: "&nbsp;", count: 100).joined()
            result += "<br>" + indent + "―" + citation
        }
        return "> " + result
    }

    static func quotationMarkup(localization: ArbitraryLocalization?) -> String {
        return format(quotation: Configuration.requiredQuotation, translation: Configuration.quotationTranslation(localization: localization), url: Configuration.quotationURL(localization: localization), citation: Configuration.citation(localization: localization))
    }

    static func relatedProjectsLinkMarkup(localization: ArbitraryLocalization?) -> String {

        var path: StrictString
        if localization ≠ nil {
            path = relatedProjectsFilename(localization: localization)
        } else {
            path = StrictString(ReadMe.relatedProjectsPath(localization: localization).string)
        }
        path.replaceMatches(for: " ".scalars, with: "%20".scalars)

        let translation = Configuration.resolvedLocalization(for: localization)
        switch translation {
        case .compatible(let specific):
            switch specific {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "(For a list of related projecs, see [here](\(path)).)" + " " + skipInJazzy
            case .deutschDeutschland:
                return "(Für eine Liste verwandter Projekte, siehe [hier](\(path)).)" + " " + skipInJazzy
            case .françaisFrance:
                return "(Pour une liste de projets lié, voir [ici](\(path)).)" + " " + skipInJazzy
            case .ελληνικάΕλλάδα:
                return "(Για ένα κατάλογο συγγενικών έργων, δείτε [εδώ](\(path)).)" + " " + skipInJazzy
            case .עברית־ישראל:
                return "(לרשימה של מיזמים קשורים, ראה [כאן](\(path)).)" + " " + skipInJazzy

            }
        case .unrecognized:
            return relatedProjectsLinkMarkup(localization: .compatible(.englishCanada))
        }
    }

    static func defaultInstallationInstructions(localization: ArbitraryLocalization?, output: inout Command.Output) throws -> String? {

        if try Repository.packageRepository.configuration.projectType() == .library {
            let translation = Configuration.resolvedLocalization(for: localization)

            var instructions: [String] = []

            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    instructions += [
                        "## Importing",
                        "",
                        "\(try Repository.packageRepository.projectName(output: &output)) is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .deutschDeutschland:
                    instructions += [
                        "## Einführung",
                        "",
                        "\(try Repository.packageRepository.projectName(output: &output)) ist für den Einsatz mit dem [Swift Package Manager](https://swift.org/package-manager/) vorgesehen.",
                        ""
                    ]
                case .françaisFrance:
                    instructions += [
                        "## Importation",
                        "",
                        "\(try Repository.packageRepository.projectName(output: &output)) est prévu pour utilisation avec le [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .ελληνικάΕλλάδα:
                    instructions += [
                        "## Εισαγωγή",
                        "",
                        "\(try Repository.packageRepository.projectName(output: &output)) προορίζεται για χρήση με το [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .עברית־ישראל:
                    instructions += [
                        "## ליבא",
                        "",
                        "יש ל־⁨\(try Repository.packageRepository.projectName(output: &output))⁩ מיועד של שימוש עם [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                }
            case .unrecognized:
                instructions += [
                    "## Importing",
                    "",
                    "\(try Repository.packageRepository.projectName(output: &output)) is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
                    ""
                ]
            }

            var dependencySummary: String
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    dependencySummary = "Simply add \(try Repository.packageRepository.projectName(output: &output)) as a dependency in `Package.swift`"
                case .deutschDeutschland:
                    dependencySummary = "Fügen Sie \(try Repository.packageRepository.projectName(output: &output)) einfach in der Abhängigkeitsliste in `Package.swift` hinzu"
                case .françaisFrance:
                    dependencySummary = "Ajoutez \(try Repository.packageRepository.projectName(output: &output)) simplement dans la liste des dépendances dans `Package.swift`"
                case .ελληνικάΕλλάδα:
                    dependencySummary = "Πρόσθεσε τον \(try Repository.packageRepository.projectName(output: &output)) απλά στο κατάλογο των εξαρτήσεων στο `Package.swift`"
                case .עברית־ישראל:
                    dependencySummary =
                    "תוסיף את ⁨\(try Repository.packageRepository.projectName(output: &output))⁩ בפשוט ברשימת תלות ב־`Package.swift`"
                }
            case .unrecognized:
                dependencySummary = "Simply add \(try Repository.packageRepository.projectName(output: &output)) as a dependency in `Package.swift`"
            }

            if let repository = try Repository.packageRepository.configuration.repositoryURL(),
                let currentVersion = Configuration.currentVersion {

                let colon: String
                switch translation {
                case .compatible(let specific):
                    switch specific {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .ελληνικάΕλλάδα, .עברית־ישראל:
                        colon = ":"
                    case .françaisFrance:
                        colon = " :"
                    }
                case .unrecognized:
                    colon = ":"
                }

                instructions += [
                    dependencySummary + colon,
                    "",
                    "```swift",
                    "let package = Package(",
                    "    ...",
                    "    dependencies: [",
                    "        ...",
                    "        .Package(url: \u{22}\(repository.absoluteString)\u{22}, versions: \u{22}\(currentVersion.string)\u{22} ..< \u{22}\(currentVersion.nextMajorVersion.string)\u{22}),",
                    "        ...",
                    "    ]",
                    ")",
                    "```"
                ]

            } else {

                switch translation {
                case .compatible(let specific):
                    switch specific {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                        instructions += [
                            dependencySummary + "."
                        ]
                    }
                case .unrecognized:
                    instructions += [
                        dependencySummary + "."
                    ]
                }
            }

            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    instructions += [
                        "",
                        "\(try Repository.packageRepository.projectName(output: &output)) can then be imported in source files:"
                    ]
                case .deutschDeutschland:
                    instructions += [
                        "",
                        "Dann kann \(try Repository.packageRepository.projectName(output: &output)) in Quelldateien eingeführt werden:"
                    ]
                case .françaisFrance:
                    instructions += [
                        "",
                        "Puis \(try Repository.packageRepository.projectName(output: &output)) peut être importé dans des fichiers sources :"
                    ]
                case .ελληνικάΕλλάδα:
                    instructions += [
                        "",
                        "Έπειτα \(try Repository.packageRepository.projectName(output: &output)) μπορεί να εισάγεται στα πηγαία αρχεία:"
                    ]
                case .עברית־ישראל:
                    instructions += [
                        "",
                        "אז יכול ליבא את ⁨\(try Repository.packageRepository.projectName(output: &output))⁩ בקבץי מקור:"
                    ]
                }
            case .unrecognized:
                instructions += [
                    "",
                    "\(try Repository.packageRepository.projectName(output: &output)) can then be imported in source files:"
                ]
            }

            instructions += [
                "",
                "```swift",
                "import \(Configuration.moduleName)",
                "```"
            ]

            return join(lines: instructions)
        }

        return nil
    }

    static func refreshReadMe(output: inout Command.Output) throws {

        var localizations = Configuration.localizations.map { Optional(
            $0) }
        localizations.append(nil)

        for localization in localizations {

            func key(_ name: String) -> String {
                return "[_\(name)_]"
            }

            var body = join(lines: [
                managementComment,
                "",
                try Configuration.readMe(localization: localization, output: &output)
                ])

            let localizationLinks = key("Localization Links")
            if body.contains(localizationLinks) {
                body = body.replacingOccurrences(of: localizationLinks, with: localizationLinksMarkup(localization: localization))
            }

            let apiLinks = key("API Links")
            if body.contains(apiLinks) {
                body = body.replacingOccurrences(of: apiLinks, with: try apiLinksMarkup(localization: localization, output: &output))
            }

            body = body.replacingOccurrences(of: key("Project"), with: String(try Repository.packageRepository.projectName(output: &output)))

            let shortDescription = key("Short Description")
            if body.contains(shortDescription) {
                body = body.replacingOccurrences(of: shortDescription, with: Configuration.requiredShortProjectDescription(localization: localization))
            }

            let quotation = key("Quotation")
            if body.contains(quotation) {
                body = body.replacingOccurrences(of: quotation, with: quotationMarkup(localization: localization))
            }

            let features = key("Features")
            if body.contains(features) {
                body = body.replacingOccurrences(of: features, with: Configuration.requiredFeatureList(localization: localization))
            }

            let relatedProjectsLink = key("Related Projects")
            if body.contains(relatedProjectsLink) {
                body = body.replacingOccurrences(of: relatedProjectsLink, with: relatedProjectsLinkMarkup(localization: localization))
            }

            let installationInsructions = key("Installation Instructions")
            if body.contains(installationInsructions) {
                body = body.replacingOccurrences(of: installationInsructions, with: Configuration.requiredInstallationInstructions(localization: localization, output: &output))
            }

            let repositoryURL = key("Repository URL")
            if body.contains(repositoryURL) {
                body = body.replacingOccurrences(of: repositoryURL, with: Configuration.requiredRepositoryURL)
            }

            let currentVersion = key("Current Version")
            if body.contains(currentVersion) {
                body = body.replacingOccurrences(of: currentVersion, with: Configuration.requiredCurrentVersion.string)
            }

            let nextMajorVersion = key("Next Major Version")
            if body.contains(nextMajorVersion) {
                body = body.replacingOccurrences(of: nextMajorVersion, with: Configuration.requiredCurrentVersion.nextMajorVersion.string)
            }

            let exampleUsage = key("Example Usage")
            if body.contains(exampleUsage) {
                var possibleReadMeExample: String?

                if let specific = localization?.code {
                    possibleReadMeExample = Examples.examples["Read‐Me: \(specific)"]
                }

                if possibleReadMeExample == nil ∧ localization == nil {
                    if let development = Configuration.developmentLocalization?.code {
                        possibleReadMeExample = Examples.examples["Read‐Me: \(development)"]
                    }

                    if possibleReadMeExample == nil {
                        possibleReadMeExample = Examples.examples["Read‐Me"]
                    }
                }
                guard let readMeExample = possibleReadMeExample else {
                    let name: String
                    if let specific = localization?.code {
                        name = "Read‐Me: \(specific)"
                    } else {
                        name = "Read‐Me"
                    }
                    fatalError(message: [
                        "There is no definition for the example named “\(name)”.",
                        "",
                        "Available example definitions:",
                        "",
                        join(lines: Examples.examples.keys.sorted())
                        ])
                }
                body = body.replacingOccurrences(of: exampleUsage, with: readMeExample)
            }

            let other = key("Other")
            if body.contains(other) {
                body = body.replacingOccurrences(of: other, with: Configuration.requiredOtherReadMeContent)
            }

            var readMe = File(possiblyAt: readMePath(localization: localization))
            readMe.body = body
            require() { try readMe.write(output: &output) }

            if ¬Configuration.relatedProjects(localization: localization).isEmpty
                ∧ (localization ≠ nil ∨ localizations.count == 1 /* Only unlocalized. */) {

                let translation = Configuration.resolvedLocalization(for: localization)

                var projects: [String]

                switch translation {
                case .compatible(let specific):
                    switch specific {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        projects = [
                            "# Related Projects",
                            "",
                            "### Table of Contents",
                            ""
                        ]
                    case .deutschDeutschland:
                        projects = [
                            "# Verwandte Projekte",
                            "",
                            "### Inhaltsverzeichnis",
                            ""
                        ]
                    case .françaisFrance:
                        projects = [
                            "# Projets liés",
                            "",
                            "### Table de matières",
                            ""
                        ]
                    case .ελληνικάΕλλάδα:
                        projects = [
                            "# Συγγενικά έργα",
                            "",
                            "### Πίνακας περιεχομένων",
                            ""
                        ]
                    case .עברית־ישראל:
                        projects = [
                            "# מיזמים קשורים",
                            "",
                            "### תוכן העניינים",
                            ""
                        ]
                    }
                case .unrecognized:
                    projects = [
                        "# Related Projects",
                        "",
                        "### Table of Contents",
                        ""
                    ]
                }

                func extractHeader(line: String) -> String {
                    var start = line.startIndex
                    guard line.clusters.advance(&start, over: "# ".clusters) else {
                        fatalError(message: [
                            "Error parsing section header:",
                            "",
                            "\(line)",
                            "",
                            "This may indicate a bug in Workspace."
                            ])
                    }
                    return String(line[start...])
                }

                func sanitize(headerAnchor: String) -> String {
                    return headerAnchor.replacingOccurrences(of: " ", with: "‐")
                }

                for line in Configuration.relatedProjects(localization: localization) {
                    if line.hasPrefix("# ") {
                        let header = extractHeader(line: line)
                        projects += [
                            "\u{2D} [\(header)](#\(sanitize(headerAnchor: header)))"
                        ]
                    }
                }
                for line in Configuration.relatedProjects(localization: localization) {
                    if line.hasPrefix("# ") {
                        let header = extractHeader(line: line)
                        projects += [
                            "",
                            "## <a name=\u{22}\(sanitize(headerAnchor: header))\u{22}>\(header)</a>"
                        ]
                    } else {
                        guard let colon = line.range(of: ": ") else {
                            fatalError(message: [
                                "Syntax error:",
                                "",
                                line,
                                "",
                                "Expected a line of the form:",
                                "",
                                "Name: https://url.to/repository"
                                ])
                        }

                        let name = String(line[..<colon.lowerBound])
                        let url = String(line[colon.upperBound...])
                        let configuration = Configuration.parseConfigurationFile(fromLinkedRepositoryAt: url)

                        let link: String
                        if let documentation = configuration[.documentationURL] {
                            link = documentation
                        } else {
                            link = url
                        }
                        projects += [
                            "",
                            "### [\(name)](\(link))"
                        ]

                        if var shortDescription = Configuration.localizedOptionValue(option: .shortProjectDescription, localization: localization, configuration: configuration) {
                            if shortDescription.contains("[_") { // The main project is not localized, but the linked configuration is.
                                if let parsedLocalizations = Configuration.parseLocalizations(shortDescription) {
                                    if let english = parsedLocalizations[.compatible(.englishCanada)] ?? parsedLocalizations[.compatible(.englishUnitedStates)] {
                                        shortDescription = english
                                    } else {
                                        shortDescription = parsedLocalizations.first?.value ?? ""
                                    }
                                }
                            }
                            projects += [
                                "",
                                shortDescription
                            ]
                        }
                    }
                }

                var relatedProjects = File(possiblyAt: relatedProjectsPath(localization: localization))
                relatedProjects.body = join(lines: projects)
                require() { try relatedProjects.write(output: &output) }
            }
        }
    }

    static func relinquishControl(output: inout Command.Output) {

        for localization in Configuration.localizations {
            var readMe = File(possiblyAt: readMePath(localization: localization))
            if let range = readMe.contents.range(of: managementComment) {
                print("Cancelling read‐me management...".formattedAsSectionHeader(), to: &output)
                readMe.contents.removeSubrange(range)
                try? readMe.write(output: &output)
            }
        }
    }
}
