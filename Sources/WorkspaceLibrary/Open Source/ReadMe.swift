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
    
    private static func relatedProjectsLocation(for project: PackageRepository, localization: String) -> URL {
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
    
    static func localizationLinksMarkup(for project: PackageRepository, fromProjectRoot: Bool) throws -> StrictString {
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
    
    static func operatingSystemList(for project: PackageRepository) throws -> StrictString {
        let supported = try OperatingSystem.cases.filter({ try project.configuration.supports($0) })
        let list = supported.map({ $0.isolatedName.resolved() }).joined(separator: " • ".scalars)
        return StrictString(list)
    }
    
    static func apiLinksMarkup(for project: PackageRepository, output: inout Command.Output) throws -> StrictString {
        
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
    
    static func key(for testament: StrictString) throws -> StrictString {
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
    
    static func quotationMarkup(localization: String, project: PackageRepository) throws -> StrictString {
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
    
    static func relatedProjectsLinkMarkup(for project: PackageRepository, localization: String) -> StrictString {
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
                "```",
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
                    }).resolved() + StrictString("\u{22}, dependencies: [")) as StrictString,
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
        
        notImplementedYet()
        
        return Template(source: StrictString(readMe.joined(separator: "\n".scalars)))
    }
    
    /*
     static func defaultReadMeTemplate(localization: ArbitraryLocalization?, output: inout Command.Output) throws -> String {
     
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
        var readMe = try project.configuration.readMe(for: localization, project: project, output: &output)
        
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
        readMe.insert(try project.projectName(output: &output), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Project"
            }
        }))
        try readMe.insert(resultOf: { try project.configuration.requireShortProjectDescription(for: localization, project: project) }, for: UserFacingText({ (localization, _) in
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
        
        try readMe.insert(resultOf: { try project.configuration.requireFeatureList(for: localization) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Features"
            }
        }))
        readMe.insert(resultOf: { relatedProjectsLinkMarkup(for: project, localization: localization) }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Related Projects"
            }
        }))
        
        try readMe.insert(resultOf: { try project.configuration.requireInstallationInstructions(for: localization, project: project, output: &output).text }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Installation Instructions"
            }
        }))
        
        notImplementedYet()
        
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
    
    /*
     
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
