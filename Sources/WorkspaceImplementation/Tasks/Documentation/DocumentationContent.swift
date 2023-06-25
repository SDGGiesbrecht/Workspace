import SDGSwiftSource

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
      .dropFirst(2) {
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
                  description: entry.contents.compactMap({ ($0 as? MarkdownNode) })
                )
              )
            }
          }
        } else if callout.callout == .parameter,
          let name = callout.parameterName {
          result.append(
            ParameterDocumentation(
              name: name.text(),
              description: callout.contents.compactMap({ ($0 as? MarkdownNode) })
            )
          )
        }
      }
      return node is MarkdownNode
    })
    return result
  }
}
