/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import GeneralImports

import SDGSwiftPackageManager

import Project

enum ReadMe {

    // MARK: - Locations

    private static let documentationDirectoryName = "Documentation"
    private static func documentationDirectory(for project: PackageRepository) -> URL {
        return project.location.appendingPathComponent(documentationDirectoryName)
    }

    private static func locationOfDocumentationFile(named name: StrictString, for localization: String, in project: PackageRepository) -> URL {
        let icon = ContentLocalization.icon(for: localization) ?? StrictString("[" + localization + "]")
        let fileName: StrictString = icon + " " + name + ".md"
        return documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    private static func readMeLocation(for project: PackageRepository, localization: String) -> URL {
        var result: URL?
        LocalizationSetting(orderOfPrecedence: [localization]).do {
            result = locationOfDocumentationFile(named: UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Read Me"
                }
            }).resolved(), for: localization, in: project)
        }
        return result!
    }

    static func relatedProjectsLocation(for project: PackageRepository, localization: String) -> URL {
        return locationOfDocumentationFile(named: UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Related Projects"
            }
        }).resolved(), for: localization, in: project)
    }

    // MARK: - Templates

    static let skipInJazzy: StrictString = "<!\u{2D}\u{2D}Skip in Jazzy\u{2D}\u{2D}>"

    private static func localizationLinksMarkup(for project: PackageRepository, fromProjectRoot: Bool) throws -> StrictString {
        var links: [StrictString] = []
        for targetLocalization in try project.cachedConfiguration().documentation.normalizedLocalizations {
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

    private static func operatingSystemList(for project: PackageRepository, output: Command.Output) throws -> StrictString {
        let supported = try OperatingSystem.cases.filter({ try $0 ∈ project.cachedConfiguration().supportedOperatingSystems })
        let list = supported.map({ $0.isolatedName.resolved() }).joined(separator: " • ".scalars)
        return StrictString(list)
    }

    private static func apiLinksMarkup(for project: PackageRepository, output: Command.Output) throws -> StrictString {

        guard let baseURL = try project.cachedConfiguration().documentation.documentationURL else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "API links require a documentation URL to be specified. (documentation.documentationURL)"
                }
            }))
        }

        let label = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "APIs:"
            }
        }).resolved()

        var links: [StrictString] = []
        var alreadyListed: Set<String> = []
        for product in try project.cachedPackage().products where product.type.isLibrary {
            for module in product.targets where module.name ∉ alreadyListed {
                alreadyListed.insert(module.name)

                var link: StrictString = "[" + StrictString(module.name) + "]"
                link += "(" + StrictString(baseURL.appendingPathComponent(module.name).absoluteString) + ")"
                links.append(link)
            }
        }

        return label + " " + StrictString(links.joined(separator: " • ".scalars))
    }

    private static func quotationMarkup(localization: String, project: PackageRepository) throws -> StrictString {
        guard let original = try project.cachedConfiguration().documentation.readMe.quotation?.original else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return StrictString("There is no quotation specified. (documentation.readMe.quotation)")
                }
            }))
        }

        var result = [StrictString(original)]
        if let translation = try project.cachedConfiguration().documentation.readMe.quotation?.translation[localization] {
            result += [StrictString(translation)]
        }
        if let url = try project.cachedConfiguration().documentation.readMe.quotation?.link[localization] {
            let components: [StrictString] = ["[", result.joinAsLines(), "](", StrictString(url.absoluteString), ")"]
            result = [components.joined()]
        }
        if let citation = try project.cachedConfiguration().documentation.readMe.quotation?.citation[localization] {
            let indent = StrictString([String](repeating: "&nbsp;", count: 100).joined())
            result += [indent + "―" + StrictString(citation)]
        }

        return StrictString("> ") + StrictString(result.joined(separator: "\n".scalars)).replacingMatches(for: "\n".scalars, with: "<br>".scalars)
    }

    private static func relatedProjectsLinkMarkup(for project: PackageRepository, localization: String) -> StrictString {
        let absoluteURL = relatedProjectsLocation(for: project, localization: localization)
        var relativeURL = StrictString(absoluteURL.path(relativeTo: project.location))
        relativeURL.replaceMatches(for: " ".scalars, with: "%20".scalars)

        let link = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return StrictString("(For a list of related projects, see [here](\(relativeURL)).)")
            }
        }).resolved()
        return link + " " + skipInJazzy
    }

    static func defaultExampleUsageTemplate(for localization: String, project: PackageRepository, output: Command.Output) throws -> Template? {
        let prefixes = InterfaceLocalization.cases.map { (localization) in
            return UserFacing<StrictString, InterfaceLocalization>({ (localization) in
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

        for (key, _) in try project.examples(output: output) {
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

    static func defaultReadMeTemplate(for localization: String, project: PackageRepository, output: Command.Output) throws -> Template {

        var readMe: [StrictString] = [
            "[_Localization Links_]",
            ""
        ]
        readMe += [
            "[_Operating System List_]",
            ""
        ]
        if try project.cachedConfiguration().documentation.documentationURL ≠ nil {
            readMe += [
                "[_API Links_]",
                ""
            ]
        }

        readMe += ["# [_Project_]"]
        if try ¬project.cachedConfiguration().documentation.readMe.shortProjectDescription.isEmpty {
            readMe += [
                "",
                "[_Short Description_]"
            ]
        }
        if try project.cachedConfiguration().documentation.readMe.quotation ≠ nil {
            readMe += [
                "",
                "[_Quotation_]"
            ]
        }

        if try ¬project.cachedConfiguration().documentation.readMe.shortProjectDescription.isEmpty {
            let header = UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Features"
                }
            }).resolved()

            readMe += [
                "",
                StrictString("## ") + header,
                "",
                "[_Features_]"
            ]
        }
        if try ¬project.cachedConfiguration().documentation.relatedProjects.isEmpty {
            readMe += [
                "",
                "[_Related Projects_]"
            ]
        }

        if try ¬project.cachedConfiguration().documentation.readMe.resolvedInstallationInstructions(for: project).isEmpty {
            readMe += [
                "",
                "[_Installation Instructions_]"
            ]
        }

        if (try project.configuration.exampleUsage(for: localization, project: project, output: output)) ≠ nil {
            let header = UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Example Usage"
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
            let header = UserFacing<StrictString, ContentLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "About"
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

    private static func refreshReadMe(at location: URL, for localization: String, in project: PackageRepository, atProjectRoot: Bool, output: Command.Output) throws {
        var readMe = try project.configuration.readMe(for: localization, project: project, output: output)

        // Section Elements

        try readMe.insert(resultOf: {
            guard let features = try project.cachedConfiguration().documentation.readMe.normalizedShortProjectDescription[localization] else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("There are no features specified for “\(localization)”. (documentation.readMe.featureList)")
                    }
                }))
            }
            return features
        }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Features"
            }
        }))

        try readMe.insert(resultOf: {
            guard let instructions = try project.cachedConfiguration().documentation.readMe.resolvedInstallationInstructions(for: project)[localization] else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("There are no installation instructions specified for “\(localization)”. (documentation.readMe.installationInstructions)")
                    }
                }))
            }
            return instructions
        }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Installation Instructions"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireExampleUsage(for: localization, project: project, output: output).text}, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Example Usage"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireOtherReadMeContent(for: localization, project: project, output: output).text }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Other"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireReadMeAboutSectionTemplate(for: localization, project: project, output: output).text }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "About"
            }
        }))

        // Line Elements

        readMe.insert(try localizationLinksMarkup(for: project, fromProjectRoot: atProjectRoot), for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Localization Links"
            }
        }))
        readMe.insert(try operatingSystemList(for: project, output: output), for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Operating System List"
            }
        }))
        try readMe.insert(resultOf: { try apiLinksMarkup(for: project, output: output) }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "API Links"
            }
        }))

        try readMe.insert(resultOf: {
            guard let description = try project.cachedConfiguration().documentation.readMe.normalizedShortProjectDescription[localization] else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("There is no short project description specified for “\(localization)”. (documentation.readMe.shortProjectDescription)")
                    }
                }))
            }
            return description
        }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Short Description"
            }
        }))

        try readMe.insert(resultOf: { try quotationMarkup(localization: localization, project: project) }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Quotation"
            }
        }))
        readMe.insert(resultOf: { relatedProjectsLinkMarkup(for: project, localization: localization) }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Related Projects"
            }
        }))

        // Word Elements

        readMe.insert(try project.projectName(), for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Project"
            }
        }))

        try readMe.insert(resultOf: {
            guard let url = try project.cachedConfiguration().documentation.repositoryURL else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("There is no short project description specified for “\(localization)”. (documentation.repositoryURL)")
                    }
                }))
            }
            return StrictString(url.absoluteString)
        }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Repository URL"
            }
        }))

        try readMe.insert(resultOf: { StrictString(try project.configuration.requireCurrentVersion().string()) }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Current Version"
            }
        }))

        for (key, example) in try project.examples(output: output) {
            readMe.insert([
                "```swift",
                StrictString(example),
                "```"
                ].joinAsLines(), for: UserFacing({ localization in
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
        try file.writeChanges(for: project, output: output)
    }

    private static func refreshRelatedProjects(at location: URL, for localization: String, in project: PackageRepository, output: Command.Output) throws {

        let relatedProjects = try project.cachedConfiguration().documentation.relatedProjects
        if ¬relatedProjects.isEmpty {
            var markdown: [StrictString] = [
                StrictString("# ") + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Related Projects"
                    }
                }).resolved()
            ]

            for entry in relatedProjects {
                autoreleasepool {
                    switch entry {
                    case .heading(text: let text):
                        markdown += [
                            "",
                            StrictString("## \(text))")
                        ]
                    case .project(url: let url):
                        let package = Repository.linkedRepository(from: url)
                        let name: StrictString
                        if let packageName = try? package.projectName() {
                            name = packageName
                        } else {
                            // [_Exempt from Test Coverage_] Only reachable with a non‐package repository.
                            name = StrictString(url.lastPathComponent)
                        }

                        markdown += [
                            "",
                            StrictString("### [\(name)](\(url.absoluteString))")
                        ]

                        if let configuration = try? package.cachedConfiguration(),
                            let description = configuration.documentation.readMe.normalizedShortProjectDescription[localization] {
                            markdown += [
                                "",
                                description
                            ]
                        }
                    }
                }
            }

            let body = String(markdown.joinAsLines())
            var file = try TextFile(possiblyAt: location)
            file.body = body
            try file.writeChanges(for: project, output: output)
        } else {
            project.delete(location, output: output)
        }
    }

    static func refreshReadMe(for project: PackageRepository, output: Command.Output) throws {
        let localizations = try project.cachedConfiguration().documentation.normalizedLocalizations
        for localization in localizations {
            try autoreleasepool {

                let setting = LocalizationSetting(orderOfPrecedence: [localization] + localizations)
                try setting.do {
                    try refreshReadMe(at: readMeLocation(for: project, localization: localization), for: localization, in: project, atProjectRoot: false, output: output)
                    try refreshRelatedProjects(at: relatedProjectsLocation(for: project, localization: localization), for: localization, in: project, output: output)
                }

                if localization == (try project.cachedConfiguration().documentation.developmentLocalization()) {
                    try setting.do {
                        try refreshReadMe(at: project.location.appendingPathComponent("README.md"), for: localization, in: project, atProjectRoot: true, output: output)
                    }
                }
            }
        }

        // Deprecated file locations.
        project.delete(project.location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
    }
}
