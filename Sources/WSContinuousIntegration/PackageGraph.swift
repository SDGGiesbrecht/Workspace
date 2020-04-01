/*
 PackageGraph.swift

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

#if !(os(Windows) || os(Android))  // #workaround(SwiftPM 0.5.0, Cannot build.)
  import PackageModel
  import PackageGraph

  extension PackageGraph {

    func sortedReachableTargets() -> [(package: ResolvedPackage, target: ResolvedTarget)] {
      var discovered: [(package: ResolvedPackage, target: ResolvedTarget)] = []
      for package in packages {
        for target in package.targets {
          discovered.append((package: package, target: target))
        }
      }

      let reachable = Set(reachableTargets.map({ $0.name }))
      discovered.removeAll(where: { $0.target.name ∉ reachable })
      discovered.sort(by: { ($0.package.name, $0.target.name) < ($1.package.name, $1.target.name) })

      var sorted: [(package: ResolvedPackage, target: ResolvedTarget)] = []
      while ¬discovered.isEmpty {
        let next = discovered.firstIndex(where: { possible in
          return possible.target.dependencies.allSatisfy({ dependency in
            if let target = dependency.target {
              return sorted.contains(where: { $0.target.name == target.name })
            } else {
              let inherited =
                dependency.product?.targets
                ?? []  // @exempt(from: tests) Never nil.
              return inherited.allSatisfy { productTarget in
                return sorted.contains(where: { $0.target.name == productTarget.name })
              }
            }
          })
        })!
        sorted.append(discovered.remove(at: next))
      }
      return sorted
    }
  }
#endif
