/*
 TravisCI.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Dispatch

import SDGLogic
import SDGExternalProcess

public enum TravisCI {

  @inlinable public static func keepAlive(during task: () throws -> Void) rethrows {

    var complete = false
    if ProcessInfo.isInContinuousIntegration {
      // @exempt(from: tests) Does not occur locally.
      DispatchQueue.global().async {
        while ¬complete {
          Thread.sleep(until: Date.init(timeIntervalSinceNow: TimeInterval(60 /* s */)))
          if ¬complete {
            // @exempt(from: tests) Tests had better not take that long!
            Shell.default.run(command: ["echo", "...", ">", "/dev/tty"])
          }
        }
      }
    }

    try task()
    complete = true
  }
}
