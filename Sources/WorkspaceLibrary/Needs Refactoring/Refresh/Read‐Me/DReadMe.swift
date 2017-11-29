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


    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

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
