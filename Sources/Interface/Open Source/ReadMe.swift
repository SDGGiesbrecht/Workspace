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

    static func defaultExampleUsageTemplate(for localization: LocalizationIdentifier, project: PackageRepository, output: Command.Output) throws -> Template? {
        let prefixes = InterfaceLocalization.cases.map { (localization) in
            return UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return "Read‐Me"
                }
            }).resolved(for: localization)
        }
        var suffixes = [localization.code]
        if let icon = localization.icon {
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
            return Template(source: source.joinedAsLines())
        }
    }

    // MARK: - Refreshment

    private static func refreshReadMe(at location: URL, for localization: LocalizationIdentifier, in project: PackageRepository, atProjectRoot: Bool, output: Command.Output) throws {

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

        // [_Warning: Can this be sunk further?_]
        let examplesUsage: StrictString
        let examplesOption = try project.configuration().documentation.readMe.exampleUsage
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
                ].joinedAsLines(), for: UserFacing({ localization in
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

    private static func refreshRelatedProjects(at location: URL, for localization: LocalizationIdentifier, in project: PackageRepository, output: Command.Output) throws {

        let relatedProjects = try project.configuration().documentation.relatedProjects
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

                        if let configuration = try? package.configuration(),
                            let description = configuration.documentation.readMe.shortProjectDescription[localization] {
                            markdown += [
                                "",
                                description
                            ]
                        }
                    }
                }
            }

            let body = String(markdown.joinedAsLines())
            var file = try TextFile(possiblyAt: location)
            file.body = body
            try file.writeChanges(for: project, output: output)
        } else {
            project.delete(location, output: output)
        }
    }

    static func refreshReadMe(for project: PackageRepository, output: Command.Output) throws {
        for localization in try project.configuration().documentation.localizations {
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
