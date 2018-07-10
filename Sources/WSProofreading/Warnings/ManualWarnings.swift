/*
 ManualWarnings.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

internal struct ManualWarnings : Warning {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "manualWarnings"
        }
    })

    internal static let trigger = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "warning"
        }
    })

    internal static func message(for details: StrictString, in project: PackageRepository, output: Command.Output) -> UserFacing<StrictString, InterfaceLocalization>? {
        return UserFacing({ _ in details })
    }
}
