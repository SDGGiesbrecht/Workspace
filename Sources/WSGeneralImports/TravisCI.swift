/*
 TravisCI.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Dispatch

import SDGLogic
import SDGExternalProcess

public enum TravisCI {

    @_inlineable public static func keepAlive(during task: () throws -> Void) rethrows {

        var complete = false
        if ProcessInfo.isInContinuousIntegration {
            // [_Exempt from Test Coverage_] Does not occur locally.
            DispatchQueue.global().async {
                while ¬complete {
                    Thread.sleep(until: Date.init(timeIntervalSinceNow: TimeInterval(5 /* min */ × 60 /* s/min */)))
                    if ¬complete {
                        _ = try? Shell.default.run(command: ["echo", "...", ">", "/dev/tty"]) // [_Exempt from Test Coverage_] Tests had better not take that long!
                    }
                }
            }
        }

        try task()
        complete = true
    }
}
