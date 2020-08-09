/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WorkspaceConfiguration

import SDGExternalProcess

extension Platform {

  // MARK: - Static Properties

  #warning("Not resolved yet.")
  public static var current: Platform {
    switch Shell.default.run(command: ["cat", "/etc/os-release"]) {
    case .failure(let failure):
      print(failure)
    case .success(let success):
      print(success)
    }
    #if os(macOS)
      return .macOS
    #elseif os(Windows)
      return .windows
    #elseif os(WASI)
      return .web
    #elseif os(Linux)
      return .ubuntu
    #elseif os(Android)
      return .android
    #endif
  }
}
