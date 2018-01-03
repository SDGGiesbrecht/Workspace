/*
 GenericWarning.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct GenericWarning : Warning {

    static let name = "Manual Warning"
    static let trigger = "Warning"
    static let noticeOnly = false

    static func message(forDetails details: String) -> String? {
        return details
    }
}
