/*
 Licence.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

enum Licence: String {

    // MARK: - Initialization

    init?(key: String) {
        self.init(rawValue: key)
    }

    // MARK: - Cases

    case apache2_0 = "Apache 2.0"
    case mit = "MIT"
    case gnuGeneralPublic3_0 = "GNU GeneralPublic3_0"
    case unlicense = "Unlicense"
    case copyright = "Copyright"

    static let all: [Licence] = [
        .apache2_0,
        .mit,
        .gnuGeneralPublic3_0,
        .unlicense,
        .copyright,
    ]

    // MARK: - Properties

    var key: String {
        return rawValue
    }

    private var filenameWithoutExtension: String {
        return rawValue
    }

    static let licenceFolder = "Resources/Licences"

    private func licenceData(fileExtension: String) -> String {

        let licenceDirectory = Repository.workspaceDirectory.subfolderOrFile(Licence.licenceFolder)
        let path = licenceDirectory.subfolderOrFile("\(filenameWithoutExtension).\(fileExtension)")
        let file = require() { try File(at: path) }

        return file.contents
    }

    var filename: String {
        return filenameWithoutExtension + ".md"
    }

    var text: String {
        return licenceData(fileExtension: "md")
    }

    private var noticeLines: [String] {
        switch self {
        case .apache2_0:
            return [
                "Licensed under the Apache Licence, Version 2.0.",
                "See http://www.apache.org/licenses/LICENSE-2.0 for licence information.",
            ]
        case .mit:
            return [
                "Licensed under the MIT Licence.",
                "See https://opensource.org/licenses/MIT for licence information.",
            ]
        case .gnuGeneralPublic3_0:
            return [
                "Licensed under the GNU General Public Licence, Version 3.0.",
                "See http://www.gnu.org/licenses/ for licence information.",
            ]
        case .unlicense:
            return [
                "Dedicated to the public domain.",
                "See http://unlicense.org/ for more information.",
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

    static func refreshLicence() {

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
        require() { try file.write() }

        // Delete alternate licence files to prevent duplicates.
        force() { try Repository.delete(RelativePath("LICENSE.txt")) }
    }
}
