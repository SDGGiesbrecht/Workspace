/*
 Exports.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

@_exported import WorkspaceConfiguration
@_exported import WorkspaceImplementation

// #workaround(Swift 5.2.4, Web lacks XCTest.)
#if !os(WASI)
  @_exported import XCTest
#endif

@_exported import SDGPersistenceTestUtilities
@_exported import SDGLocalizationTestUtilities
@_exported import SDGXCTestUtilities

@_exported import SDGCommandLineTestUtilities
