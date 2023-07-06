
import WorkspaceConfiguration

internal struct Article {

  // MARK: - Initialization

  internal init(
    title: StrictString,
    content: StrictString
  ) {
    let escapedTitle = Markdown.escape(text: title)
    source = [
      "# \(escapedTitle)",
      "",
      content
    ].joined(separator: "\n")
  }

  // MARK: - Properties

  internal let source: StrictString
}
