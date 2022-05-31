/*
 PackageRepository + Resources.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    private static let deprecatedResourceDirectoryName = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Resources"
        case .deutschDeutschland:
          return "Ressourcen"
        }
      })

    // #warning(Add rule warning about their presence.)
    private func deprecatedResourceDirectories() -> [URL] {

      return InterfaceLocalization.allCases.map { (localization) in
        return location.appendingPathComponent(
          String(PackageRepository.deprecatedResourceDirectoryName.resolved(for: localization))
        )
      }
    }

    // MARK: - Resources

    private func deprecatedResourceFiles(output: Command.Output) throws -> [URL] {
      let locations = deprecatedResourceDirectories()

      let result = try trackedFiles(output: output).filter { file in
        for directory in locations where file.is(in: directory) {
          return true
        }
        // @exempt(from: tests) False coverage result in Xcode 10.1.
        return false
      }
      return result
    }

    @available(macOS 10.15, *)
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

    internal func refreshResources(output: Command.Output) throws {
      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      var targets: [Target: [URL]] = [:]
      for resource in try deprecatedResourceFiles(output: output) {
        let intendedTarget = try target(for: resource, output: output)
        targets[intendedTarget, default: []].append(resource)
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
