/*
 CheckForUpdates.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import WorkspaceProjectConfiguration

extension Workspace {
    enum CheckForUpdates {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "check‐for‐updates"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "checks for available Workspace updates."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, _, output: Command.Output) throws in
            if let update = try checkForUpdates(output: output) {
                // @exempt(from: tests) Execution path is determined externally.
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        let url = URL(string: "#installation", relativeTo: Metadata.packageURL)!
                        return StrictString("Workspace \(update.string()) is available.\nFor update instructions, see \(url.absoluteString.in(Underline.underlined))")
                    }
                }).resolved())
            } else {
                // @exempt(from: tests) Execution path is determined externally.
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Workspace is up to date."
                    }
                }).resolved())
            }
        })

        static func checkForUpdates(output: Command.Output) throws -> Version? {
            let latestRemote = try Package(url: Metadata.packageURL).versions().sorted().last!
            if latestRemote ≠ Metadata.latestStableVersion {
                // @exempt(from: tests) Execution path is determined externally.
                return latestRemote
            } else { // @exempt(from: tests) Execution path is determined externally.
                // @exempt(from: tests)
                return nil // Up to date.
            }
        }
    }
}
