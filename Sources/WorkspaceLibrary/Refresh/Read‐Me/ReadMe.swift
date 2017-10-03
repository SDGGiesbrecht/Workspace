/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

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

    static func defaultReadMeTemplate(localization: ArbitraryLocalization?) -> String {
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

        if Configuration.installationInstructions(localization: localization) ≠ nil {
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
            func english(translation: ArbitraryLocalization) -> [String] {
                return [
                    "",
                    "## About",
                    "",
                    "The \(Configuration.projectName) project is maintained by Jeremy David Giesbrecht.",
                    "",
                    "If \(Configuration.projectName) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
                    "",
                    "If \(Configuration.projectName) saves you time, consider devoting some of it to [contributing](\(Configuration.requiredRepositoryURL)) back to the project.",
                    "",
                    format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "For the worker is worthy of his wages.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                ]
            }
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    readMe += english(translation: translation)
                case .deutschDeutschland:
                    readMe += [
                        "",
                        "## Über",
                        "",
                        "Das \(Configuration.projectName)‐Projekt wird von Jeremy David Giesbrecht erhalten.",
                        "",
                        "Wenn \(Configuration.projectName) Ihnen Geld sparrt, denken Sie darüber, etwas davon zu [spenden](https://paypal.me/JeremyGiesbrecht).",
                        "",
                        "Wenn \(Configuration.projectName) Inhen Zeit sparrt, denken Sie darüber, etwas davon zu gebrauchen, um zum Projekt [beizutragen](\(Configuration.requiredRepositoryURL)).",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "Denn der Arbeiter ist seines Lohns würdig.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                    ]
                case .françaisFrance:
                    readMe += [
                        "",
                        "## À propos",
                        "",
                        "Le projet \(Configuration.projectName) est maintenu par Jeremy David Giesbrecht.",
                        "",
                        "Si \(Configuration.projectName) vous permet d’économiser de l’argent, considérez à en [donner](https://paypal.me/JeremyGiesbrecht).",
                        "",
                        "Si \(Configuration.projectName) vous permet d’économiser du temps, considérez à en utiliser à [contribuer](\(Configuration.requiredRepositoryURL)) au projet.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "Car le travailleur est digne de son salaire.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: localization), citation: "\u{200E}ישוע/Yeshuʼa")
                    ]
                case .ελληνικάΕλλάδα:
                    readMe += [
                        "",
                        "## Πληροφορίες",
                        "",
                        "Το \(Configuration.projectName) έργο διατηρείται από τον Τζέρεμι Ντάβιτ Γκίσμπρεχτ (Jeremy David Giesbrecht).",
                        "",
                        // οικονομώ
                        "Αν το \(Configuration.projectName) οικονομάει το χρήματα σας, σκεφτείτε να [δορίζετε](https://paypal.me/JeremyGiesbrecht) μερικά από αυτά.",
                        "",
                        "Αν το \(Configuration.projectName) οικονομάει τον χρόνο σας, σκεφτείτε να τον κάνετε χρήτη μερικού από αυτό ώστε να [συνεισφέρετε](\(Configuration.requiredRepositoryURL)) του έργου.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: nil, url: "https://www.bible.com/bible/209/LUK.10.byz04", citation: "\u{200E}ישוע/Ιεσούα")
                    ]
                case .עברית־ישראל:
                    readMe += [
                        "",
                        "## אודות",
                        "",
                        "⁨\(Configuration.projectName)⁩ המיזם מתוחזק על ידי ג׳רמי דוויט גיסברכט (⁧Jeremy David Giesbrecht⁩).",
                        "",
                        "אם ⁨\(Configuration.projectName)⁩ עוזר לך לחסוך כסף, תשקול [לתרום](https://paypal.me/JeremyGiesbrecht) את חלק מזה.",
                        "",
                        "אם ⁨\(Configuration.projectName)⁩ עוזר לך לחסוך זמן, תשקול להשתמש את חלק מזה [לתרום](\(Configuration.requiredRepositoryURL)) למיזם.",
                        "",
                        format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "כי ראוי הפועל לשכרו.", url: "https://www.bible.com/bible/380/LUK.10_1.HRNT", citation: "ישוע")
                    ]
                }
            default:
                readMe += english(translation: .compatible(.englishCanada))
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

    static func apiLinksMarkup(localization: ArbitraryLocalization?) -> String {
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
            return apiLinksMarkup(localization: .compatible(.englishCanada))
        }

        let operatingSystems = OperatingSystem.all.filter({ $0.isSupportedByProject }).map({ "\($0)" })
        if url.lastPathComponent ∈ Set(operatingSystems) {

            let root = url.deletingLastPathComponent().absoluteString
            let links = operatingSystems.map() {
                return "[\($0)](\(root)\($0))"
            }
            return "\(apis) \(links.joined(separator: " • "))"
        } else {
            return "[\(apis) \(operatingSystems.joined(separator: " • "))](\(urlString))"
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

    static func defaultInstallationInstructions(localization: ArbitraryLocalization?) -> String? {

        if Configuration.projectType == .library {
            let translation = Configuration.resolvedLocalization(for: localization)

            var instructions: [String] = []

            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    instructions += [
                        "## Importing",
                        "",
                        "\(Configuration.projectName) is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .deutschDeutschland:
                    instructions += [
                        "## Einführung",
                        "",
                        "\(Configuration.projectName) ist für den Einsatz mit dem [Swift Package Manager](https://swift.org/package-manager/) vorgesehen.",
                        ""
                    ]
                case .françaisFrance:
                    instructions += [
                        "## Importation",
                        "",
                        "\(Configuration.projectName) est prévu pour utilisation avec le [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .ελληνικάΕλλάδα:
                    instructions += [
                        "## Εισαγωγή",
                        "",
                        "\(Configuration.projectName) προορίζεται για χρήση με το [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                case .עברית־ישראל:
                    instructions += [
                        "## ליבא",
                        "",
                        "יש ל־⁨\(Configuration.projectName)⁩ מיועד של שימוש עם [Swift Package Manager](https://swift.org/package-manager/).",
                        ""
                    ]
                }
            case .unrecognized:
                instructions += [
                    "## Importing",
                    "",
                    "\(Configuration.projectName) is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
                    ""
                ]
            }

            var dependencySummary: String
            switch translation {
            case .compatible(let specific):
                switch specific {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    dependencySummary = "Simply add \(Configuration.projectName) as a dependency in `Package.swift`"
                case .deutschDeutschland:
                    dependencySummary = "Fügen Sie \(Configuration.projectName) einfach in der Abhängigkeitsliste in `Package.swift` hinzu"
                case .françaisFrance:
                    dependencySummary = "Ajoutez \(Configuration.projectName) simplement dans la liste des dépendances dans `Package.swift`"
                case .ελληνικάΕλλάδα:
                    dependencySummary = "Πρόσθεσε τον \(Configuration.projectName) απλά στο κατάλογο των εξαρτήσεων στο `Package.swift`"
                case .עברית־ישראל:
                    dependencySummary =
                    "תוסיף את ⁨\(Configuration.projectName)⁩ בפשוט ברשימת תלות ב־`Package.swift`"
                }
            case .unrecognized:
                dependencySummary = "Simply add \(Configuration.projectName) as a dependency in `Package.swift`"
            }

            if let repository = Configuration.repositoryURL,
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
                    "        .Package(url: \u{22}\(repository)\u{22}, versions: \u{22}\(currentVersion)\u{22} ..< \u{22}\(currentVersion.nextMajorVersion)\u{22}),",
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
                        "\(Configuration.projectName) can then be imported in source files:"
                    ]
                case .deutschDeutschland:
                    instructions += [
                        "",
                        "Dann kann \(Configuration.projectName) in Quelldateien eingeführt werden:"
                    ]
                case .françaisFrance:
                    instructions += [
                        "",
                        "Puis \(Configuration.projectName) peut être importé dans des fichiers sources :"
                    ]
                case .ελληνικάΕλλάδα:
                    instructions += [
                        "",
                        "Έπειτα \(Configuration.projectName) μπορεί να εισάγεται στα πηγαία αρχεία:"
                    ]
                case .עברית־ישראל:
                    instructions += [
                        "",
                        "אז יכול ליבא את ⁨\(Configuration.projectName)⁩ בקבץי מקור:"
                    ]
                }
            case .unrecognized:
                instructions += [
                    "",
                    "\(Configuration.projectName) can then be imported in source files:"
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

    static func refreshReadMe() {

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
                Configuration.readMe(localization: localization)
                ])

            let localizationLinks = key("Localization Links")
            if body.contains(localizationLinks) {
                body = body.replacingOccurrences(of: localizationLinks, with: localizationLinksMarkup(localization: localization))
            }

            let apiLinks = key("API Links")
            if body.contains(apiLinks) {
                body = body.replacingOccurrences(of: apiLinks, with: apiLinksMarkup(localization: localization))
            }

            body = body.replacingOccurrences(of: key("Project"), with: Configuration.projectName)

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
                body = body.replacingOccurrences(of: installationInsructions, with: Configuration.requiredInstallationInstructions(localization: localization))
            }

            let repositoryURL = key("Repository URL")
            if body.contains(repositoryURL) {
                body = body.replacingOccurrences(of: repositoryURL, with: Configuration.requiredRepositoryURL)
            }

            let currentVersion = key("Current Version")
            if body.contains(currentVersion) {
                body = body.replacingOccurrences(of: currentVersion, with: "\(Configuration.requiredCurrentVersion)")
            }

            let nextMajorVersion = key("Next Major Version")
            if body.contains(nextMajorVersion) {
                body = body.replacingOccurrences(of: nextMajorVersion, with: "\(Configuration.requiredCurrentVersion.nextMajorVersion)")
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
            require() { try readMe.write() }

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
                require() { try relatedProjects.write() }
            }
        }
    }

    static func relinquishControl() {

        for localization in Configuration.localizations {
            var readMe = File(possiblyAt: readMePath(localization: localization))
            if let range = readMe.contents.range(of: managementComment) {
                printHeader(["Cancelling read‐me management..."])
                readMe.contents.removeSubrange(range)
                try? readMe.write()
            }
        }
    }
}
