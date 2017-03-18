/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct ReadMe {

    static let readMePath = RelativePath("README.md")
    static let relatedProjectsPath = RelativePath("Related Projects.md")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static let defaultQuotationURL: String = {
        if var chapter = Configuration.quotationChapter {
            chapter = chapter.replacingOccurrences(of: " ", with: "+")
            return "https://www.biblegateway.com/passage/?search=\(chapter)&version=\(Configuration.quotationOriginalKey);\(Configuration.quotationTranslationKey)"
        } else {
            return Configuration.noValue
        }
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

        return join(lines: readMe)
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
        if Set(operatingSystems).contains(url.lastPathComponent) {

            let root = url.deletingLastPathComponent().absoluteString
            let links = operatingSystems.map() {
                return "[\($0)](\(root)\($0))"
            }
            return "APIs: \(links.joined(separator: " • "))"
        } else {
            return "[APIs: \(operatingSystems.joined(separator: " • "))](\(urlString))"
        }
    }()

    static let quotationMarkup: String = {
        var quotation = Configuration.requiredQuotation.replacingOccurrences(of: "\n", with: "<br>")
        if let url = Configuration.quotationURL {
            quotation = "[\(quotation)](\(url))"
        }
        if let citation = Configuration.citation {
            let indent = [String](repeating: "&nbsp;", count: 100).joined()
            quotation += "<br>" + indent + "―" + citation
        }

        return "> " + quotation
    }()

    static let relatedProjectsLinkMarkup: String = {
        return "(For a list of related projecs, see [here](\(ReadMe.relatedProjectsPath.string.replacingOccurrences(of: " ", with: "%20"))).)"
    }()

    static let defaultInstallationInstructions: String? = {
        if Configuration.projectType == .library {

            var instructions = [
                "## Importing",
                "",
                "\(Configuration.projectName) is indended for use with the [Swift Package Manager](https://swift.org/package-manager/).",
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
                "\(Configuration.projectName) can then be imported in source files:",
                "",
                "```swift",
                "import \(Configuration.moduleName)",
                "```"
            ]
            
            return instructions
        }

        return nil
    }()

    static func refreshReadMe() {

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
            body = body.replacingOccurrences(of: relatedProjectsLink, with: relatedProjectsLinkMarkup)
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

        var readMe = File(possiblyAt: readMePath)
        readMe.body = body
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

            for line in Configuration.relatedProjects {
                if line.hasPrefix("# ") {
                    let header = extractHeader(line: line)
                    projects += [
                        "\u{2D} [\(header)](#\(header.replacingOccurrences(of: " ", with: "\u{2D}").lowercased()))"
                    ]
                }
            }
            for line in Configuration.relatedProjects {
                if line.hasPrefix("# ") {
                    projects += [
                        "",
                        "## \(extractHeader(line: line))"
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

            var relatedProjects = File(possiblyAt: relatedProjectsPath)
            relatedProjects.body = join(lines: projects)
            require() { try relatedProjects.write() }
        }
    }

    static func relinquishControl() {

        var readMe = File(possiblyAt: readMePath)
        if let range = readMe.contents.range(of: managementComment) {
            printHeader(["Cancelling read‐me management..."])
            readMe.contents.removeSubrange(range)
            force() { try readMe.write() }
        }
    }
}
