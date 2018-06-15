/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import GeneralImports

import SDGSwiftPackageManager
import SDGSwiftConfigurationLoading

import WorkspaceMetadata

extension PackageRepository {

    // MARK: - Cache

    private class MutatingCache {
        // Writing resources may add source files to targets.
        fileprivate var manifest: PackageModel.Manifest?
        fileprivate var package: PackageModel.Package?
        fileprivate var packageGraph: PackageGraph?
        fileprivate var products: [PackageModel.Product]?
        fileprivate var productModules: [Target]?
        fileprivate var dependenciesByName: [String: ResolvedPackage]?

        // Various tasks add source files.
        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
        fileprivate var sourceFiles: [URL]?
    }
    private static var mutatingCaches: [URL: MutatingCache] = [:]
    private var mutatingCache: MutatingCache {
        return cached(in: &PackageRepository.mutatingCaches[location]) {
            return MutatingCache()
        }
    }

    public func resetCache(debugReason: String) {
        PackageRepository.mutatingCaches[location] = MutatingCache()
        if BuildConfiguration.current == .debug {
            print("(Debug notice: Repository cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)")
        }
    }

    private class StaticCache {
        // Nothing modifies the package, product or module names or adds removes entries.
        fileprivate var configurationContext: WorkspaceContext?

        // Nothing modifies the configuration.
        fileprivate var configuration: WorkspaceConfiguration?
        fileprivate var sourceCopyright: StrictString?
        fileprivate var documentationCopyright: StrictString?
        fileprivate var readMe: [LocalizationIdentifier: StrictString]?
        fileprivate var contributingInstructions: StrictString?
        fileprivate var issueTemplate: StrictString?
    }
    private static var staticCaches: [URL: StaticCache] = [:]
    private var staticCache: StaticCache {
        return cached(in: &PackageRepository.staticCaches[location]) {
            return StaticCache()
        }
    }

    public func resetCachesForTesting() {
        resetCache(debugReason: "testing")
        PackageRepository.staticCaches[location] = StaticCache()
    }

    // MARK: - Miscellaneous Properties

    public func isWorkspaceProject() throws -> Bool {
        return try projectName() == "Workspace"
    }

    // MARK: - Manifest

    public func cachedManifest() throws -> PackageModel.Manifest {
        return try cached(in: &mutatingCache.manifest) {
            return try manifest()
        }
    }

    public func cachedPackage() throws -> PackageModel.Package {
        return try cached(in: &mutatingCache.package) {
            return try package()
        }
    }

    public func cachedPackageGraph() throws -> PackageGraph {
        return try cached(in: &mutatingCache.packageGraph) {
            return try packageGraph()
        }
    }

    public func projectName() throws -> StrictString {
        return StrictString(try cachedManifest().name)
    }

    public func products() throws -> [PackageModel.Product] {
        return try cached(in: &mutatingCache.products) {
            var products: [PackageModel.Product] = []

            // Filter out tools which have not been declared as products.
            let declaredTools: Set<String>
            switch try cachedManifest().package {
            case .v3:
                // [_Exempt from Test Coverage_] Not officially supported anyway.
                declaredTools = [] // No concept of products.
            case .v4(let manifest):
                declaredTools = Set(manifest.products.map({ $0.name }))
            }

            for product in try cachedPackage().products {
                switch product.type {
                case .library:
                    products.append(product)
                case .executable:
                    if product.name ∈ declaredTools {
                        products.append(product)
                    } else {
                        continue // skip
                    }
                case .test:
                    continue // skip
                }
            }
            return products
        }
    }

    public func productModules() throws -> [Target] {
        return try cached(in: &mutatingCache.productModules) {
            var accountedFor: Set<String> = []
            var result: [Target] = []
            for product in try cachedPackage().products where product.type.isLibrary {
                for module in product.targets where module.name ∉ accountedFor {
                    accountedFor.insert(module.name)
                    result.append(module)
                }
            }
            return result
        }
    }

    public func dependenciesByName() throws -> [String: ResolvedPackage] {
        return try cached(in: &mutatingCache.dependenciesByName) {
            let graph = try cachedPackageGraph()

            var result: [String: ResolvedPackage] = [:]
            for dependency in graph.packages {
                result[dependency.name] = dependency
            }
            return result
        }
    }

    // MARK: - Configuration

    public func configurationContext() throws -> WorkspaceContext {
        return try cached(in: &staticCache.configurationContext) {

            let products = try self.products().map { (product: PackageModel.Product) -> PackageManifest.Product in

                let type: PackageManifest.Product.ProductType
                let modules: [String]
                switch product.type {
                case .library:
                    type = .library
                    modules = product.targets.map { $0.name }
                case .executable:
                    type = .executable
                    modules = []
                case .test:
                    unreachable()
                }

                return PackageManifest.Product(name: product.name, type: type, modules: modules)
            }

            let manifest = PackageManifest(packageName: String(try projectName()), products: products)
            return WorkspaceContext(location: location, manifest: manifest)
        }
    }

    public func configuration() throws -> WorkspaceConfiguration {
        return try cached(in: &staticCache.configuration) {

            return try WorkspaceConfiguration.load(
                configuration: WorkspaceConfiguration.self,
                named: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Workspace"
                    }
                }),
                from: location,
                linkingAgainst: "WorkspaceConfiguration",
                in: SDGSwift.Package(url: Metadata.packageURL),
                at: Metadata.latestStableVersion,
                context: try configurationContext())
        }
    }

    public func developmentLocalization() throws -> LocalizationIdentifier {
        guard let result = try configuration().documentation.localizations.first else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "The project does not specify any localizations."
                }
            }))
        }
        return result
    }

    public func sourceCopyright() throws -> StrictString {
        return try cached(in: &staticCache.sourceCopyright) {
            return try configuration().fileHeaders.copyrightNotice.resolve(configuration())
        }
    }

    public func documentationCopyright() throws -> StrictString {
        return try cached(in: &staticCache.documentationCopyright) {
            return try configuration().documentation.api.copyrightNotice.resolve(configuration())
        }
    }

    public func readMe() throws -> [LocalizationIdentifier: StrictString] {
        return try cached(in: &staticCache.readMe) {
            return try configuration().documentation.readMe.contents.resolve(configuration())
        }
    }

    public func contributingInstructions() throws -> StrictString {
        return try cached(in: &staticCache.contributingInstructions) {
            return try configuration().gitHub.contributingInstructions.resolve(configuration())
        }
    }

    public func issueTemplate() throws -> StrictString {
        return try cached(in: &staticCache.issueTemplate) {
            return try configuration().gitHub.issueTemplate.resolve(configuration())
        }
    }

    // MARK: - Files

    public func allFiles() throws -> [URL] {
        return try cached(in: &mutatingCache.allFiles) {
            () -> [URL] in
            let files = try FileManager.default.deepFileEnumeration(in: location).filter { url in
                // Skip irrelevant operating system files.
                return url.lastPathComponent ≠ ".DS_Store"
                    ∧ ¬url.lastPathComponent.hasSuffix("~")
            }
            return files.sorted { $0.absoluteString.scalars.lexicographicallyPrecedes($1.absoluteString.scalars) } // So that output order is consistent.
            // [_Workaround: Simple “sorted()” differs between operating systems. (Swift 4.1)_]
        }
    }

    public func trackedFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &mutatingCache.trackedFiles) {
            () -> [URL] in

            var ignoredURLs: [URL] = try ignoredFiles()
            ignoredURLs.append(location.appendingPathComponent(".git"))

            let result = try allFiles().filter { (url) in
                for ignoredURL in ignoredURLs {
                    if url.is(in: ignoredURL) {
                        return false
                    }
                }
                return true
            }
            return result
        }
    }

    public func sourceFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &mutatingCache.sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                refreshScriptMacOSFileName,
                refreshScriptLinuxFileName,

                "Tests/Mock Projects" // To prevent treating them as Workspace source files for headers, etc.
                ].map({ location.appendingPathComponent( String($0)) })

            let result = try trackedFiles(output: output).filter { (url) in
                for generatedURL in generatedURLs {
                    if url.is(in: generatedURL) {
                        return false
                    }
                }
                return true
            }
            return result
        }
    }

    // MARK: - Actions

    public func delete(_ location: URL, output: Command.Output) {
        if FileManager.default.fileExists(atPath: location.path, isDirectory: nil) {

            output.print(UserFacingDynamic<StrictString, InterfaceLocalization, String>({ localization, path in
                switch localization {
                case .englishCanada:
                    return StrictString("Deleting “\(path)”...")
                }
            }).resolved(using: location.path(relativeTo: self.location)))

            try? FileManager.default.removeItem(at: location)
            resetCache(debugReason: location.lastPathComponent)
        }
    }
}
