/*
 GenericWarning.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

struct GenericWarning : Warning {

    static let name = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Manual Warning"
        }
    })

    static let trigger = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Warning"
        }
    })

    static func message(for details: StrictString, in project: PackageRepository, output: inout Command.Output) -> UserFacingText<InterfaceLocalization>? {
        return UserFacingText({ _ in details })
    }
}
