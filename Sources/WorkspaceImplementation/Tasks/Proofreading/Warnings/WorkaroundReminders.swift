/*
 WorkaroundReminders.swift

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
  import SDGControlFlow
  import SDGLogic
  import SDGMathematics
  import SDGText
  import SDGLocalization
  import SDGVersioning
  import SDGExternalProcess

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

  internal struct WorkaroundReminders: Warning {

    internal static let noticeOnly = true

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "workaroundReminders"
        case .deutschDeutschland:
          return "notlösungsErinnerungen"
        }
      })

    internal static let trigger = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "workaround"
      case .deutschDeutschland:
        return "notlösung"
      }
    })

    internal static func message(
      for details: StrictString,
      in project: PackageRepository,
      output: Command.Output
    ) throws -> UserFacing<StrictString, InterfaceLocalization>? {

      var description = details

      if let comma = details.scalars.firstMatch(for: ",".scalars) {
        description = StrictString(details.scalars[comma.range.upperBound...])

        let versionCheckRange = details.scalars.startIndex..<comma.range.lowerBound
        var versionCheck = StrictString(details.scalars[versionCheckRange])
        versionCheck.trimMarginalWhitespace()

        var parameters = versionCheck.components(separatedBy: " ".scalars)
        if ¬parameters.isEmpty,
          let problemVersion = Version(String(StrictString(parameters.removeLast().contents)))
        {

          var dependency =
            parameters
            .map({ StrictString($0.contents) })
            .joined(separator: " ")
          dependency.trimMarginalWhitespace()

          if let current = try currentVersion(
            of: dependency,
            for: project,
            output: output
          ) {
            if current ≤ problemVersion {
              return nil
            }
          }
        }
      }

      description.trimMarginalWhitespace()
      return UserFacing({ localization in
        let label: StrictString
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          label = "Workaround: "
        case .deutschDeutschland:
          label = "Notlösung: "
        }
        return label + description
      })
    }

    private static var dependencyVersionCache: [StrictString: SDGVersioning.Version?] = [:]
    private static func currentVersion(
      of dependency: StrictString,
      for project: PackageRepository,
      output: Command.Output
    ) throws -> SDGVersioning.Version? {
      if #available(macOS 10.15, *) {
        if let dependency = try project.dependenciesByName()[String(dependency)],
          let version = dependency.manifest.version
        {
          return Version(version)
        }
      }
      return cached(
        in: &dependencyVersionCache[dependency],
        {
          if dependency == "Swift" {
            return SwiftCompiler.version(forConstraints: Version(0, 0, 0)..<Version(1000, 0, 0))
          } else {
            if let shellOutput = try? Shell.default.run(
              command: String(dependency).components(separatedBy: " ")
            ).get(),
              let version = Version(firstIn: shellOutput)
            {
              return version
            } else {
              return nil
            }
          }
        }
      )  // @exempt(from: tests) Meaningless coverage region.
    }
  }
#endif
