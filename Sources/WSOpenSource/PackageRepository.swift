/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject
import WSExamples

extension PackageRepository {

    private func refreshReadMe(at location: URL, for localization: LocalizationIdentifier, atProjectRoot: Bool, output: Command.Output) throws {

        guard var readMe = try readMe(output: output)[localization] else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ errorLocalization in
                switch errorLocalization {
                case .englishCanada:
                    return "There is no read‐me for “\(arbitraryDescriptionOf: localization)”. (documentation.readMe.contents)"
                }
            }))
        }

        // Word Elements

        for (key, example) in try examples(output: output) {
            readMe.replaceMatches(for: "\u{23}example(\(key))", with: [
                "```swift",
                StrictString(example),
                "```"
                ].joinedAsLines())
        }

        if ¬atProjectRoot {
            // Fix links according to location.
            let prefix = "]("
            let searchTerm: String = prefix + ReadMeConfiguration._documentationDirectory(for: location).path(relativeTo: location) + "/"
            readMe.scalars.replaceMatches(for: searchTerm.scalars, with: prefix.scalars)
        }

        var file = try TextFile(possiblyAt: location)
        file.body = String(readMe)
        try file.writeChanges(for: self, output: output)
    }

    private func refreshRelatedProjects(at location: URL, for localization: LocalizationIdentifier, output: Command.Output) throws {

        let relatedProjects = try configuration(output: output).documentation.relatedProjects
        if ¬relatedProjects.isEmpty {
            var markdown: [StrictString] = [
                "# " + UserFacing<StrictString, ContentLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Related Projects"
                    }
                }).resolved()
            ]

            for entry in relatedProjects {
                try autoreleasepool {
                    switch entry {
                    case .heading(text: let translations):
                        if let text = translations[localization] {
                            markdown += [
                                "",
                                "## \(text)"
                            ]
                        }
                    case .project(url: let url):
                        let package = try PackageRepository.relatedPackage(Package(url: url), output: output)
                        let name: StrictString
                        if let packageName = try? package.projectName() {
                            name = packageName // @exempt(from: tests) False positive in Xcode 10.
                        } else {
                            // @exempt(from: tests) Only reachable with a non‐package repository.
                            name = StrictString(url.lastPathComponent)
                        }

                        markdown += [
                            "",
                            "### [\(name)](\(url.absoluteString))"
                        ]

                        if let configuration = try? package.configuration(output: output),
                            let description = configuration.documentation.readMe.shortProjectDescription[localization] {
                            markdown += [ // @exempt(from: tests) False positive in Xcode 10.
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
            try file.writeChanges(for: self, output: output)
        } else {
            delete(location, output: output)
        }
    }

    public func refreshReadMe(output: Command.Output) throws {

        for localization in try configuration(output: output).documentation.localizations {
            try autoreleasepool {

                try refreshReadMe(at: ReadMeConfiguration._readMeLocation(for: location, localization: localization), for: localization, atProjectRoot: false, output: output)
                try refreshRelatedProjects(at: ReadMeConfiguration._relatedProjectsLocation(for: location, localization: localization), for: localization, output: output)
            }
        }

        try refreshReadMe(at: location.appendingPathComponent("README.md"), for: try developmentLocalization(output: output), atProjectRoot: true, output: output)

        // Deprecated file locations.
        delete(location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
    }
}
