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
import SDGCommandLine

enum ReadMe {

    // MARK: - Locations

    private static func documentationDirectory(for project: PackageRepository) -> URL {
        return project.url(for: "Documentation")
    }

    private static func locationOfDocumentationFile(named name: StrictString, for localization: String, in project: PackageRepository) -> URL {
        let icon = ContentLocalization.icon(for: localization) ?? StrictString("[" + localization + "]")
        let fileName: StrictString = icon + " " + name + ".md"
        return documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    private static func readMeLocation(for project: PackageRepository, localization: String) -> URL {
        return locationOfDocumentationFile(named: UserFacingText<ContentLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Read Me"
            case .deutschDeutschland:
                return "Lies mich"
            case .françaisFrance:
                return "Lisez moi"
            case .ελληνικάΕλλάδα:
                return "Με διαβάστε"
            case .עברית־ישראל:
                return "קרא אותי"
            }
        }).resolved(), for: localization, in: project)
    }

    // MARK: - Templates

    static let skipInJazzy: StrictString = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    static func localizationLinksMarkup(for project: PackageRepository, fromProjectRoot: Bool) throws -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in try project.configuration.localizations() {
            let linkText = ContentLocalization.icon(for: targetLocalization) ?? StrictString("[" + targetLocalization + "]")
            let absoluteURL = readMeLocation(for: project, localization: targetLocalization)
            var relativeURL: StrictString
            if fromProjectRoot {
                relativeURL = StrictString(absoluteURL.path(relativeTo: project.location))
            } else {
                relativeURL = StrictString(absoluteURL.path(relativeTo: documentationDirectory(for: project)))
            }
            relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

            var link: StrictString = "[" + linkText + "]"
            link += "(" + relativeURL + ")"
            links.append(link)
        }
        return StrictString(links.joined(separator: " • ".scalars)) + " " + skipInJazzy
    }

    static func defaultReadMeTemplate(for localization: String, project: PackageRepository) throws -> Template {
        var readMe: [StrictString] = [
            "[_Localization Links_]",
            ""
        ]

        notImplementedYet()

        return Template(source: StrictString(readMe.joined(separator: "\n".scalars)))
    }

    /*
    static func defaultReadMeTemplate(localization: ArbitraryLocalization?, output: inout Command.Output) throws -> String {

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
    }*/

    // MARK: - Refreshment

    private static func refreshReadMe(at location: URL, for localization: String, in project: PackageRepository, atProjectRoot: Bool, output: inout Command.Output) throws {
        var readMe = try project.configuration.readMe(for: localization, project: project)

        readMe.insert(try localizationLinksMarkup(for: project, fromProjectRoot: atProjectRoot), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Localization Links"
            }
        }))

        notImplementedYet()

        var file = try TextFile(possiblyAt: location)
        file.body = String(readMe.text)
        try file.writeChanges(for: project, output: &output)
    }

    /*

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
     }*/

    static func refreshReadMe(for project: PackageRepository, output: inout Command.Output) throws {
        let localizations = try project.configuration.localizations()
        for localization in localizations {
            let setting = LocalizationSetting(orderOfPrecedence: [localization] + localizations)
            try setting.do {
                try refreshReadMe(at: readMeLocation(for: project, localization: localization), for: localization, in: project, atProjectRoot: false, output: &output)
            }

            if localization == localizations.first {
                try setting.do {
                    try refreshReadMe(at: project.url(for: "README.md"), for: localization, in: project, atProjectRoot: true, output: &output)
                }
            }
        }
    }
}
