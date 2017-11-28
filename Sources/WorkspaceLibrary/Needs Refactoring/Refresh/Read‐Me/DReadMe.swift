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

struct DReadMe {

    static let skipInJazzy = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"
/*
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
        notImplementedYetAndCannotReturn()
        /*
        if localization ≠ nil {
            return RelativePath("Documentation/\(relatedProjectsFilename(localization: localization))")
        } else {
            if let development = try Repository.packageRepository.configuration.developmentLocalization() {
                return relatedProjectsPath(localization: development)
            } else {
                return RelativePath("Documentation/\(relatedProjectsFilename(localization: localization))")
            }
        }*/
    }

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

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

    static func relatedProjectsLinkMarkup(localization: ArbitraryLocalization?) -> String {

        var path: StrictString
        if localization ≠ nil {
            path = relatedProjectsFilename(localization: localization)
        } else {
            path = StrictString(DReadMe.relatedProjectsPath(localization: localization).string)
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
    }*/
}
