/*
 Licence.swift

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

enum Licence : String {

    // MARK: - Initialization

    init?(key: String) {
        self.init(rawValue: key)
    }

    // MARK: - Cases

    case apache2_0
    case mit
    case gnuGeneralPublic3_0
    case unlicense
    case copyright

    static let all: [Licence] = [
        .apache2_0,
        .mit,
        .gnuGeneralPublic3_0,
        .unlicense,
        .copyright
    ]

    // MARK: - Properties

    var key: String {
        return rawValue
    }

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

        var file = PackageRepository.TextFile(mockFileWithContents: source, fileType: FileType.markdown)
        return file.body
    }

    private var noticeLines: [String] {
        switch self {
        case .apache2_0:
            return [
                "Licensed under the Apache Licence, Version 2.0.",
                "See http://www.apache.org/licenses/LICENSE-2.0 for licence information."
            ]
        case .mit:
            return [
                "Licensed under the MIT Licence.",
                "See https://opensource.org/licenses/MIT for licence information."
            ]
        case .gnuGeneralPublic3_0:
            return [
                "Licensed under the GNU General Public Licence, Version 3.0.",
                "See http://www.gnu.org/licenses/ for licence information."
            ]
        case .unlicense:
            return [
                "Dedicated to the public domain.",
                "See http://unlicense.org/ for more information."
            ]
        case .copyright:
            return [
                "This software is subject to copyright law.",
                "It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s)."
            ]
        }
    }

    var notice: String {
        return join(lines: noticeLines)
    }

    // MARK: - Licence Management

    static func refreshLicence(output: inout Command.Output) {

        guard let licence = Configuration.licence else {

            // Fails later in validation phase.

            return
        }

        var text = licence.text

        var file = File(possiblyAt: RelativePath("LICENSE.md"))
        let oldContents = file.contents

        let copyright = FileHeaders.copyright(fromText: oldContents)
        var authors = "the \(Configuration.projectName) project contributors."
        if let author = Configuration.author {
            authors = "\(author) and " + authors
        }

        func key(_ key: String) -> String {
            return "[_\(key)_]"
        }

        text = text.replacingOccurrences(of: key("Copyright"), with: copyright)
        text = text.replacingOccurrences(of: key("Authors"), with: authors)

        file.contents = text
        require() { try file.write(output: &output) }

        // Delete alternate licence files to prevent duplicates.
        try? Repository.delete(RelativePath("LICENSE.txt"))
    }
}
