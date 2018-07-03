/*
 main.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

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
configuration.documentation.readMe.manage = true
configuration.documentation.readMe.shortProjectDescription["en"] = "This is just an example."
// @endExample
