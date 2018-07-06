/*
 Path.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

protocol Path {

    // MARK: - Initialization

    init(_ string: String)

    // MARK: - Properties

    var string: String { get }
}

extension Path {

    // MARK: - Usage

    func subfolderOrFile(_ path: String) -> Self {
        return Self(string + "/" + path)
    }
}
