/*
 DocumentationContent.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SDGLogic
import SDGCollections

import SDGSwiftSource
import Markdown

extension DocumentationContent {

  internal func descriptionSection(cache: inout ParserCache) -> ParagraphNode? {
    var cache = ParserCache()
    return
      // MarkdownNode(Document)
      children(cache: &cache).lazy.compactMap({ $0 as? MarkdownNode }).first?
      // MarkdownNode(Paragraph)
      .children(cache: &cache).lazy.compactMap({ $0 as? MarkdownNode }).first?
      // ParagraphNode
      .children(cache: &cache).first as? ParagraphNode
  }
}

#endif
