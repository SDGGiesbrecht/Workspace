/*
 SymbolGraph.Symbol.KindIdentifier.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SymbolKit

  extension SymbolGraph.Symbol.KindIdentifier {

    internal func warnUnknown(
      file: StaticString = #fileID,
      line: UInt = #line
    ) {
      #if DEBUG  // @exempt(from: tests)
        print("Unkown symbol kind: \(identifier), \(file):\(line)")
      #endif
    }
  }

#endif
