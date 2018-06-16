/*
 Shell.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGExternalProcess

@discardableResult func requireBash(_ arguments: [String], silent: Bool = false) -> String {

    do {
        if silent {
            return try Shell.default.run(command: arguments)
        } else {
            print("")
            let result = try Shell.default.run(command: arguments, reportProgress: { print($0) })
            print("")
            return result
        }
    } catch {
        fatalError(message: [
            "Command failed:",
            "",
            arguments.joined(separator: " "),
            "",
            "See details above."
            ])
    }
}
