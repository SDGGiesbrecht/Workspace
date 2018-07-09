/*
 Execution.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import Dispatch

import WorkspaceProjectConfiguration
import WSInterface

public func run() { // @exempt(from: tests)

    DispatchQueue.global(qos: .utility).sync {

        ProcessInfo.applicationIdentifier = "ca.solideogloria.Workspace"
        ProcessInfo.version = Metadata.thisVersion
        ProcessInfo.packageURL = Metadata.packageURL

        #if os(Linux)
        Workspace.command.executeAsMain()
        #else
        let reason = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Workspace"
            }
        })
        ProcessInfo.processInfo.performActivity(options: [.userInitiated, .idleSystemSleepDisabled], reason: String(reason.resolved())) {
            Workspace.command.executeAsMain()
        }
        #endif
    }
}
