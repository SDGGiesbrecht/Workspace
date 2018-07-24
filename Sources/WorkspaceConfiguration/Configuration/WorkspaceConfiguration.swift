/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import SDGSwiftConfiguration

// #example(1, sampleConfiguration)
/// A Workspace configuration.
///
/// Workspace can be configured by placing a Swift file named `Workspace.swift` in the project root.
///
/// The contents of a configuration file might look something like this:
///
/// ```swift
/// import WorkspaceConfiguration
///
/// /*
///  Exernal packages can be imported with this syntax:
///  import [module] // [url], [version], [product]
///  */
/// import SDGControlFlow // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
///
/// let configuration = WorkspaceConfiguration()
/// configuration.optIntoAllTasks()
/// configuration.documentation.readMe.manage = true
/// configuration.documentation.readMe.shortProjectDescription["en"] = "This is just an example."
/// ```
public final class WorkspaceConfiguration : Configuration {

    // MARK: - Static Properties

    internal static var registered: WorkspaceConfiguration!

    // MARK: - Properties

    /// Whether or not to provide workflow scripts.
    ///
    /// This is on by default.
    ///
    /// ```shell
    /// $ workspace refresh scripts
    /// ```
    ///
    /// These scripts are provided to reduce refreshment and validation to a simple double‐click. They will also ensure that the same version of Workspace gets used for the project on every machine it is cloned to.
    public var provideWorkflowScripts: Bool = true

    /// The operating systems the project supports.
    ///
    /// The default assumes support for all operating systems.
    public var supportedOperatingSystems: Set<OperatingSystem> = Set(OperatingSystem.cases)

    /// Options related to Git.
    public var git: GitConfiguration = GitConfiguration()

    /// Options related to licencing.
    public var licence: LicenceConfiguration = LicenceConfiguration()

    /// Options related to file headers.
    public var fileHeaders: FileHeaderConfiguration = FileHeaderConfiguration()

    /// Options related to GitHub.
    public var gitHub: GitHubConfiguration = GitHubConfiguration()

    /// Options related to Xcode.
    public var xcode: XcodeConfiguration = XcodeConfiguration()

    /// Options related to proofreading.
    public var proofreading: ProofreadingConfiguration = ProofreadingConfiguration()

    /// Options related to building and testing.
    public var testing: TestingConfiguration = TestingConfiguration()

    /// Options related to documentation.
    public var documentation: DocumentationConfiguration = DocumentationConfiguration()

    /// Options related to continuous integration.
    public var continuousIntegration: ContinuousIntegrationConfiguration = ContinuousIntegrationConfiguration()

    /// Options related to the project repository.
    public var repository: RepositoryConfiguration = RepositoryConfiguration()

    /// :nodoc:
    internal var isSDG: Bool = false

    // MARK: - Methods

    /// Opts into all tasks which are off by default.
    ///
    /// - Warning: Many opt‐in tasks involve writing into project files.
    public func optIntoAllTasks() {
        git.manage = true
        licence.manage = true
        fileHeaders.manage = true
        gitHub.manage = true
        xcode.manage = true
        documentation.readMe.manage = true
        continuousIntegration.manage = true
        documentation.api.generate = true
    }

    /// :nodoc:
    public func applySDGDefaults() {

        isSDG = true
        optIntoAllTasks()

        documentation.primaryAuthor = "Jeremy David Giesbrecht"
        gitHub.administrators = ["SDGGiesbrecht"]

        licence.licence = .apache2_0

        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGSwift")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCommandLine")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCornerstone")!))
    }

    /// :nodoc:
    public func applySDGOverrides() {
        let project = WorkspaceContext.current.manifest.packageName
        let about = [
            "The \(project) project is maintained by Jeremy David Giesbrecht.",
            "",
            "If \(project) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
            "",
            "If \(project) saves you time, consider devoting some of it to [contributing](\(documentation.repositoryURL?.absoluteString ?? "")) back to the project.", // @exempt(from: tests)
            "",
            "> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa"
            ].joinedAsLines()
        for localization in ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN"] as [LocalizationIdentifier] {
            documentation.readMe.about[localization] = Markdown(about)
        }
    }

    /// :nodoc:
    public func validateSDGStandards(requireExamples: Bool = true) {
        let needsAPIDocumentation = WorkspaceContext.current.manifest.products.contains(where: { $0.type == .library })

        assert(documentation.currentVersion ≠ nil, "No version specified.")

        assert(documentation.projectWebsite ≠ nil, "No project website specified.")
        if needsAPIDocumentation {
            assert(documentation.documentationURL ≠ nil, "No documentation URL specified.")
        }
        assert(documentation.repositoryURL ≠ nil, "No repository URL specified.")

        assert(documentation.readMe.quotation ≠ nil, "No quotation specified.")

        if needsAPIDocumentation {
            assert(documentation.api.yearFirstPublished ≠ nil, "No first year of publication specified.")
            assert(documentation.api.encryptedTravisCIDeploymentKey ≠ nil, "No Travis CI deployment key specified.")
        }

        assert(¬documentation.localizations.isEmpty, "No localizations specified.")

        for localization in documentation.localizations {
            assert(documentation.readMe.shortProjectDescription[localization] ≠ nil, "No short project description specified for “\(localization)”.")

            if localization ≠ "🇮🇱עב" ∧ localization ≠ "🇬🇷ΕΛ" {
                assert(documentation.readMe.quotation?.translation[localization] ≠ nil, "No translation specified for “\(localization)”.")
            }
            assert(documentation.readMe.quotation?.citation[localization] ≠ nil, "No citation specified for “\(localization)”.")
            assert(documentation.readMe.quotation?.link[localization] ≠ nil, "No quotation link specified for “\(localization)”.")

            assert(documentation.readMe.featureList[localization] ≠ nil, "No features specified for “\(localization)”.")
            if requireExamples {
                assert(documentation.readMe.exampleUsage[localization] ≠ nil, "No examples specified for “\(localization)”.")
            }

            assert(documentation.readMe.about ≠ nil, "About not localized for “\(localization)”.")
        }
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case provideWorkflowScripts
        case supportedOperatingSystems
        case git
        case licence
        case fileHeaders
        case gitHub
        case xcode
        case proofreading
        case testing
        case documentation
        case continuousIntegration
        case repository
        case isSDG
    }

    // #workaround(jazzy --version 0.9.3, Allow automatic inheritance when documentation supports it.)
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(provideWorkflowScripts, forKey: .provideWorkflowScripts)
        try container.encode(supportedOperatingSystems, forKey: .supportedOperatingSystems)
        try container.encode(git, forKey: .git)
        try container.encode(licence, forKey: .licence)
        try container.encode(fileHeaders, forKey: .fileHeaders)
        try container.encode(gitHub, forKey: .gitHub)
        try container.encode(xcode, forKey: .xcode)
        try container.encode(proofreading, forKey: .proofreading)
        try container.encode(testing, forKey: .testing)
        try container.encode(documentation, forKey: .documentation)
        try container.encode(continuousIntegration, forKey: .continuousIntegration)
        try container.encode(repository, forKey: .repository)
        try container.encode(isSDG, forKey: .isSDG)
        try super.encode(to: container.superEncoder())
    }

    // #workaround(jazzy --version 0.9.3, Allow automatic inheritance when documentation supports it.)
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///     - decoder: The decoder to read data from.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provideWorkflowScripts = try container.decode(Bool.self, forKey: .provideWorkflowScripts)
        supportedOperatingSystems = try container.decode(Set<OperatingSystem>.self, forKey: .supportedOperatingSystems)
        git = try container.decode(GitConfiguration.self, forKey: .git)
        licence = try container.decode(LicenceConfiguration.self, forKey: .licence)
        fileHeaders = try container.decode(FileHeaderConfiguration.self, forKey: .fileHeaders)
        gitHub = try container.decode(GitHubConfiguration.self, forKey: .gitHub)
        xcode = try container.decode(XcodeConfiguration.self, forKey: .xcode)
        proofreading = try container.decode(ProofreadingConfiguration.self, forKey: .proofreading)
        testing = try container.decode(TestingConfiguration.self, forKey: .testing)
        documentation = try container.decode(DocumentationConfiguration.self, forKey: .documentation)
        continuousIntegration = try container.decode(ContinuousIntegrationConfiguration.self, forKey: .continuousIntegration)
        repository = try container.decode(RepositoryConfiguration.self, forKey: .repository)
        isSDG = try container.decode(Bool.self, forKey: .isSDG)
        try super.init(from: container.superDecoder())

        // Because “registered” must be non‐nil:
        WorkspaceConfiguration.registered = self
    }

    // MARK: - Configuration

    /// Creates a Workspace configuration according to the defaults.
    ///
    /// Defaults are generally non‐invasive. Most tasks which would write into project files are off by default.
    ///
    /// To opt in to all tasks use `optIntoAllTasks()`.
    public required init() {
        super.init()
        WorkspaceConfiguration.registered = self
    }
}
