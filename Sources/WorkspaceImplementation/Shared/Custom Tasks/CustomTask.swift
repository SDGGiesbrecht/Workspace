/*
 CustomTask.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGExternalProcess

import SDGCommandLine

import SDGSwift

import WorkspaceConfiguration

extension CustomTask {

  // MARK: - Static Properties

  #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
    internal static let cache = FileManager.default.url(in: .cache, at: "Custom Tasks")
  #endif

  // MARK: - Execution

    internal func execute(output: Command.Output) throws {
      #if os(WASI)  // #workaround(SDGSwift 4.0.1, Web API incomplete.)
      _ = try Package(url: url).execute(
        .version(version),
        of: [executable],
        with: arguments,
        cacheDirectory: CustomTask.cache,
        reportProgress: { output.print($0) }
      ).get()
      #endif
    }
}
