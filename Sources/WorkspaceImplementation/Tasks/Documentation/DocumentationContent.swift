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

  internal func discussionSections(cache: inout ParserCache) -> [SyntaxNode] {
    var cache = ParserCache()
    if let result =
      // MarkdownNode(Document)
      children(cache: &cache).lazy.compactMap({ $0 as? MarkdownNode }).first?
      // Paragraphs
      .children(cache: &cache)
      // Drop first paragraph and paragraph break.
      .dropFirst(2)
      .lazy.flatMap({ (node) -> [SyntaxNode] in
        if let markdown = node as? MarkdownNode,
          markdown.markdown is UnorderedList {
          return markdown.children(cache: &cache).filter { child in
            if let callout = child as? CalloutNode,
               callout.callout ∈ Set([.parameters, .parameter, .returns, .throws, .recommended, .recommendedOver, .localizationKey]) {
              return false
            }
            return true
          }
        } else {
          return [node]
        }
      }) {
        return Array(result)
    } else {
      return []
    }
  }

  internal func parameters() -> [ParameterDocumentation] {
    var result: [ParameterDocumentation] = []
    scanSyntaxTree({ (node, _) in
      if let callout = node as? CalloutNode {
        if callout.callout == .parameters {
          for child in callout.contents {
            if let entry = child as? ParametersEntry {
              result.append(
                ParameterDocumentation(
                  name: entry.parameterName.text(),
                  description: entry.contents
                )
              )
            }
          }
        } else if callout.callout == .parameter,
          let name = callout.parameterName {
          result.append(
            ParameterDocumentation(
              name: name.text(),
              description: callout.contents
            )
          )
        }
      }
      return ¬(node is SwiftSyntaxNode)  // Prevent scanning into example code.
    })
    return result
  }

  internal func returnsCallout() -> CalloutNode? {
    var result: CalloutNode?
    scanSyntaxTree({ (node, _) in
      if result ≠ nil {
        return false
      } else if let callout = node as? CalloutNode,
        callout.callout == .returns {
        result = callout
        return false
      } else {
        return true
      }
    })
    return result
  }

  internal func throwsCallout() -> CalloutNode? {
    var result: CalloutNode?
    scanSyntaxTree({ (node, _) in
      if result ≠ nil {
        return false
      } else if let callout = node as? CalloutNode,
        callout.callout == .throws {
        result = callout
        return false
      } else {
        return true
      }
    })
    return result
  }
}

#endif
