/*
 Options.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

extension Options {

    var job: ContinuousIntegration.Job? { // [_Exempt from Code Coverage_] [_Workaround: Until unit‐tests is testable._]
        return value(for: ContinuousIntegration.Job.option)
    }

    var project: PackageRepository {
        let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        return PackageRepository(alreadyAt: url)
    }
}
