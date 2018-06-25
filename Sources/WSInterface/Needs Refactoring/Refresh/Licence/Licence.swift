/*
 Licence.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WorkspaceConfiguration
import WSProject

extension Licence {

    // MARK: - Properties

    var text: String {
        var source: String
        switch self {
        case .apache2_0:
            source = Resources.Licences.apache2_0
        case .mit:
            source = Resources.Licences.mit
        case .gnuGeneralPublic3_0:
            source = Resources.Licences.gnuGeneralPublic3_0
        case .unlicense:
            source = Resources.Licences.unlicense
        case .copyright:
            source = Resources.Licences.copyright
        }

        var file = TextFile(mockFileWithContents: source, fileType: FileType.markdown)
        return file.body
    }

    // MARK: - Licence Management

    static func refreshLicence(output: Command.Output) throws {

        guard let licence = try Repository.packageRepository.configuration(output: output).licence.licence else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return StrictString("No licence has been selected. (licence.licence)")
                }
            }))
        }

        var text = licence.text

        var file = try TextFile(possiblyAt: RelativePath("LICENSE.md").url)
        let oldContents = file.contents

        let copyright = WSProject.copyright(fromText: oldContents)
        var authors = "the \(try Repository.packageRepository.projectName()) project contributors."
        if let configuredAuthor = try Repository.packageRepository.configuration(output: output).documentation.primaryAuthor {
            authors = "\(configuredAuthor) and " + authors
        }

        func key(_ key: String) -> String {
            return "[_\(key)_]"
        }

        text = text.replacingOccurrences(of: key("Copyright"), with: String(copyright))
        text = text.replacingOccurrences(of: key("Authors"), with: authors)

        file.contents = text
        try file.writeChanges(for: Repository.packageRepository, output: output)

        // Delete alternate licence files to prevent duplicates.
        try? Repository.delete(RelativePath("LICENSE.txt"))
    }
}
