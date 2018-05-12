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

    private static func operatingSystemList(for project: PackageRepository, output: Command.Output) throws -> StrictString {
        let supported = try OperatingSystem.cases.filter({ try project.configuration.supports($0, project: project, output: output) })
        let list = supported.map({ $0.isolatedName.resolved() }).joined(separator: " • ".scalars)
        return StrictString(list)
    }

    private static func apiLinksMarkup(for project: PackageRepository, output: Command.Output) throws -> StrictString {

        let baseURL = try project.configuration.requireDocumentationURL()
        let label = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "APIs:"
            }
        }).resolved()

        let links = try project.publicLibraryModules().map { (name: String) -> StrictString in

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
        let translationCode = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom:
                return "NIVUK"
            case .englishUnitedStates, .englishCanada:
                return "NIV"
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

        let link = UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return StrictString("(For a list of related projects, see [here](\(relativeURL)).)")
            }
        }).resolved()
        return link + " " + skipInJazzy
    }

    static func defaultInstallationInstructionsTemplate(localization: String, project: PackageRepository, output: Command.Output) throws -> Template? {
        var result: [StrictString] = []

        var tools = try project.cachedPackage().products.filter({ $0.type == .executable }).map { $0.name }

        // Filter out tools which have not been declared as products.
        switch try project.cachedManifest().package {
        case .v3: // [_Exempt from Test Coverage_] Not officially supported anyway.
            tools = [] // No concept of products.
        case .v4(let manifest):
            let publicProducts = Set(manifest.products.map({ $0.name }))
            tools = tools.filter { $0 ∈ publicProducts }
        }

        var includedInstallationSection = false
        if ¬tools.isEmpty,
            let repository = try project.configuration.repositoryURL(),
            let version = try project.configuration.currentVersion() {
            let package = StrictString(try project.cachedManifest().name)

            includedInstallationSection = true

            result += [
                "## " + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Installation"
                    }
                }).resolved(),
                "",
                UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Paste the following into a terminal to install or update `\(package)`:")
                    }
                }).resolved(),
                "",
                "```shell",
                StrictString("curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s \(package) \u{22}\(repository.absoluteString)\u{22} \(version.string()) \u{22}\(tools.first!) help\u{22} " + tools.joined(separator: " ")),
                "```"
            ]
        }

        let libraries = try project.publicLibraryModules()
        if ¬libraries.isEmpty {
            if includedInstallationSection {
                result += [""]
            }

            result += [
                "## " + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Importing"
                    }
                }).resolved(),
                "",
                UserFacingDynamic<StrictString, ContentLocalization, StrictString>({ localization, package in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("`\(package)` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).")
                    }
                }).resolved(using: StrictString(try project.cachedManifest().name)),
                ""
            ]

            let dependencySummary: StrictString = UserFacingDynamic<StrictString, ContentLocalization, StrictString>({ localization, package in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return StrictString("Simply add `\(package)` as a dependency in `Package.swift`")
                }
            }).resolved(using: StrictString(try project.cachedManifest().name))

            if let repository = try project.configuration.repositoryURL(),
                let currentVersion = try project.configuration.currentVersion() {
                var versionSpecification: String
                if currentVersion.major == 0 {
                    versionSpecification = ".upToNextMinor(from: Version(\(currentVersion.major), \(currentVersion.minor), \(currentVersion.patch)))"
                } else {
                    versionSpecification = "from: Version(\(currentVersion.major), \(currentVersion.minor), \(currentVersion.patch))"
                }

                result += [
                    dependencySummary + UserFacing<StrictString, ContentLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return ":"
                        }
                    }).resolved(),
                    "",
                    "```swift",
                    StrictString("let ") + UserFacing<StrictString, ContentLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "package"
                        }
                    }).resolved() + " = Package(",
                    (StrictString("    name: \u{22}") + UserFacing<StrictString, ContentLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "MyPackage"
                        }
                    }).resolved() + StrictString("\u{22},")) as StrictString,
                    "    dependencies: [",
                    StrictString("        .package(url: \u{22}\(repository.absoluteString)\u{22}, \(versionSpecification)),"),
                    "    ],",
                    "    targets: [",
                    (StrictString("        .target(name: \u{22}") + UserFacing<StrictString, ContentLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "MyTarget"
                        }
                    }).resolved() + StrictString("\u{22}, dependencies: [")) as StrictString
                ]
                for library in libraries {
                    result += [StrictString("            .productItem(name: \u{22}\(library)\u{22}, package: \u{22}\(try project.cachedManifest().name)\u{22}),")]
                }
                result += [
                    "        ])",
                    "    ]",
                    ")",
                    "```"
                ]
            } else {
                result += [dependencySummary + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "."
                    }
                }).resolved()]
            }

            result += [
                "",
                UserFacingDynamic<StrictString, ContentLocalization, StrictString>({ localization, package in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("`\(package)` can then be imported in source files:")
                    }
                }).resolved(using: StrictString(try project.cachedManifest().name)),
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

        if result == [] { // [_Exempt from Test Coverage_] [_Workaround: Until application targets are supported again._]
            return nil
        } else {
            return Template(source: result.joinAsLines())
        }
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
        if try project.configuration.optionIsDefined(.relatedProjects) {
            readMe += [
                "",
                "[_Related Projects_]"
            ]
        }

        if (try project.configuration.installationInstructions(for: localization, project: project, output: output)) ≠ nil {
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

        try readMe.insert(resultOf: { try project.configuration.requireFeatureList(for: localization) }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Features"
            }
        }))

        try readMe.insert(resultOf: { try project.configuration.requireInstallationInstructions(for: localization, project: project, output: output).text }, for: UserFacing({ localization in
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
        try readMe.insert(resultOf: { try project.configuration.requireShortProjectDescription(for: localization) }, for: UserFacing({ localization in
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
        try readMe.insert(resultOf: { StrictString(try project.configuration.requireRepositoryURL().absoluteString) }, for: UserFacing({ localization in
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

        if let relatedProjectURLs = try project.configuration.relatedProjects() {
            var markdown: [StrictString] = [
                StrictString("# ") + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Related Projects"
                    }
                }).resolved()
            ]

            for url in relatedProjectURLs {
                autoreleasepool {

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

                    if let succeeded = try? package.configuration.shortProjectDescription(for: localization),
                        let description = succeeded { // [_Exempt from Test Coverage_] Until Workspace’s configuration is centralized again.
                        markdown += [
                            "",
                            description
                        ]
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
        let localizations = try project.configuration.localizations()
        for localization in localizations {
            try autoreleasepool {

                let setting = LocalizationSetting(orderOfPrecedence: [localization] + localizations)
                try setting.do {
                    try refreshReadMe(at: readMeLocation(for: project, localization: localization), for: localization, in: project, atProjectRoot: false, output: output)
                    try refreshRelatedProjects(at: relatedProjectsLocation(for: project, localization: localization), for: localization, in: project, output: output)
                }

                if localization == (try project.configuration.developmentLocalization()) {
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
