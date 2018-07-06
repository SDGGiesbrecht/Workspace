/*
 Output.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

extension Command.Output {

    public func succeed(message: StrictString, project: PackageRepository) throws {
        try listWarnings(for: project)
        print(message.formattedAsSuccess().separated())
    }

    public func listWarnings(for project: PackageRepository) throws {
        if let unsupportedFiles = try FileType.unsupportedTypesWarning(for: project, output: self) {
            print(unsupportedFiles.formattedAsWarning().separated())
        }
    }
}
