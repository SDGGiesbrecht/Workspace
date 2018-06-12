
import SDGSwiftConfiguration

/// External information about the project.
public struct WorkspaceContext : Context {

    // MARK: - Static Properties

    /// The context of the current project.
    public static var current: WorkspaceContext = accept()!

    // MARK: - Initialization

    /// :nodoc:
    public init(location: URL, manifest: PackageManifest) {
        self.location = location
        self.manifest = manifest
    }

    // MARK: - Properties

    /// The location of the configured repository.
    public let location: URL

    /// Information from the package manifest.
    public let manifest: PackageManifest
}
