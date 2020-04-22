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

#if !(os(Windows) || os(WASI) || os(Android))  // #workaround(SwiftPM 0.6.0, Cannot build.)
  @_exported import class PackageModel.Manifest
  @_exported import class PackageModel.Package
  @_exported import struct PackageGraph.PackageGraph
  @_exported import class PackageModel.Product
  @_exported import enum PackageModel.ProductType
  @_exported import class PackageModel.ResolvedPackage
  @_exported import class PackageModel.Target
#endif

@_exported import WorkspaceConfiguration
