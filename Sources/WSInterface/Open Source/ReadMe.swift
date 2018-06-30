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
import WSGeneralImports

import SDGSwiftPackageManager

import WSProject
import WSExamples

enum ReadMe {

    // MARK: - Refreshment

    private static func refreshReadMe(at location: URL, for localization: LocalizationIdentifier, in project: PackageRepository, atProjectRoot: Bool, output: Command.Output) throws {

        guard var readMe = try project.readMe(output: output)[localization] else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ errorLocalization in
                switch errorLocalization {
                case .englishCanada:
                    return StrictString("There is no read‐me for “\(localization)”. (documentation.readMe.contents)")
                }
            }))
        }

        // Word Elements

        for (key, example) in try project.examples(output: output) {
            readMe.replaceMatches(for: StrictString("#example(\(key))"), with: [
                "```swift",
                StrictString(example),
                "```"
                ].joinedAsLines())
        }

        if ¬atProjectRoot {
            // Fix links according to location.
            let prefix = "]("
            let searchTerm: String = prefix + ReadMeConfiguration._documentationDirectory(for: project.location).path(relativeTo: project.location) + "/"
            readMe.scalars.replaceMatches(for: searchTerm.scalars, with: prefix.scalars)
        }

        var file = try TextFile(possiblyAt: location)
        file.body = String(readMe)
        try file.writeChanges(for: project, output: output)
    }

    private static func refreshRelatedProjects(at location: URL, for localization: LocalizationIdentifier, in project: PackageRepository, output: Command.Output) throws {

        let relatedProjects = try project.configuration(output: output).documentation.relatedProjects
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
                    case .heading(text: let translations):
                        if let text = translations[localization] {
                            markdown += [
                                "",
                                StrictString("## \(text)")
                            ]
                        }
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

                        if let configuration = try? package.configuration(output: output),
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

        for localization in try project.configuration(output: output).documentation.localizations {
            try autoreleasepool {

                try refreshReadMe(at: ReadMeConfiguration._readMeLocation(for: project.location, localization: localization), for: localization, in: project, atProjectRoot: false, output: output)
                try refreshRelatedProjects(at: ReadMeConfiguration._relatedProjectsLocation(for: project.location, localization: localization), for: localization, in: project, output: output)
            }
        }

        try refreshReadMe(at: project.location.appendingPathComponent("README.md"), for: try project.developmentLocalization(output: output), in: project, atProjectRoot: true, output: output)

        // Deprecated file locations.
        project.delete(project.location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
    }
}
