/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation
  #if os(Windows)
    import WinSDK
  #endif

  import SDGControlFlow
  import SDGLogic
  import SDGCollections
  import SDGExternalProcess

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftPackageManager
  import SDGSwiftConfigurationLoading

  import PackageModel
  import PackageGraph

  import WorkspaceLocalizations
  import WorkspaceConfiguration
  import WorkspaceProjectConfiguration

  extension PackageRepository {

    private static let macOSDeploymentVersion = SDGVersioning.Version(10, 12)

    // MARK: - Cache

    // This needs to be reset if any files are added, renamed, or deleted.
    private class FileCache {
      fileprivate var allFiles: [URL]?
      fileprivate var trackedFiles: [URL]?
      fileprivate var sourceFiles: [URL]?

      fileprivate var examples: [StrictString: StrictString]?
      fileprivate var documentation: [StrictString: StrictString]?
    }
    private static var fileCaches: [URL: FileCache] = [:]
    private var fileCache: FileCache {
      return cached(in: &PackageRepository.fileCaches[location]) {
        return FileCache()
      }
    }

    internal func resetFileCache(debugReason: String) {
      PackageRepository.fileCaches[location] = FileCache()
      #if DEBUG
        print(
          "(Debug notice: File cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)"
        )
      #endif
    }

    // This only needs to be reset if a Swift source file is added, renamed, or removed.
    // Modifications to file contents do not require a reset (except Package.swift, which is never altered by Workspace).
    // Changes to support files do not require a reset (read‐me, etc.).
    private class ManifestCache {
      private var _manifest: Any?
      @available(macOS 10.15, *)
      fileprivate var manifest: PackageModel.Manifest? {
        get {
          return _manifest as? PackageModel.Manifest
        }
        set {
          _manifest = newValue
        }
      }
      private var _package: Any?
      @available(macOS 10.15, *)
      fileprivate var package: PackageModel.Package? {
        get {
          return _package as? PackageModel.Package
        }
        set {
          _package = newValue
        }
      }
      private var _packageGraph: Any?
      @available(macOS 10.15, *)
      fileprivate var packageGraph: PackageGraph? {
        get {
          return _packageGraph as? PackageGraph
        }
        set {
          _packageGraph = newValue
        }
      }
      private var _products: Any?
      @available(macOS 10.15, *)
      fileprivate var products: [PackageModel.Product]? {
        get {
          return _products as? [PackageModel.Product]
        }
        set {
          _products = newValue
        }
      }
      private var _dependenciesByName: Any?
      @available(macOS 10.15, *)
      fileprivate var dependenciesByName: [String: ResolvedPackage]? {
        get {
          return _dependenciesByName as? [String: ResolvedPackage]
        }
        set {
          _dependenciesByName = newValue
        }
      }
    }
    private static var manifestCaches: [URL: ManifestCache] = [:]
    private var manifestCache: ManifestCache {
      return cached(in: &PackageRepository.manifestCaches[location]) {
        return ManifestCache()
      }
    }

    internal func resetManifestCache(debugReason: String) {
      resetFileCache(debugReason: debugReason)
      PackageRepository.manifestCaches[location] = ManifestCache()
      #if DEBUG
        print(
          "(Debug notice: Manifest cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)"
        )
      #endif
    }

    // These do not need to be reset during the execution of any command. (They do between tests.)
    private class ConfigurationCache {
      // Nothing modifies the package, product or module names or adds removes entries.
      fileprivate var configurationContext: WorkspaceContext?

      // Nothing modifies the configuration.
      fileprivate var configuration: WorkspaceConfiguration?
      fileprivate var fileHeader: StrictString?
      fileprivate var documentationCopyright: [LocalizationIdentifier: StrictString]?
      fileprivate var readMe: [LocalizationIdentifier: StrictString]?
      fileprivate var contributingInstructions: [LocalizationIdentifier: Markdown]?
      fileprivate var issueTemplates: [LocalizationIdentifier: [IssueTemplate]]?
    }
    private static var configurationCaches: [URL: ConfigurationCache] = [:]
    private var configurationCache: ConfigurationCache {
      return cached(in: &PackageRepository.configurationCaches[location]) {
        return ConfigurationCache()
      }
    }

    internal func resetConfigurationCache(debugReason: String) {
      resetManifestCache(debugReason: "testing")
      PackageRepository.configurationCaches[location] = ConfigurationCache()
      #if DEBUG
        print(
          "(Debug notice: Configuration cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)"
        )
      #endif
    }

    // MARK: - Environment

    internal static func with<T>(
      environment variable: StrictString,
      closure: () throws -> T
    ) rethrows -> T {
      let key = String(variable)
      let value = "true"
      #if os(Windows)
        key.withCString(
          encodedAs: UTF16.self,
          { keyString in
            value.withCString(encodedAs: UTF16.self) { valueString in
              SetEnvironmentVariableW(keyString, valueString)
            }
          }
        )
        defer {
          key.withCString(
            encodedAs: UTF16.self,
            { keyString in
              SetEnvironmentVariableW(keyString, nil)
            }
          )
        }
      #else
        setenv(key, value, 1)
        defer { unsetenv(key) }
      #endif
      return try closure()
    }

    // MARK: - Miscellaneous Properties

    internal func isWorkspaceProject() throws -> Bool {
      return try packageName() == "Workspace"
    }

    // MARK: - Manifest

    @available(macOS 10.15, *)
    internal func cachedManifest() throws -> PackageModel.Manifest {
      return try cached(in: &manifestCache.manifest) {
        return try manifest().get()
      }
    }

    @available(macOS 10.15, *)
    internal func cachedPackage() throws -> PackageModel.Package {
      return try cached(in: &manifestCache.package) {
        return try package().get()
      }
    }

    @available(macOS 10.15, *)
    internal func cachedPackageGraph() throws -> PackageGraph {
      return try cached(in: &manifestCache.packageGraph) {
        return try packageGraph().get()
      }
    }

    internal func packageName() throws -> StrictString {
      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      return StrictString(try cachedManifest().displayName)
    }

    internal func projectName(
      in localization: LocalizationIdentifier,
      output: Command.Output
    ) throws -> StrictString {
      return try configuration(output: output).projectName[localization] ?? packageName()
    }

    internal func localizedIsolatedProjectName(output: Command.Output) throws -> StrictString {
      let identifier = UserFacing<LocalizationIdentifier, InterfaceLocalization>({ localization in
        return LocalizationIdentifier(localization.code)
      }).resolved()
      return try projectName(in: identifier, output: output)
    }

    @available(macOS 10.15, *)
    internal func products() throws -> [PackageModel.Product] {
      return try cached(in: &manifestCache.products) {
        var products: [PackageModel.Product] = []

        // Filter out tools which have not been declared as products.
        let declaredTools: Set<String> = Set(
          try cachedManifest().products.lazy.map({ $0.name })
        )

        for product in try cachedPackage().products where ¬product.name.hasPrefix("_") {
          switch product.type {
          case .library:
            products.append(product)
          case .executable:
            if product.name ∈ declaredTools {
              products.append(product)
            } else {
              continue  // skip
            }
          case .plugin, .test, .snippet:
            continue  // skip
          }
        }
        return products
      }
    }

    @available(macOS 10.15, *)
    internal func dependenciesByName() throws -> [String: ResolvedPackage] {
      return try cached(in: &manifestCache.dependenciesByName) {
        let graph = try cachedPackageGraph()

        var result: [String: ResolvedPackage] = [:]
        for dependency in graph.packages {
          result[dependency.manifest.displayName] = dependency
        }
        return result
      }
    }

    // MARK: - Configuration

    internal func configurationContext() throws -> WorkspaceContext {
      return try cached(in: &configurationCache.configurationContext) {
        guard #available(macOS 10.15, *) else {
          throw SwiftPMUnavailableError()  // @exempt(from: tests)
        }
        let products = try self.products()
          .map { (product: PackageModel.Product) -> PackageManifest.Product in

            let type: PackageManifest.Product.ProductType
            let modules: [String]
            switch product.type {
            case .library:
              type = .library
              modules = product.targets.map { $0.name }
            case .executable:
              type = .executable
              modules = []
            case .plugin, .test, .snippet:
              unreachable()
            }

            return PackageManifest.Product(_name: product.name, type: type, modules: modules)
          }

        let manifest = PackageManifest(
          _packageName: String(try packageName()),
          products: products
        )
        return WorkspaceContext(_location: location, manifest: manifest)
      }
    }

    internal static let workspaceConfigurationNames = UserFacing<
      StrictString, InterfaceLocalization
    >(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Workspace"
        case .deutschDeutschland:
          return "Arbeitsbereich"
        }
      })

    internal func configuration(output: Command.Output) throws -> WorkspaceConfiguration {
      return try cached(in: &configurationCache.configuration) {

        // Provide the context in case resolution happens internally.
        WorkspaceContext.current = try configurationContext()

        let result: WorkspaceConfiguration
        if try isWorkspaceProject() {
          result = WorkspaceProjectConfiguration.configuration
        } else {
          result = try WorkspaceConfiguration.load(
            configuration: WorkspaceConfiguration.self,
            named: PackageRepository.workspaceConfigurationNames,
            from: location,
            linkingAgainst: "WorkspaceConfiguration",
            in: "Workspace",
            from: Metadata.packageURL,
            at: Metadata.latestStableVersion,
            minimumMacOSVersion: PackageRepository.macOSDeploymentVersion,
            context: try configurationContext(),
            reportProgress: { output.print($0) }
          ).get()
        }

        // Force lazy options to resolve under the right context before it changes.
        let encoded = try JSONEncoder().encode(result)
        return try JSONDecoder().decode(WorkspaceConfiguration.self, from: encoded)
      }
    }

    private static var fellBackToUserLocalization = false
    internal static func resetLocalizationFallback() {
      fellBackToUserLocalization = false
    }
    internal static func localizationFallbackWarning() -> StrictString? {
      guard fellBackToUserLocalization else {
        return nil
      }
      return UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom:
          return
            ([
              "The project has no localisations configured.",
              "Workspace has fallen back to the system language, which may produce different results on different devices.",
              WorkspaceConfiguration.configurationRecommendation(
                for: "documentation.localisations",
                localization: localization
              ),
            ] as [StrictString]).joinedAsLines()
        case .englishUnitedStates, .englishCanada:
          return
            ([
              "The project has no localizations configured.",
              "Workspace has fallen back to the system language, which may produce different results on different devices.",
              WorkspaceConfiguration.configurationRecommendation(
                for: "documentation.localizations",
                localization: localization
              ),
            ] as [StrictString]).joinedAsLines()
        case .deutschDeutschland:
          return
            ([
              "Das Projekt hat keine eingestellte Lokalisationen.",
              "Arbeitsbereich ist auf die Systemsprache zurückgefallen. Das kann zu verschiedenen Ergebnissen auf verschiedenen Geräten führen.",
              WorkspaceConfiguration.configurationRecommendation(
                for: "dokumentation.localisationen",
                localization: localization
              ),
            ] as [StrictString]).joinedAsLines()
        }
      }).resolved()
    }
    internal func developmentLocalization(output: Command.Output) throws -> LocalizationIdentifier {
      if let specified = try configuration(output: output).documentation.localizations.first {
        return specified
      } else {
        PackageRepository.fellBackToUserLocalization = true
        return LocalizationIdentifier(AnyLocalization.resolved())
      }
    }

    internal func fileHeader(output: Command.Output) throws -> StrictString {
      return try cached(in: &configurationCache.fileHeader) {
        return try configuration(output: output).fileHeaders.contents.resolve(
          configuration(output: output)
        )
      }
    }

    internal func documentationCopyright(
      output: Command.Output
    ) throws -> [LocalizationIdentifier: StrictString] {
      return try cached(in: &configurationCache.documentationCopyright) {
        return try configuration(output: output).documentation.api.copyrightNotice.resolve(
          configuration(output: output)
        )
      }
    }

    internal func readMe(output: Command.Output) throws -> [LocalizationIdentifier: StrictString] {
      return try cached(in: &configurationCache.readMe) {
        return try configuration(output: output).documentation.readMe.contents.resolve(
          configuration(output: output)
        )
      }
    }

    internal func contributingInstructions(
      output: Command.Output
    ) throws -> [LocalizationIdentifier: Markdown] {
      return try cached(in: &configurationCache.contributingInstructions) {
        return try configuration(output: output).gitHub.contributingInstructions.resolve(
          configuration(output: output)
        )
      }
    }

    internal func issueTemplates(
      output: Command.Output
    ) throws -> [LocalizationIdentifier: [IssueTemplate]] {
      return try cached(in: &configurationCache.issueTemplates) {
        return try configuration(output: output).gitHub.issueTemplates.resolve(
          configuration(output: output)
        )
      }
    }

    // MARK: - Files

    internal func allFiles() throws -> [URL] {
      return try cached(in: &fileCache.allFiles) { () -> [URL] in
        let files = try FileManager.default.deepFileEnumeration(in: location).filter { url in
          // Skip irrelevant operating system files.
          return url.lastPathComponent ≠ ".DS_Store"
            ∧ ¬url.lastPathComponent.hasSuffix("~")
        }
        return files.sorted()
      }
    }

    internal func trackedFiles(output: Command.Output) throws -> [URL] {
      return try cached(in: &fileCache.trackedFiles) { () -> [URL] in

        var ignoredURLs: [URL] = try ignoredFiles().get()
        ignoredURLs.append(location.appendingPathComponent(".git"))

        let result = try allFiles().filter { url in
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

    internal func sourceFiles(output: Command.Output) throws -> [URL] {
      let configuration = try self.configuration(output: output)
      let ignoredTypes = configuration.repository.ignoredFileTypes
      let ignoredPaths = configuration.repository.ignoredPaths.map {
        location.appendingPathComponent($0)
      }

      return try cached(in: &fileCache.sourceFiles) { () -> [URL] in
        return try trackedFiles(output: output).filter { url in
          for path in ignoredPaths {
            if url.is(in: path) {
              return false
            }
          }
          return url.pathExtension ∉ ignoredTypes ∧ url.lastPathComponent ∉ ignoredTypes
        }
      }
    }

    internal func _withExampleCache(
      _ operation: () throws -> [StrictString: StrictString]
    ) rethrows -> [StrictString: StrictString] {
      return try cached(in: &fileCache.examples) {
        return try operation()
      }
    }

    internal func _withDocumentationCache(
      _ operation: () throws -> [StrictString: StrictString]
    ) rethrows -> [StrictString: StrictString] {
      return try cached(in: &fileCache.documentation) {
        return try operation()
      }
    }

    // MARK: - Actions

    internal func delete(_ location: URL, output: Command.Output) {
      if FileManager.default.fileExists(atPath: location.path, isDirectory: nil) {

        output.print(
          UserFacingDynamic<
            StrictString,
            InterfaceLocalization,
            String
          >({ localization, path in
            switch localization {
            case .englishUnitedKingdom:
              return "Deleting ‘\(path)’..."
            case .englishUnitedStates, .englishCanada:
              return "Deleting “\(path)”..."
            case .deutschDeutschland:
              return "„\(path)“ wird gelöscht ..."
            }
          }).resolved(using: location.path(relativeTo: self.location))
        )

        try? FileManager.default.removeItem(at: location)
        if location.pathExtension == "swift" {
          // @exempt(from: tests) Nothing deletes Swift files yet.
          resetManifestCache(debugReason: location.lastPathComponent)
        } else {
          resetFileCache(debugReason: location.lastPathComponent)
        }
      }
    }

    // MARK: - Related Projects

    private static let relatedProjectCache = FileManager.default.url(
      in: .cache,
      at: "Related Projects"
    )

    internal static func relatedPackage(
      _ package: SDGSwift.Package,
      output: Command.Output
    ) throws -> PackageRepository {
      let directoryName = StrictString(package.url.lastPathComponent)
      let cache = relatedProjectCache.appendingPathComponent(String(directoryName))

      let commit = try package.latestCommitIdentifier().get()

      let repositoryLocation = cache.appendingPathComponent(commit).appendingPathComponent(
        String(directoryName)
      )

      let repository: PackageRepository
      if (try? repositoryLocation.checkResourceIsReachable()) == true {
        repository = PackageRepository(at: repositoryLocation)
      } else {
        try? FileManager.default.removeItem(at: cache)  // Remove older commits.
        do {

          output.print(
            UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom:  // @exempt(from: tests)
                // Exemption because it is too time consuming to rebuild cache for each localization.
                return "Fetching ‘\(package.url.lastPathComponent)’..."
              case .englishUnitedStates, .englishCanada:
                return "Fetching “\(package.url.lastPathComponent)”..."
              case .deutschDeutschland:  // @exempt(from: tests)
                return "„\(package.url.lastPathComponent)“ wird abgerufen ..."
              }
            }).resolved()
          )

          repository = try PackageRepository.clone(
            package,
            to: repositoryLocation,
            at: .development,
            shallow: true
          ).get()
        } catch {
          // Clean up if there is a failure.
          try? FileManager.default.removeItem(at: cache)

          throw error
        }
      }

      return repository
    }

    internal static func emptyRelatedProjectCache() {
      try? FileManager.default.removeItem(at: relatedProjectCache)
    }
  }
#endif
