/*
 Licence.swift

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
  import WorkspaceConfiguration

  extension Licence {

    // MARK: - Properties

    internal var text: StrictString {
      var source: String
      switch self {
      case .apache2_0:
        source = Resources.apache2_0
      case .mit:
        source = Resources.mit
      case .gnuGeneralPublic3_0:
        source = Resources.gnuGeneralPublic3_0
      case .unlicense:
        source = Resources.unlicense
      case .copyright:
        source = Resources.copyright
      }

      let file = TextFile(mockFileWithContents: source, fileType: FileType.markdown)
      return StrictString(file.body)
    }
  }
#endif
