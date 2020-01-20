/*
 PackageGraph.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import PackageModel
import PackageGraph

extension PackageGraph {

  func sortedNodes() -> [GraphNode] {
    var deterministicTargets: [GraphNode] = reachableTargets.map({ $0 })
      + reachableProducts.map({ $0 })
    var sortedTargets: [GraphNode] = []
    while ¬deterministicTargets.isEmpty {
      let next = deterministicTargets.firstIndex(where: { possible in
        return possible.dependencyNodes.allSatisfy({ dependency in
          return sortedTargets.contains(where: { handled in
            return handled.name == dependency.name
          })
        })
      })!
      sortedTargets.append(deterministicTargets.remove(at: next))
    }
    return sortedTargets
  }

  func target(named name: String) -> ResolvedTarget? {
    return reachableTargets.first(where: { $0.name == name })
  }
}
