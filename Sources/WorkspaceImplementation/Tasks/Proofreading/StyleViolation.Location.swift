/*
 StyleViolation.Location.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGText

  extension StyleViolation {

    internal enum Location {
      case text(range: Range<String.ClusterView.Index>, file: TextFile)
    }
  }
#endif
