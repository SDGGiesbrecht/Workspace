/*
 CustomTask.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGExternalProcess

import SDGSwift

import WorkspaceConfiguration

extension CustomTask {

    // MARK: - Static Properties

    internal static let cache = FileManager.default.url(in: .cache, at: "Custom Tasks")

    // MARK: - Execution

    public func execute(output: Command.Output) throws {
        _ = try Package(url: url).execute(.version(version), of: [executable], with: arguments, cacheDirectory: CustomTask.cache, reportProgress: { output.print($0) }).get()
    }
}
