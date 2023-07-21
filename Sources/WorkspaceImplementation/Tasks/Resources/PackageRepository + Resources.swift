/*
 PackageRepository + Resources.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftPackageManager

  import WorkspaceLocalizations

  extension PackageRepository {

    // MARK: - Structure

    @available(macOS 10.15, *)
    private func targets() throws -> [Target] {
      return try cachedPackage().targets.lazy.map { loaded in
        return Target(loadedTarget: loaded, package: self)
      }
    }
    @available(macOS 10.15, *)
    private func targetsByName() throws -> [String: Target] {
      var byName: [String: Target] = [:]
      for target in try targets() {
        byName[target.name] = target
      }
      return byName
    }

    // MARK: - Resources

    internal func refreshResources(output: Command.Output) throws {
      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      var targets: [Target: [Resource]] = [:]

      for target in try self.targets() {
        for resource in target.loadedTarget.resources {
          let namespace = resource.destination.components.map { StrictString($0) }
          targets[target, default: []].append(
            Resource(
              origin: resource.path.asURL,
              namespace: namespace,
              bundledName: StrictString(resource.destination.basenameWithoutExt),
              bundledExtension: resource.destination.extension.map({ StrictString($0) })
            )
          )
        }
      }

      for (target, resources) in targets.keys.sorted()
        .map({ ($0, targets[$0]!) })
      {  // So that output order is consistent.

        try purgingAutoreleased {
          try target.refresh(resources: resources, from: self, output: output)
        }
      }
    }
  }
#endif
