/*
 CheckForUpdates.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    enum CheckForUpdates {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "check‐for‐updates"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "checks for available Workspace updates."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws in
            if let update = try checkForUpdates(output: &output) {
                print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Workspace \(update.string) is available.\nFor update instructions, see:\n\(DocumentationLink.installation.url)")
                    }
                }).resolved(), to: &output)
            } else {
                print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Workspace is up to date."
                    }
                }).resolved(), to: &output)
            }
        })

        @discardableResult static func checkForUpdates(output: inout Command.Output) throws -> Version? {
            notImplementedYet()
            return Version(2,0,0)
        }
    }
}
