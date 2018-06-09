

extension PackageManifest {

    /// A product of a package.
    public struct Product : Codable {

        // MARK: - Initialization

        /// :nodoc:
        public init(name: String, type: ProductType, modules: [String]) {
            self.name = name
            self.type = type
            self.modules = modules
        }

        // MARK: - Properties

        /// The name of the product.
        public let name: String

        /// The type of product.
        public let type: ProductType

        /// The modules the product provides.
        public let modules: [String]
    }
}
