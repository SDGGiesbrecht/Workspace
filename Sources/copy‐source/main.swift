/*
 main.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

var arguments = ProcessInfo.processInfo.arguments.dropFirst()
guard let inputPath = arguments.popFirst(),
  let outputPath = arguments.popFirst()
else {
  fatalError("Wrong number of arguments:\n\(Array(arguments))")
}

try FileManager.default.copyItem(
  at: URL(fileURLWithPath: inputPath),
  to: URL(fileURLWithPath: outputPath)
)
