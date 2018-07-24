/*
 URL.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

extension URL {

    public func isIgnored(by project: PackageRepository, output: Command.Output) throws -> Bool {
        let ignoredTypes = try project.configuration(output: output).repository.ignoredFileTypes
        if lastPathComponent == ".Workspace Configuration.txt" {
            return false // So it triggers a deprecation notice.
        }
        for path in try project.configuration(output: output).repository.ignoredPaths {
            if `is`(in: project.location.appendingPathComponent(path)) {
                return true
            }
        }
        return pathExtension ∈ ignoredTypes ∨ lastPathComponent ∈ ignoredTypes
    }
}
