/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftPackageManager

extension PackageRepository {

  // MARK: - Structure

  private func targets() throws -> [Target] {
    return try cachedPackage().manifest.targets.lazy.map { description in
      return Target(description: description, package: self)
    }
  }
  private func targetsByName() throws -> [String: Target] {
    var byName: [String: Target] = [:]
    for target in try targets() {
      byName[target.name] = target
    }
    return byName
  }

  private static let resourceDirectoryName
    = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Resources"
      case .deutschDeutschland:
        return "Ressourcen"
      }
    })

  private func resourceDirectories() -> [URL] {

    return InterfaceLocalization.allCases.map { (localization) in
      return location.appendingPathComponent(
        String(PackageRepository.resourceDirectoryName.resolved(for: localization))
      )
    }
  }

  // MARK: - Resources

  private func resourceFiles(output: Command.Output) throws -> [URL] {
    let locations = resourceDirectories()

    let result = try trackedFiles(output: output).filter { file in
      for directory in locations where file.is(in: directory) {
        return true
      }
      // @exempt(from: tests) False coverage result in Xcode 10.1.
      return false
    }
    return result
  }

  private func target(for resource: URL, output: Command.Output) throws -> Target {
    let path = resource.path(relativeTo: location).dropping(through: "/")
    guard let targetName = path.prefix(upTo: "/")?.contents else {
      throw Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              "No target specified for resource:\n\(path)\nFiles must be in subdirectories named corresponding to the intended target."
          case .deutschDeutschland:
            return
              "Kein Ziel wurde für eine Ressource angegeben:\n\(path)\nDateien müssen in Unterverzeichnissen sein, dessen Namen mit dem gemeinten Ziel übereinstimmen."
          }
        })
      )
    }
    guard let target = (try targetsByName())[String(targetName)] else {
      throw Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
          switch localization {
          case .englishUnitedKingdom:
            return
              "No target named ‘\(targetName)’.\nResources must be in subdirectories named corresponding to the intended target."
          case .englishUnitedStates, .englishCanada:
            return
              "No target named “\(targetName)”.\nResources must be in subdirectories named corresponding to the intended target."
          case .deutschDeutschland:
            return
              "Kein Ziel Namens „\(targetName)“.\nRessourcen müssen in Unterverzeichnissen sein, dessen Namen mit dem gemeinten Ziel übereinstimmen."
          }
        })
      )
    }
    return target
  }

  public func refreshResources(output: Command.Output) throws {

    var targets: [Target: [URL]] = [:]
    for resource in try resourceFiles(output: output) {
      let intendedTarget = try target(for: resource, output: output)
      targets[intendedTarget, default: []].append(resource)
    }

    for (target, resources) in targets.keys.sorted()
      .map({ ($0, targets[$0]!) })
    {  // So that output order is consistent.

      try autoreleasepool {
        try target.refresh(resources: resources, from: self, output: output)
      }
    }
  }
}
