/*
 Options.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSContinuousIntegration

extension Options {

    // MARK: - General

    public var job: ContinuousIntegrationJob? {
        return value(for: ContinuousIntegrationJob.option)
    }

    var project: PackageRepository {
        let url = value(for: Workspace.projectOption) ?? URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        return PackageRepository(at: url)
    }

    // MARK: - Proofreading

    var runAsXcodeBuildPhase: Bool {
        return value(for: Workspace.Proofread.runAsXcodeBuildPhase)
    }

    // MARK: - Documentation

    var jazzy: Bool {
        return true
    }
}
