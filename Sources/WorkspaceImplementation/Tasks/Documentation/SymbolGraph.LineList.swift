
#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SymbolKit

import SwiftSyntax
import SDGSwiftSource

extension SymbolGraph.LineList {

  func documentation() -> DocumentationSyntax {
    let source = lines.lazy.map({ $0.text }).joined(separator: "\n")
    let triviaPiece = TriviaPiece.docBlockComment("/**\n\(source)\n*/")
    let trivia = Trivia(pieces: [triviaPiece])
    let extended = trivia.first!.syntax(siblings: trivia, index: trivia.indices.first!)
    return (extended as! BlockDocumentationSyntax).documentation
  }

  func normalizedParameters() -> [ParameterDocumentation] {
    documentation().normalizedParameters
  }
}
#endif
