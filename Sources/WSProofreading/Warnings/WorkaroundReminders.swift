/*
 WorkaroundReminders.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics
import WSGeneralImports
import SDGVersioning

import SDGExternalProcess

import WSProject

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

  // #workaround(Swift 5.2.2, Web lacks Foundation.)
  #if !os(WASI)
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

          if dependency == "Swift" {
            var newDetails = details
            let script: StrictString = "swift \u{2D}\u{2D}version"
            newDetails.replaceSubrange(
              versionCheckRange,
              with: "\(script) \(problemVersion.string())".scalars
            )
            if try message(for: newDetails, in: project, output: output) == nil {
              return nil
            }
          } else {
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
  #endif

  private static var dependencyVersionCache: [StrictString: SDGVersioning.Version?] = [:]
  // #workaround(Swift 5.2.2, Web lacks Foundation.)
  #if !os(WASI)
    private static func currentVersion(
      of dependency: StrictString,
      for project: PackageRepository,
      output: Command.Output
    ) throws -> SDGVersioning.Version? {
      #if os(Windows) || os(Android)  // #workaround(SwiftPM 0.5.0, Cannot build.)
        return nil
      #else
        if let dependency = try project.dependenciesByName()[String(dependency)],
          let version = dependency.manifest.version
        {
          return Version(version)
        } else {
          return cached(
            in: &dependencyVersionCache[dependency],
            {
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
          )  // @exempt(from: tests) Meaningless coverage region.
        }
      #endif  // @exempt(from: tests)
    }
  #endif
}
