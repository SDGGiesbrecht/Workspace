
/// Information from the package manifest.
public struct PackageManifest : Codable {

    // MARK: - Initialization

    /// :nodoc:
    public init(packageName: String, products: [Product]) {
        self.packageName = packageName
        self.products = products
    }

    // MARK: - Properties

    /// The name of the package.
    public let packageName: String

    /// The products the package provides.
    public let products: [Product]
}
