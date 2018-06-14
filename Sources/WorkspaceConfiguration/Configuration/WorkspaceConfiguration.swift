/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftConfiguration

/// A Workspace configuration.
public final class WorkspaceConfiguration : Configuration {

    // MARK: - Static Properties

    internal static var registered: WorkspaceConfiguration!

    // MARK: - Properties

    /// Whether or not to provide workflow scripts.
    ///
    /// This is on by default.
    ///
    /// These scripts are provided to reduce refreshment and validation to a simple double‐click. They will also ensure that the same version of Workspace gets used for the project on every machine it is cloned to.
    public var provideWorkflowScripts: Bool = true

    /// The operating systems the project supports.
    ///
    /// The default assumes support for all operating systems.
    public var supportedOperatingSystems: Set<OperatingSystem> = Set(OperatingSystem.cases)

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
    public var sdg: Bool = false

    // MARK: - Methods

    /// Opts into all tasks which are off by default.
    ///
    /// - Warning: Many opt‐in tasks involve writing into project files.
    public func optIntoAllTasks() {
        licence.manage = true
        fileHeaders.manage = true
        gitHub.manage = true
        xcode.manage = true
        documentation.readMe.manage = true
        continuousIntegration.manage = true
        documentation.api.generate = true
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case provideWorkflowScripts
        case supportedOperatingSystems
        case licence
        case fileHeaders
        case gitHub
        case xcode
        case proofreading
        case testing
        case documentation
        case continuousIntegration
        case repository
        case sdg
    }

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(provideWorkflowScripts, forKey: .provideWorkflowScripts)
        try container.encode(supportedOperatingSystems, forKey: .supportedOperatingSystems)
        try container.encode(licence, forKey: .licence)
        try container.encode(fileHeaders, forKey: .fileHeaders)
        try container.encode(gitHub, forKey: .gitHub)
        try container.encode(xcode, forKey: .xcode)
        try container.encode(proofreading, forKey: .proofreading)
        try container.encode(testing, forKey: .testing)
        try container.encode(documentation, forKey: .documentation)
        try container.encode(continuousIntegration, forKey: .continuousIntegration)
        try container.encode(repository, forKey: .repository)
        try container.encode(sdg, forKey: .sdg)
        try super.encode(to: container.superEncoder())
    }

    // [_Inherit Documentation: SDGCornerstone.Decodable.init(from:)_]
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///     - decoder: The decoder to read data from.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provideWorkflowScripts = try container.decode(Bool.self, forKey: .provideWorkflowScripts)
        supportedOperatingSystems = try container.decode(Set<OperatingSystem>.self, forKey: .supportedOperatingSystems)
        gitHub = try container.decode(GitHubConfiguration.self, forKey: .gitHub)
        fileHeaders = try container.decode(FileHeaderConfiguration.self, forKey: .fileHeaders)
        xcode = try container.decode(XcodeConfiguration.self, forKey: .xcode)
        licence = try container.decode(LicenceConfiguration.self, forKey: .licence)
        proofreading = try container.decode(ProofreadingConfiguration.self, forKey: .proofreading)
        testing = try container.decode(TestingConfiguration.self, forKey: .testing)
        documentation = try container.decode(DocumentationConfiguration.self, forKey: .documentation)
        continuousIntegration = try container.decode(ContinuousIntegrationConfiguration.self, forKey: .continuousIntegration)
        repository = try container.decode(RepositoryConfiguration.self, forKey: .repository)
        sdg = try container.decode(Bool.self, forKey: .sdg)
        try super.init(from: container.superDecoder())
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
