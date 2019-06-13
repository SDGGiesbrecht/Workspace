/*
 CustomTask.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

@testable import WSCustomTask
import WSGeneralImports
import WorkspaceConfiguration

extension CustomTask {

    static func emptyCache() {
        try? FileManager.default.removeItem(at: cache)
    }
}
