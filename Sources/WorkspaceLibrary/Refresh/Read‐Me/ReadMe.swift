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

import SDGLogic

struct ReadMe {
    
    static func readMeFilename(localization: String?) -> String {
        return "Read Me"
    }
    static func readMePath(localization: String?) -> RelativePath {
        if let specific = localization {
            return RelativePath("Documentation/\(specific)/\(readMeFilename(localization: localization))—\(specific).md")
        } else {
            return RelativePath("README.md")
        }
    }
    static func relatedProjectsFilename(localization: String?) -> String {
        return "Related Projects"
    }
    static func relatedProjectsPath(localization: String?) -> RelativePath {
        if let specific = localization {
            return RelativePath("Documentation/\(specific)/\(relatedProjectsFilename(localization: localization))—\(specific).md")
        } else {
            if let development = Configuration.developmentLocalization {
                return relatedProjectsPath(localization: development)
            } else {
                return RelativePath("Documentation/\(relatedProjectsFilename(localization: localization)).md")
            }
        }
    }
    
    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()
    
    static let defaultReadMeTemplate: String = {
        var readMe: [String] = []
        
        if ¬Configuration.localizations.isEmpty {
            readMe += [
                "[_Localization Links_]",
                "",
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
        
        if Configuration.shortProjectDescription ≠ nil {
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
        
        if Configuration.featureList ≠ nil {
            readMe += [
                "",
                "## Features",
                "",
                "[_Features_]"
            ]
        }
        
        if ¬Configuration.relatedProjects.isEmpty {
            readMe += [
                "",
                "[_Related Projects_]"
            ]
        }
        
        if Configuration.installationInstructions ≠ nil {
            readMe += [
                "",
                "[_Installation Instructions_]"
            ]
        }
        
        if Examples.examples["Read‐Me"] ≠ nil {
            readMe += [
                "",
                "## Example Usage",
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
            readMe += [
                "",
                "## About",
                "",
                "The \(Configuration.projectName) project is maintained by Jeremy David Giesbrecht.",
                "",
                "If \(Configuration.projectName) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
                "",
                "If \(Configuration.projectName) saves you time, consider devoting some of it to [contributing](\(Configuration.requiredRepositoryURL)) back to the project.",
                "",
                format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.", translation: "For the worker is worthy of his wages.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT", localization: "🇬🇧 English"), citation: "\u{200E}ישוע/Yeshuʼa")
            ]
        }
        
        return join(lines: readMe)
    }()
    
    static func formatQuotationURL(chapter: String, originalKey: String, localization: String?) -> String {
        var translationCode = "NIVUK"
        if let specific = localization {
            switch specific {
            case "🇬🇧 English":
                break
            case "🇩🇪 Deutsch":
                translationCode = "SCH2000"
            default:
                fatalError(message: ["\(specific) does not have a corresponding translation yet."])
            }
        }
        
        let sanitizedChapter = chapter.replacingOccurrences(of: " ", with: "+")
        return "https://www.biblegateway.com/passage/?search=\(sanitizedChapter)&version=\(originalKey);\(translationCode)"
    }
    
    static func defaultQuotationURL(localization: String?) -> String {
        if let chapter = Configuration.quotationChapter {
            return formatQuotationURL(chapter: chapter, originalKey: Configuration.quotationOriginalKey, localization: localization)
        } else {
            return Configuration.noValue
        }
    }
    
    static func localizationLinksMarkup(localization: String?) -> String {
        var links: [String] = []
        for targetLocalization in Configuration.localizations {
            let link = targetLocalization
            var url: String
            if localization == nil {
                url = readMePath(localization: targetLocalization).string
            } else {
                url = readMeFilename(localization: targetLocalization)
            }
            url = url.replacingOccurrences(of: " ", with: "%20")
            
            links.append("[\(link)](\(url))")
        }
        return links.joined(separator: " • ")
    }
    
    static let apiLinksMarkup: String = {
        let urlString = Configuration.requiredDocumentationURL
        
        guard let url = URL(string: urlString) else {
            fatalError(message: [
                "The configured “Documentation URL” is invalid.",
                "",
                urlString
                ])
        }
        
        let operatingSystems = OperatingSystem.all.filter({ $0.isSupportedByProject }).map({ "\($0)" })
        if Set(operatingSystems).contains(url.linuxSafeLastPathComponent) {
            
            let root = url.deletingLastPathComponent().absoluteString
            let links = operatingSystems.map() {
                return "[\($0)](\(root)\($0))"
            }
            return "APIs: \(links.joined(separator: " • "))"
        } else {
            return "[APIs: \(operatingSystems.joined(separator: " • "))](\(urlString))"
        }
    }()
    
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
    
    static func quotationMarkup(localization: String?) -> String {
        return format(quotation: Configuration.requiredQuotation, translation: Configuration.quotationTranslation(localization: localization), url: Configuration.quotationURL(localization: localization), citation: Configuration.citation(localization: localization))
    }
    
    static func relatedProjectsLinkMarkup(localization: String?) -> String {
        let path: String
        if localization ≠ nil {
            path = relatedProjectsFilename(localization: localization)
        } else {
            path = ReadMe.relatedProjectsPath(localization: localization).string
        }
        return "(For a list of related projecs, see [here](\(path.replacingOccurrences(of: " ", with: "%20"))).)"
    }
    
    static let defaultInstallationInstructions: String? = {
        if Configuration.projectType == .library {
            
            var instructions = [
                "## Importing",
                "",
                "\(Configuration.projectName) is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
                ""
            ]
            
            var dependencySummary = "Simply add \(Configuration.projectName) as a dependency in `Package.swift`"
            
            if let repository = Configuration.repositoryURL,
                let currentVersion = Configuration.currentVersion {
                
                instructions += [
                    dependencySummary + ":",
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
                instructions += [
                    dependencySummary + "."
                ]
            }
            
            instructions += [
                "",
                "\(Configuration.projectName) can then be imported in source files:",
                "",
                "```swift",
                "import \(Configuration.moduleName)",
                "```"
            ]
            
            return join(lines: instructions)
        }
        
        return nil
    }()
    
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
                Configuration.readMe
                ])
            
            let localizationLinks = key("Localization Links")
            if body.contains(localizationLinks) {
                body = body.replacingOccurrences(of: localizationLinks, with: localizationLinksMarkup(localization: localization))
            }
            
            let apiLinks = key("API Links")
            if body.contains(apiLinks) {
                body = body.replacingOccurrences(of: apiLinks, with: apiLinksMarkup)
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
                body = body.replacingOccurrences(of: installationInsructions, with: Configuration.requiredInstallationInstructions)
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
                guard let readMeExample = Examples.examples["Read‐Me"] else {
                    
                    fatalError(message: [
                        "There is no definition for the example named “Read‐Me”.",
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
            
            if ¬Configuration.relatedProjects.isEmpty
                ∧ (localization ≠ nil ∨ localizations.count == 1 /* Only unlocalized. */) {
                
                var projects: [String] = [
                    "# Related Projects",
                    "",
                    "### Table of Contents",
                    ""
                ]
                
                func extractHeader(line: String) -> String {
                    var start = line.startIndex
                    guard line.advance(&start, past: "# ") else {
                        fatalError(message: [
                            "Error parsing section header:",
                            "",
                            "\(line)",
                            "",
                            "This may indicate a bug in Workspace."
                            ])
                    }
                    return line.substring(from: start)
                }
                
                func sanitize(headerAnchor: String) -> String {
                    return headerAnchor.replacingOccurrences(of: " ", with: "‐")
                }
                
                for line in Configuration.relatedProjects {
                    if line.hasPrefix("# ") {
                        let header = extractHeader(line: line)
                        projects += [
                            "\u{2D} [\(header)](#\(sanitize(headerAnchor: header)))"
                        ]
                    }
                }
                for line in Configuration.relatedProjects {
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
                        
                        let name = line.substring(to: colon.lowerBound)
                        let url = line.substring(from: colon.upperBound)
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
                        
                        if let shortDescription = Configuration.localizedOptionValue(option: .shortProjectDescription, localization: localization, configuration: configuration) {
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
                force() { try readMe.write() }
            }
        }
    }
}
