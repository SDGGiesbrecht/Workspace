/*
 main.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @example(sampleConfiguration)
import WorkspaceConfiguration

/*
 Exernal packages can be imported with this syntax:
 import [module] // [url], [version], [product]
 */
import SDGControlFlow // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow

let configuration = WorkspaceConfiguration()
configuration.optIntoAllTasks()
configuration.documentation.api.generate = true
configuration.documentation.api.yearFirstPublished = 2017
// @endExample
