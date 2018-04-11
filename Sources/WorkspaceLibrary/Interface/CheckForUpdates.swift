/*
 CheckForUpdates.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    enum CheckForUpdates {

        private static let name = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "check‐for‐updates"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "checks for available Workspace updates."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws in
            if let update = try checkForUpdates(output: &output) {
                print(UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Workspace \(update.string) is available.\nFor update instructions, see \(DocumentationLink.installation.url.in(Underline.underlined))")
                    }
                }).resolved(), to: &output)
            } else {
                print(UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Workspace is up to date."
                    }
                }).resolved(), to: &output)
            }
        })

        static func checkForUpdates(output: inout Command.Output) throws -> Version? {
            let latestRemote = try Package(url: workspacePackageURL).latestVersion(output: &output)
            if latestRemote ≠ latestStableWorkspaceVersion { // [_Exempt from Test Coverage_] Execution path is determined externally.
                return latestRemote
            } else { // [_Exempt from Test Coverage_] Execution path is determined externally.
                return nil // Up to date.
            }
        }
    }
}
