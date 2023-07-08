/*
 Page.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGHTML

  import WorkspaceConfiguration

  internal class Page {

    // MARK: - Initialization

    internal init(
      title: StrictString,
      content: StrictString
    ) {
      // Converted to Article.init(...)
      contents = ""
    }

    // MARK: - Properties

    internal let contents: StrictString
  }
#endif
