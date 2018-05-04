/*
 main.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

import WorkspaceLibrary

do {
    SDGCommandLine.initialize(applicationIdentifier: "ca.solideogloria.Workspace.Tests", version: nil, packageURL: nil)

    let repositoryRoot = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()

    let mockProject = repositoryRoot.appendingPathComponent("Tests/Mock Projects/After/Default")
    try FileManager.default.do(in: mockProject) {
        try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"])
        try Workspace.command.execute(with: ["validate", "test‐coverage", "•job", "tvos"])
    }

} catch let error {
    print(error)
    print(error.localizedDescription)
    exit(1)
}
