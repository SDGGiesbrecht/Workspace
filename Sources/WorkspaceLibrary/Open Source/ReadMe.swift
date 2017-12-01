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

    private static let documentationDirectoryName = "Documentation"
    private static func documentationDirectory(for project: PackageRepository) -> URL {
        return project.url(for: documentationDirectoryName)
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

    static func relatedProjectsLocation(for project: PackageRepository, localization: String) -> URL {
        return locationOfDocumentationFile(named: UserFacingText<ContentLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Related Projects"
            case .deutschDeutschland:
                return "Verwandte Projekte"
            case .françaisFrance:
                return "Projets liés"
            case .ελληνικάΕλλάδα:
                return "Συγγενικά έργα"
            case .עברית־ישראל:
                return "מיזמים קשורים"
            }
        }).resolved(), for: localization, in: project)
    }

    // MARK: - Templates

    static let skipInJazzy: StrictString = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    private static func localizationLinksMarkup(for project: PackageRepository, fromProjectRoot: Bool) throws -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in try project.configuration.localizations() {
            let linkText = ContentLocalization.icon(for: targetLocalization) ?? StrictString("[" + targetLocalization + "]")
            let absoluteURL = readMeLocation(for: project, localization: targetLocalization)
            var relativeURL = StrictString(absoluteURL.path(relativeTo: project.location))
            relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

            var link: StrictString = "[" + linkText + "]"
            link += "(" + relativeURL + ")"
            links.append(link)
        }
        return StrictString(links.joined(separator: " • ".scalars)) + " " + skipInJazzy
    }

    private static func operatingSystemList(for project: PackageRepository) throws -> StrictString {
        let supported = try OperatingSystem.cases.filter({ try project.configuration.supports($0) })
        let list = supported.map({ $0.isolatedName.resolved() }).joined(separator: " • ".scalars)
        return StrictString(list)
    }

    private static func apiLinksMarkup(for project: PackageRepository, output: inout Command.Output) throws -> StrictString {

        let baseURL = try project.configuration.requireDocumentationURL()
        let label = UserFacingText<ContentLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "APIs:"
            case .deutschDeutschland:
                return "SAPs"
            case .françaisFrance:
                return "IPA :"
            case .ελληνικάΕλλάδα:
                return "ΔΠΕ:"
            case .עברית־ישראל:
                return "מת״י:"
            }
        }).resolved()

        let links = try Repository.packageRepository.libraryProductTargets(output: &output).sorted().map { (name: String) -> StrictString in

            var link: StrictString = "[" + StrictString(name) + "]"
            link += "(" + StrictString(baseURL.appendingPathComponent(name).absoluteString) + ")"
            return link
        }

        return label + " " + StrictString(links.joined(separator: " • ".scalars))
    }

    private static func key(for testament: StrictString) throws -> StrictString {
        let old: StrictString = "תנ״ך"
        let new: StrictString = "ΚΔ"
        switch testament {
        case old:
            return "WLC"
        case new:
            return "SBLGNT"
        default:
            throw Configuration.invalidEnumerationValueError(for: .quotationTestament, value: String(testament), valid: [old, new])
        }
    }

    static func defaultQuotationURL(localization: String, project: PackageRepository) throws -> URL? {
        guard let chapter = try project.configuration.quotationChapter() else {
            return nil
        }
        let translationCode = UserFacingText<ContentLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishUnitedKingdom,
                 .ελληνικάΕλλάδα, .עברית־ישראל /* No side‐by‐side available. */:
                return "NIVUK"
            case .englishUnitedStates, .englishCanada:
                return "NIV"
            case .deutschDeutschland:
                return "SCH2000"
            case .françaisFrance:
                return "SG21"
            }
        }).resolved()

        let sanitizedChapter = chapter.replacingMatches(for: " ".scalars, with: "+".scalars)
        let originalKey = try key(for: try project.configuration.requireQuotationTestament())
        return URL(string: "https://www.biblegateway.com/passage/?search=\(sanitizedChapter)&version=\(originalKey);\(translationCode)")
    }

    private static func quotationMarkup(localization: String, project: PackageRepository) throws -> StrictString {
        var result = [try project.configuration.requireQuotation()]
        if let translation = try project.configuration.quotationTranslation(localization: localization) {
            result += [translation]
        }
        if let url = try project.configuration.quotationURL(localization: localization, project: project) {
            let components: [StrictString] = ["[", result.joinAsLines(), "](", StrictString(url.absoluteString), ")"]
            result = [components.joined()]
        }
        if let citation = try project.configuration.citation(localization: localization) {
            let indent = StrictString([String](repeating: "&nbsp;", count: 100).joined())
            result += [indent + "―" + citation]
        }

        return StrictString("> ") + StrictString(result.joined(separator: "\n".scalars)).replacingMatches(for: "\n".scalars, with: "<br>".scalars)
    }

    private static func relatedProjectsLinkMarkup(for project: PackageRepository, localization: String) -> StrictString {
        let absoluteURL = relatedProjectsLocation(for: project, localization: localization)
        var relativeURL = StrictString(absoluteURL.path(relativeTo: project.location))
        relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

        let link = UserFacingText<ContentLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return StrictString("(For a list of related projects, see [here](\(relativeURL)).)")
            case .deutschDeutschland:
                return StrictString("(Für eine Liste verwandter Projekte, siehe [hier](\(relativeURL)).)")
            case .françaisFrance:
                return StrictString("(Pour une liste de projets lié, voir [ici](\(relativeURL)).)")
            case .ελληνικάΕλλάδα:
                return StrictString("(Για ένα κατάλογο συγγενικών έργων, δείτε [εδώ](\(relativeURL)).)")
            case .עברית־ישראל:
                return StrictString("(לרשימה של מיזמים קשורים, ראה [כאן](\(relativeURL)).)")

            }
        }).resolved()
        return link + " " + skipInJazzy
    }

    static func defaultInstallationInstructions(localization: String, project: PackageRepository, output: inout Command.Output) throws -> Template? {
        var result: [StrictString] = []

        if try project.isWorkspaceProject(output: &output),
            // [_Workaround: This should check for executable targets in general._]
            let repository = try project.configuration.repositoryURL(),
            let version = try project.configuration.currentVersion() {
            let package = StrictString(try project.packageName(output: &output))

            // [_Workaround: This should check for executable targets in general._]
            let executableTargets = ["workspace", "arbeitsbereich"].sorted()

            result += [
                "## " + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Installation"
                    case .deutschDeutschland:
                        return "Installation"
                    case .françaisFrance:
                        return "Installation"
                    case .ελληνικάΕλλάδα:
                        return "Εγκατάσταση"
                    case .עברית־ישראל:
                        return "התקנה"
                    }
                }).resolved(),
                "",
                UserFacingText<ContentLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Paste the following into a terminal to install or update `\(package)`:")
                    case .deutschDeutschland:
                        return StrictString("Setze folgendes in ein Terminal ein, um `\(package)` zu installieren oder aktualisieren:")
                    case .françaisFrance:
                        return StrictString("Collez le suivant dans un terminal pour installer `\(package)` ou mettre `\(package)` à jour:")
                    case .ελληνικάΕλλάδα:
                        return StrictString("Κόλλα αυτό σε ένα τερματικό για να εγκαταστήσετε ή ενημέρωσετε `\(package)`:")
                    case .עברית־ישראל:
                        /*א*/ return StrictString("הדבק או הדביקי את זה במסוף להתקין או לעדכן את `\(package)`:")
                    }
                }).resolved(),
                "",
                "```shell",
                StrictString("curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s \(package) \u{22}\(repository.absoluteString)\u{22} \(version.string) \u{22}\(executableTargets.first!) help\u{22} " + executableTargets.joined(separator: " ")),
                "```"
            ]
        }

        let libraries = try project.libraryProductTargets(output: &output).sorted()
        if ¬libraries.isEmpty {
            result += [
                "## " + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Importing"
                    case .deutschDeutschland:
                        return "Einführung"
                    case .françaisFrance:
                        return "Importation"
                    case .ελληνικάΕλλάδα:
                        return "Εισαγωγή"
                    case .עברית־ישראל:
                        return "ליבא"
                    }
                }).resolved(),
                "",
                UserFacingText<ContentLocalization, StrictString>({ (localization, package) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("`\(package)` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).")
                    case .deutschDeutschland:
                        return StrictString("`\(package)` ist für den Einsatz mit dem [Swift‐Paketverwalter](https://swift.org/package-manager/) vorgesehen.")
                    case .françaisFrance:
                        return StrictString("`\(package)` est prévu pour utilisation avec le [Gestionnaire de paquets Swift](https://swift.org/package-manager/).")
                    case .ελληνικάΕλλάδα:
                        return StrictString("`\(package)` προορίζεται για χρήση με τον [διαχειριστή πακέτων του Σουιφτ](https://swift.org/package-manager/).")
                    case .עברית־ישראל:
                        /*א*/ return StrictString("יש ל־`\(package)` מיועד של שימוש עם [מנהל חבילת סוויפט](https://swift.org/package-manager/).")
                    }
                }).resolved(using: StrictString(try project.packageName(output: &output))),
                ""
            ]

            let dependencySummary: StrictString = UserFacingText<ContentLocalization, StrictString>({ (localization, package) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return StrictString("Simply add `\(package)` as a dependency in `Package.swift`")
                case .deutschDeutschland:
                    return StrictString("Fügen Sie `\(package)` einfach in der Abhängigkeitsliste in `Package.swift` hinzu")
                case .françaisFrance:
                    return StrictString("Ajoutez `\(package)` simplement dans la liste des dépendances dans `Package.swift`")
                case .ελληνικάΕλλάδα:
                    return StrictString("Πρόσθεσε τον `\(package)` απλά στο κατάλογο των εξαρτήσεων στο `Package.swift`")
                case .עברית־ישראל:
                    /*א*/ return StrictString("תוסיף את `\(package)` בפשוט ברשימת תלות ב־`Package.swift`")
                }
            }).resolved(using: StrictString(try project.packageName(output: &output)))

            if let repository = try project.configuration.repositoryURL(),
                let currentVersion = try project.configuration.currentVersion() {
                var versionSpecification: String
                if currentVersion.major == 0 {
                    versionSpecification = ".upToNextMinor(from: Version(\(currentVersion.major), \(currentVersion.minor), \(currentVersion.patch)))"
                } else {
                    versionSpecification = "from: Version(\(currentVersion.major), \(currentVersion.minor), \(currentVersion.patch))"
                }

                result += [
                    dependencySummary + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .ελληνικάΕλλάδα, .עברית־ישראל:
                            return ":"
                        case .françaisFrance:
                            return " :"
                        }
                    }).resolved(),
                    "",
                    "```swift",
                    StrictString("let ") + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "package"
                        case .deutschDeutschland:
                            return "paket"
                        case .françaisFrance:
                            return "paquet"
                        case .ελληνικάΕλλάδα:
                            return "πακέτο"
                        case .עברית־ישראל:
                            return "חבילה"
                        }
                    }).resolved() + " = Package(",
                    (StrictString("    name: \u{22}") + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "MyPackage"
                        case .deutschDeutschland:
                            return "MeinPaket"
                        case .françaisFrance:
                            return "MonPaquet"
                        case .ελληνικάΕλλάδα:
                            return "ΠακέτοΜου"
                        case .עברית־ישראל:
                            return "חבילה־שלי"
                        }
                    }).resolved() + StrictString("\u{22},")) as StrictString,
                    "    dependencies: [",
                    StrictString("        .package(url: \u{22}\(repository.absoluteString)\u{22}, \(versionSpecification)),"),
                    "    ],",
                    "    targets: [",
                    (StrictString("        .target(name: \u{22}") + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "MyTarget"
                        case .deutschDeutschland:
                            return "MeinZiel"
                        case .françaisFrance:
                            return "MaCible"
                        case .ελληνικάΕλλάδα:
                            return "ΣτόχοςΜου"
                        case .עברית־ישראל:
                            return "מטרה־שלי"
                        }
                    }).resolved() + StrictString("\u{22}, dependencies: [")) as StrictString
                ]
                for library in libraries {
                    result += [StrictString("            .productItem(name: \u{22}\(library)\u{22}, package: \u{22}\(try project.packageName(output: &output))\u{22}),")]
                }
                result += [
                    "        ])",
                    "    ]",
                    ")",
                    "```"
                ]
            } else {
                result += [dependencySummary + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                        return "."
                    }
                }).resolved()]
            }

            result += [
                "",
                UserFacingText<ContentLocalization, StrictString>({ (localization, package) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("`\(package)` can then be imported in source files:")
                    case .deutschDeutschland:
                        return StrictString("Dann kann `\(package)` in Quelldateien eingeführt werden:")
                    case .françaisFrance:
                        return StrictString("Puis `\(package)` peut être importé dans des fichiers sources :")
                    case .ελληνικάΕλλάδα:
                        return StrictString("Έπειτα `\(package)` μπορεί να εισάγεται στα πηγαία αρχεία:")
                    case .עברית־ישראל:
                        /*א*/ return StrictString("אז יכול ליבא את `\(package)` בקבץי מקור:")
                    }
                }).resolved(using: StrictString(try project.packageName(output: &output))),
                "",
                "```swift"
            ]
            for library in libraries {
                result += [StrictString("import \(library)")]
            }
            result += [
                "```"
            ]
        }

        if result == [] {
            return nil
        } else {
            return Template(source: result.joinAsLines())
        }
    }

    static func defaultExampleUsageTemplate(for localization: String, project: PackageRepository, output: inout Command.Output) throws -> Template? {
        let prefixes = InterfaceLocalization.cases.map { (localization) in
            return UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishCanada:
                    return "Read‐Me"
                }
            }).resolved(for: localization)
        }
        var suffixes = [localization]
        if let icon = ContentLocalization.icon(for: localization) {
            suffixes += [String(icon)]
        }

        var source: [StrictString] = []

        let examples = Examples.examples
        for (key, _) in examples {
            for prefix in prefixes {
                for suffix in suffixes {
                    if key.hasPrefix(String(prefix + " "))
                        ∧ key.hasSuffix(" " + suffix) {
                        source += [
                            "",
                            "[\u{5F}Example: " + StrictString(key) + "_]"
                        ]
                    }
                }
            }
        }

        while source.first?.isEmpty == true {
            source.removeFirst()
        }
        if source.isEmpty {
            return nil
        } else {
            return Template(source: source.joinAsLines())
        }
    }

    static func defaultReadMeTemplate(for localization: String, project: PackageRepository, output: inout Command.Output) throws -> Template {

        var readMe: [StrictString] = [
            "[_Localization Links_]",
            ""
        ]
        readMe += [
            "[_Operating System List_]",
            ""
        ]
        if try project.configuration.optionIsDefined(.documentationURL) {
            readMe += [
                "[_API Links_]",
                ""
            ]
        }

        readMe += ["# [_Project_]"]
        if try project.configuration.optionIsDefined(.shortProjectDescription) {
            readMe += [
                "",
                "[_Short Description_]"
            ]
        }
        if try project.configuration.optionIsDefined(.quotation) {
            readMe += [
                "",
                "[_Quotation_]"
            ]
        }

        if try project.configuration.optionIsDefined(.featureList) {
            let header = UserFacingText<ContentLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Features"
                case .deutschDeutschland:
                    return "Merkmale"
                case .françaisFrance:
                    return "Fonctionnalités"
                case .ελληνικάΕλλάδα:
                    return "Χαρακτηριστικά"
                case .עברית־ישראל:
                    return "תכונות"
                }
            }).resolved()

            readMe += [
                "",
                StrictString("## ") + header,
                "",
                "[_Features_]"
            ]
        }
        if try project.configuration.optionIsDefined(.relatedProjects) {
            readMe += [
                "",
                "[_Related Projects_]"
            ]
        }

        if (try project.configuration.installationInstructions(for: localization, project: project, output: &output)) ≠ nil {
            readMe += [
                "",
                "[_Installation Instructions_]"
            ]
        }

        if (try project.configuration.exampleUsage(for: localization, project: project, output: &output)) ≠ nil {
            let header = UserFacingText<ContentLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Example Usage"
                case .deutschDeutschland:
                    return "Verwendungsbeispiele"
                case .françaisFrance:
                    return "Examples d’utilisation"
                case .ελληνικάΕλλάδα:
                    return "Παράδειγματα χρήσης"
                case .עברית־ישראל:
                    return "דוגמות שימוש"
                }
            }).resolved()

            readMe += [
                "",
                StrictString("## ") + header,
                "",
                "[\u{5F}Example Usage_]"
            ]
        }

        if try project.configuration.optionIsDefined(.otherReadMeContent) {
            readMe += [
                "",
                "[_Other_]"
            ]
        }

        if try project.configuration.optionIsDefined(.readMeAboutSection) {
            let header = UserFacingText<ContentLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "About"
                case .deutschDeutschland:
                    return "Über"
                case .françaisFrance:
                    return "À propos"
                case .ελληνικάΕλλάδα:
                    return "Πληροφορίες"
                case .עברית־ישראל:
                    return "אודות"
                }
            }).resolved()

            readMe += [
                "",
                StrictString("## ") + header,
                "",
                "[_About_]"
            ]
        }

        return Template(source: StrictString(readMe.joined(separator: "\n".scalars)))
    }

    // MARK: - Refreshment

    private static func refreshReadMe(at location: URL, for localization: String, in project: PackageRepository, atProjectRoot: Bool, output: inout Command.Output) throws {
        var readMe = try project.configuration.readMe(for: localization, project: project, output: &output)

        // Section Elements

        try readMe.insert(resultOf: { try project.configuration.requireFeatureList(for: localization) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Features"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireInstallationInstructions(for: localization, project: project, output: &output).text }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Installation Instructions"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireExampleUsage(for: localization, project: project, output: &output).text }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Example Usage"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireOtherReadMeContent(for: localization, project: project, output: &output).text }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Other"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireReadMeAboutSectionTemplate(for: localization, project: project, output: &output).text }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "About"
            }
        }))

        // Line Elements

        readMe.insert(try localizationLinksMarkup(for: project, fromProjectRoot: atProjectRoot), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Localization Links"
            }
        }))
        readMe.insert(try operatingSystemList(for: project), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Operating System List"
            }
        }))
        try readMe.insert(resultOf: { try apiLinksMarkup(for: project, output: &output) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "API Links"
            }
        }))
        try readMe.insert(resultOf: { try project.configuration.requireShortProjectDescription(for: localization) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Short Description"
            }
        }))
        try readMe.insert(resultOf: { try quotationMarkup(localization: localization, project: project) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Quotation"
            }
        }))
        readMe.insert(resultOf: { relatedProjectsLinkMarkup(for: project, localization: localization) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Related Projects"
            }
        }))

        // Word Elements

        readMe.insert(try project.projectName(output: &output), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Project"
            }
        }))
        try readMe.insert(resultOf: { StrictString(try project.configuration.requireRepositoryURL().absoluteString) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Repository URL"
            }
        }))
        try readMe.insert(resultOf: { StrictString(try project.configuration.requireCurrentVersion().string) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Current Version"
            }
        }))

        for (key, example) in Examples.examples {
            readMe.insert([
                "```swift",
                StrictString(example),
                "```"
                ].joinAsLines(), for: UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Example: \(key)")
                    }
                }))
        }

        var body = String(readMe.text)
        if ¬atProjectRoot {
            // Fix links according to location.
            let prefix = "]("
            let searchTerm: String = prefix + documentationDirectory(for: project).path(relativeTo: project.location) + "/"
            body.scalars.replaceMatches(for: searchTerm.scalars, with: prefix.scalars)
        }

        var file = try TextFile(possiblyAt: location)
        file.body = body
        try file.writeChanges(for: project, output: &output)
    }

    private static func refreshRelatedProjects(at location: URL, for localization: String, in project: PackageRepository, output: inout Command.Output) throws {

        if let relatedProjectURLs = try project.configuration.relatedProjects() {
            var markdown: [StrictString] = [
                StrictString("# ") + UserFacingText<ContentLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Related Projects"
                    case .deutschDeutschland:
                        return "Verwandte Projekte"
                    case .françaisFrance:
                        return "Projets liés"
                    case .ελληνικάΕλλάδα:
                        return "Συγγενικά έργα"
                    case .עברית־ישראל:
                        return "מיזמים קשורים"
                    }
                }).resolved(),
            ]

            for url in relatedProjectURLs {

                let package = Repository.linkedRepository(from: url)
                let name: StrictString
                if let packageName = try? package.projectName(output: &output) {
                    name = packageName
                } else {
                    name = StrictString(url.lastPathComponent)
                }

                markdown += [
                    "",
                    StrictString("### [\(name)](\(url.absoluteString))")
                ]

                if let succeeded = try? package.configuration.shortProjectDescription(for: localization),
                    let description = succeeded {
                    markdown += [
                        "",
                        description
                    ]
                }
            }

            let body = String(markdown.joinAsLines())
            var file = try TextFile(possiblyAt: location)
            file.body = body
            try file.writeChanges(for: project, output: &output)
        } else {
            project.delete(location, output: &output)
        }
    }

    static func refreshReadMe(for project: PackageRepository, output: inout Command.Output) throws {
        let localizations = try project.configuration.localizations()
        for localization in localizations {
            let setting = LocalizationSetting(orderOfPrecedence: [localization] + localizations)
            try setting.do {
                try refreshReadMe(at: readMeLocation(for: project, localization: localization), for: localization, in: project, atProjectRoot: false, output: &output)
                try refreshRelatedProjects(at: relatedProjectsLocation(for: project, localization: localization), for: localization, in: project, output: &output)
            }

            if localization == localizations.first {
                try setting.do {
                    try refreshReadMe(at: project.url(for: "README.md"), for: localization, in: project, atProjectRoot: true, output: &output)
                }
            }
        }

        // Deprecated file locations.
        project.delete(project.url(for: "Documentation/Related Projects.md"), output: &output)
    }
}
