
import Foundation

@testable import WorkspaceImplementation

var isInGitHubAction: Bool {
  return ProcessInfo.isInGitHubAction
}
