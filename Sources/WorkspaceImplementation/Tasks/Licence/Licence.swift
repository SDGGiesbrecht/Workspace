/*
 Licence.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

extension Licence {

  // MARK: - Properties

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    internal var text: StrictString {
      var source: String
      switch self {
      case .apache2_0:
        source = Resources.Licences.apache2_0
      case .mit:
        source = Resources.Licences.mit
      case .gnuGeneralPublic3_0:
        source = Resources.Licences.gnuGeneralPublic3_0
      case .unlicense:
        source = Resources.Licences.unlicense
      case .copyright:
        source = Resources.Licences.copyright
      }

      let file = TextFile(mockFileWithContents: source, fileType: FileType.markdown)
      return StrictString(file.body)
    }
  #endif
}
