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

    // MARK: - Templates

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

    // MARK: - Refreshment

    private static func refreshReadMe(at location: URL, for localization: String, in project: PackageRepository, atProjectRoot: Bool, output: Command.Output) throws {

        guard let readMeSource = try project.readMe()[localization] else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return StrictString("There is no read‐me for “\(localization)”. (documentation.readMe.contents)")
                }
            }))
        }

        // [_Warning: This should not be a template any more._]
        var readMe = Template(source: readMeSource)

        // Section Elements

        let examplesUsage: StrictString
        let examplesOption = try project.cachedConfiguration().documentation.readMe.exampleUsage
        switch examplesOption {
        case .custom(let custom):
            guard let localized = custom[localization] else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("There is no example usage for “\(localization)”. (documentation.readMe.exampleUsuage)")
                    }
                }))
            }
            examplesUsage = StrictString(localized)
        case .automatic:
            if let `default` = try defaultExampleUsageTemplate(for: localization, project: project, output: output) {
                examplesUsage = `default`.text
            } else {
                examplesUsage = ""
            }
        }
        readMe.insert(examplesUsage, for: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "exampleUsage"
            }
        }))

        // Word Elements

        for (key, example) in try project.examples(output: output) {
            readMe.insert([
                "```swift",
                StrictString(example),
                "```"
                ].joinAsLines(), for: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return StrictString("example: \(key)")
                    }
                }))
        }

        var body = String(readMe.text)
        if ¬atProjectRoot {
            // Fix links according to location.
            let prefix = "]("
            let searchTerm: String = prefix + ReadMeConfiguration.documentationDirectory(for: project).path(relativeTo: project.location) + "/"
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

                        if let description = try? package.shortDescription(),
                            let localized = description[localization] {
                            markdown += [
                                "",
                                localized
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
        for localization in try project.localizations() {
            try autoreleasepool {

                try refreshReadMe(at: ReadMeConfiguration.readMeLocation(for: project, localization: localization), for: localization, in: project, atProjectRoot: false, output: output)
                try refreshRelatedProjects(at: ReadMeConfiguration.relatedProjectsLocation(for: project, localization: localization), for: localization, in: project, output: output)

                try refreshReadMe(at: project.location.appendingPathComponent("README.md"), for: try project.developmentLocalization(), in: project, atProjectRoot: true, output: output)
            }
        }

        // Deprecated file locations.
        project.delete(project.location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
    }
}
