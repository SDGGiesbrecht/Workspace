
#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
import SDGText

import SwiftSyntax

extension String {

  private func index(ofPositionInOutermostTree position: AbsolutePosition) -> String.ScalarView.Index {
    let utf8 = self.utf8
    let utf8Index = utf8.index(utf8.startIndex, offsetBy: position.utf8Offset)
    return utf8Index.scalar(in: scalars)
  }

  internal func indices(ofPositionsInOutermostTree positions: Range<AbsolutePosition>) -> Range<String.ScalarView.Index> {
    return index(ofPositionInOutermostTree: positions.lowerBound) ..< index(ofPositionInOutermostTree: positions.upperBound)
  }

  internal func indices<S>(ofNodeInOutermostTree node: S) -> Range<String.ScalarView.Index>
  where S: SyntaxProtocol {
    return indices(ofPositionsInOutermostTree: node.positionAfterSkippingLeadingTrivia..<node.endPositionBeforeTrailingTrivia)
  }
}
#endif
