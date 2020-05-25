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

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  @_exported import struct Foundation.URL
#endif

@_exported import SDGLogic  // Bool (Localized)
@_exported import SDGMathematics  // +=
@_exported import SDGCollections  // SearchableCollection
@_exported import SDGText  // StrictString
@_exported import SDGPersistence  // URL (Localized)
@_exported import SDGLocalization
@_exported import SDGCalendar  // GregorianYear
@_exported import SDGVersioning

@_exported import SDGSwiftConfiguration

// #workaround(Swift 5.2.4, SwiftFormat cannot build.)
#if !os(WASI)
  @_exported import SwiftFormatConfiguration
#endif
