
import SDGSwiftConfiguration

/// External information about the project.
public struct WorkspaceContext : Context {

    // MARK: - Static Properties

    /// The context of the current project.
    public static var current: WorkspaceContext = accept()!

    // MARK: - Initialization

    /// :nodoc:
    public init(manifest: PackageManifest) {
        self.manifest = manifest
    }

    // MARK: - Properties

    /// Information from the package manifest.
    public let manifest: PackageManifest
}
