/*
 PackageGraph + Continuous Integration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections

// #workaround(SwiftPM 0.6.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import PackageModel
  import PackageGraph

  extension PackageGraph {

    internal func testTargets() -> [ResolvedTarget] {
      return rootPackages.flatMap({ $0.targets.filter({ $0.type == .test }) })
        .sorted(by: { $0.name < $1.name })
    }
  }
#endif
