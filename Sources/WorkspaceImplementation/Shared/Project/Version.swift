/*
 Version.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGVersioning

import SDGSwiftPackageManager

// #workaround(SwiftPM 0.7.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import PackageModel
#endif

extension SDGVersioning.Version {

  // #workaround(SwiftPM 0.7.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))
    internal init(_ version: PackageModel.Version) {
      self.init(version.major, version.minor, version.patch)
    }
  #endif
}