import SDGSwift
@testable import WorkspaceImplementation

extension PackageRepository {

  static func resetRelatedProjectCache() {
    emptyRelatedProjectCache()
  }
}
