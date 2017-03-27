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

    static func readMePath(localization: String?) -> RelativePath {
        if let specific = localization {
            return RelativePath("Documentation/\(specific)/Read Me.md")
        } else {
            return RelativePath("README.md")
        }
    }
    static func relatedProjectsPath(localization: String?) -> RelativePath {
        if let specific = localization {
            return RelativePath("Documentation/\(specific)/Related Projects.md")
        } else {
            return RelativePath("Documentation/Related Projects.md")
        }
    }

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static let defaultReadMeTemplate: String = {
        var readMe: [String] = []

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
                format(quotation: "Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.\nFor the worker is worthy of his wages.", url: formatQuotationURL(chapter: "Luke 10", originalKey: "SBLGNT"), citation: "\u{200E}ישוע/Yeshuʼa")
            ]
        }

        return join(lines: readMe)
    }()

    static func formatQuotationURL(chapter: String, originalKey: String) -> String {
        let sanitizedChapter = chapter.replacingOccurrences(of: " ", with: "+")
        return "https://www.biblegateway.com/passage/?search=\(sanitizedChapter)&version=\(originalKey);NIVUK"
    }

    static let defaultQuotationURL: String = {
        if var chapter = Configuration.quotationChapter {
            return formatQuotationURL(chapter: chapter, originalKey: Configuration.quotationOriginalKey)
        } else {
            return Configuration.noValue
        }
    }()

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

    static func format(quotation: String, url possibleURL: String?, citation possibleCitation: String?) -> String {
        var result = quotation.replacingOccurrences(of: "\n", with: "<br>")
        if let url = possibleURL {
            result = "[\(result)](\(url))"
        }
        if let citation = possibleCitation {
            let indent = [String](repeating: "&nbsp;", count: 100).joined()
            result += "<br>" + indent + "―" + citation
        }
        return "> " + result
    }

    static let quotationMarkup: String = {
        return format(quotation: Configuration.requiredQuotation, url: Configuration.quotationURL, citation: Configuration.citation)

    }()

    static func relatedProjectsLinkMarkup(localization: String?) -> String {
        return "(For a list of related projecs, see [here](\(ReadMe.relatedProjectsPath(localization: localization).string.replacingOccurrences(of: " ", with: "%20"))).)"
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
        if localizations.isEmpty {
            localizations.append(nil)
        }

        for localization in localizations {

            func key(_ name: String) -> String {
                return "[_\(name)_]"
            }

            var body = join(lines: [
                managementComment,
                "",
                Configuration.readMe
                ])

            let apiLinks = key("API Links")
            if body.contains(apiLinks) {
                body = body.replacingOccurrences(of: apiLinks, with: apiLinksMarkup)
            }

            body = body.replacingOccurrences(of: key("Project"), with: Configuration.projectName)

            let shortDescription = key("Short Description")
            if body.contains(shortDescription) {
                body = body.replacingOccurrences(of: shortDescription, with: Configuration.requiredShortProjectDescription)
            }

            let quotation = key("Quotation")
            if body.contains(quotation) {
                body = body.replacingOccurrences(of: quotation, with: quotationMarkup)
            }

            let features = key("Features")
            if body.contains(features) {
                body = body.replacingOccurrences(of: features, with: Configuration.requiredFeatureList)
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
            print(readMe.path)
            print(readMe.contents)
            require() { try readMe.write() }

            if ¬Configuration.relatedProjects.isEmpty {

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

                        if let shortDescription = configuration[.shortProjectDescription] {
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
