/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import WorkspaceConfiguration

  import SDGExternalProcess

  extension Platform {

    // MARK: - Static Properties

    internal static let current: Platform = {
      #if os(macOS)
        return .macOS
      #elseif os(Windows)
        return .windows
      #elseif os(WASI)
        return .web
      #elseif os(Linux)
        if let systemInformation = try? Shell.default.run(command: ["cat", "/etc/os\u{2D}release"])
          .get()
        {
          if systemInformation.contains("ID=\u{22}amzn\u{22}") {  // @exempt(from: tests)
            return .amazonLinux  // @exempt(from: tests)
          }
        }
        return .ubuntu  // @exempt(from: tests)
      #elseif os(tvOS)
        return .tvOS
      #elseif os(iOS)
        return .iOS
      #elseif os(Android)
        return .android
      #elseif os(watchOS)
        return .watchOS
      #endif
    }()
  }
#endif
