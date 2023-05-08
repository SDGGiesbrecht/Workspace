import SDGSwiftSource

extension DocumentationContent {

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
                  description: entry.contents.compactMap({ ($0 as? MarkdownNode)?.markdown })
                )
              )
            }
          }
        } else if callout.callout == .parameter,
          let name = callout.parameterName {
          result.append(
            ParameterDocumentation(
              name: name.text(),
              description: callout.contents.compactMap({ ($0 as? MarkdownNode)?.markdown })
            )
          )
        }
      }
      return node is MarkdownNode
    })
    return result
  }
}
