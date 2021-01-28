/*
 CheckForUpdates.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGLogic
import SDGText
import SDGLocalization
import SDGVersioning

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations
import WorkspaceProjectConfiguration

extension Workspace {
  internal enum CheckForUpdates {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "check‐for‐updates"
      case .deutschDeutschland:
        return "nach‐aktualisierungen‐suchen"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "checks for available Workspace updates."
        case .deutschDeutschland:
          return "sucht nach erhältliche Aktualisierungen zu Arbeitsbereich."
        }
      })

    internal static let command = Command(
      name: name,
      description: description,
      directArguments: [],
      options: [],
      execution: { (_, _, output: Command.Output) throws in
        if let update = try checkForUpdates(output: output) {
          // @exempt(from: tests) Execution path is determined externally.
            output.print(
              UserFacing<StrictString, InterfaceLocalization>({ localization in
                var url: URL = Metadata.documentationURL
                switch localization {
                case .englishUnitedKingdom:  // @exempt(from: tests)
                  url.appendPathComponent("🇬🇧EN/Installation.html")
                case .englishUnitedStates:  // @exempt(from: tests)
                  url.appendPathComponent("🇺🇸EN/Installation.html")
                case .englishCanada:  // @exempt(from: tests)
                  url.appendPathComponent("🇨🇦EN/Installation.html")
                case .deutschDeutschland:  // @exempt(from: tests)
                  url.appendPathComponent("🇩🇪DE/Installation.html")
                }
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return
                    "Workspace \(update.string()) is available.\nFor update instructions, see \(url.absoluteString.in(Underline.underlined))"
                case .deutschDeutschland:  // @exempt(from: tests)
                  return
                    "Arbeitsbereich \(update.string()) ist erhältlich.\nFür Aktualisierungsanweisungen, siehe \(url.absoluteString.in(Underline.underlined))"
                }
              }).resolved()
            )
        } else {
          // @exempt(from: tests) Execution path is determined externally.
          output.print(
            UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Workspace is up to date."
              case .deutschDeutschland:  // @exempt(from: tests)
                return "Arbeitsbereich ist auf dem neuesten Stand."
              }
            }).resolved()
          )
        }
      }
    )

    internal static func checkForUpdates(output: Command.Output) throws -> Version? {
      #if os(WASI)  // #workaround(SDGSwift 4.0.1, Web API incomplete.)
      return nil
      #else
        let latestRemote = try Package(url: Metadata.packageURL).versions().get().sorted().last!
        if latestRemote ≠ Metadata.latestStableVersion {
          // @exempt(from: tests) Execution path is determined externally.
          return latestRemote
        } else {  // @exempt(from: tests) Execution path is determined externally.
          // @exempt(from: tests)
          return nil  // Up to date.
        }
      #endif  // @exempt(from: tests)
    }
  }
}
