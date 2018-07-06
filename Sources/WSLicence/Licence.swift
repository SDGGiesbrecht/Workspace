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
import WSProject

extension Licence {

    // MARK: - Properties

    internal var text: StrictString {
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

        let file = TextFile(mockFileWithContents: source, fileType: FileType.markdown)
        return StrictString(file.body)
    }
}
