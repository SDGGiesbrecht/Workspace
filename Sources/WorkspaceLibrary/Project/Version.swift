/*
 Version.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

import SDGSwiftPackageManager

import PackageModel

extension SDGSwift.Version {

    init(_ version: PackageModel.Version) {
        self.init(version.major, version.minor, version.patch)
    }
}
