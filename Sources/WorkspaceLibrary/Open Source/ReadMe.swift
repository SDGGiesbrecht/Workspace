/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

enum ReadMe {

    static func refreshReadMe(for project: PackageRepository, output: inout Command.Output) throws {
        for localization in try project.configuration.localizations() {
            print(localization)
            notImplementedYet()
        }
    }
}
