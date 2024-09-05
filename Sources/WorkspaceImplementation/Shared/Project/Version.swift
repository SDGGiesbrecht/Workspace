/*
 Version.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGVersioning

  import SDGSwiftPackageManager

  import PackageModel

  extension SDGVersioning.Version {

    internal init(_ version: PackageModel.Version) {
      self.init(version.major, version.minor, version.patch)
    }

    internal func stringDroppingEmptyMinor() -> String {
      var result = string(droppingEmptyPatch: true)
      if result.hasSuffix(".0") {
        result.removeLast(2)
      }
      return result
    }
  }
#endif
