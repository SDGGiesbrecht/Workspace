
import SDGCollections

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

    /// The list of the publically accessible modules.
    public var productModules: [String] {
        var accountedFor: Set<String> = []
        var result: [String] = []
        for product in products {
            for module in product.modules where module ∉ accountedFor {
                accountedFor.insert(module)
                result.append(module)
            }
        }
        return result
    }
}
