/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import SDGSwiftConfiguration

import WSLocalizations

// #workaround(Not properly localized yet.)
// @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration)
/// ...
public typealias ArbeitsbereichKonfiguration = WorkspaceConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceConfiguration)
// @documentation(WorkspaceConfiguration)
// #example(1, sampleConfiguration)
/// The root API used in configuration files.
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
/// configuration.documentation.api.generate = true
/// configuration.documentation.api.yearFirstPublished = 2017
/// ```
public final class WorkspaceConfiguration : Configuration {

    // MARK: - Static Properties

    internal static var registered: WorkspaceConfiguration!

    // MARK: - Properties

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.provideWorkflowScripts)
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
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.provideWorkflowScripts)
    /// Ob Arbeitsbereich Arbeitsablaufskripte bereitstellen soll.
    ///
    /// Wenn nicht angegeben, ist diese Einstellung ein.
    ///
    /// ```shell
    /// $ arbeitsbereich prüfen skripte
    /// ```
    ///
    /// Diese Skripte sind bereitgestellt, um das Auffrischen und Prüfen zu einem Doppelklick zu vereinfachen. Sie versichern auch, dass die gleiche Version von Arbeitsbereich auf alle Geräte verwendet wird, wo das Projekt nachgebildet wird.
    public var arbeitsablaufsskripteBereitstellen: Bool {
        get { return provideWorkflowScripts }
        set { provideWorkflowScripts = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.supportedPlatforms)
    /// The platforms the project supports.
    ///
    /// The default assumes support for all platforms.
    public var supportedPlatforms: Set<Platform> = Set(Platform.allCases)
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.supportedPlatforms)
    /// Die Schichte, die das Projekt unterstützt.
    ///
    /// Wenn nicht angegeben, werden alle Schichte unterstützt.
    public var unterstützteSchichte: Menge<Schicht> {
        get { return supportedPlatforms }
        set { supportedPlatforms = newValue }
    }

    // @localization(🇩🇪DE)
    /// Einstellungen zu Git.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// Options related to Git.
    public var git: GitConfiguration = GitConfiguration()

    /// Options related to licencing.
    // @localization(🇨🇦EN) @crossReference(WorkspaceConfiguration.licence)
    /// Options related to licensing.
    public var licence: LicenceConfiguration = LicenceConfiguration()
    // @localization(🇺🇸EN) @crossReference(WorkspaceConfiguration.licence)
    /// Options related to licensing.
    public var license: LicenseConfiguration {
        get { return licence }
        set { licence = newValue }
    }
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.licence)
    /// Einstellungen zur Lizenz.
    public var lizenz: Lizenzeinstellungen {
        get { return licence }
        set { licence = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.fileHeaders)
    /// Options related to file headers.
    public var fileHeaders: FileHeaderConfiguration = FileHeaderConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.fileHeaders)
    /// Einstellungen zu den Dateivorspännen.
    public var dateiVorspänne: Dateivorspannseinstellungen {
        get { return fileHeaders }
        set { fileHeaders = newValue }
    }

    // @localization(🇩🇪DE)
    /// Einstellungen zu GitHub.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// Options related to GitHub.
    public var gitHub: GitHubConfiguration = GitHubConfiguration()

    // @localization(🇩🇪DE)
    /// Einstellungen zu Xcode.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// Options related to Xcode.
    public var xcode: XcodeConfiguration = XcodeConfiguration()

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.proofreading)
    /// Options related to proofreading.
    public var proofreading: ProofreadingConfiguration = ProofreadingConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.proofreading)
    /// Einstellungen zur Korrektur.
    public var korrektur: Korrektureinstellungen {
        get { return proofreading }
        set { proofreading = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceConfiguration.testing)
    /// Options related to building and testing.
    public var testing: TestingConfiguration = TestingConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.testing)
    /// Einstellungen zum Testen.
    public var testen: Testeinstellungen {
        get { return testing }
        set { testing = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.documentation)
    /// Options related to documentation.
    public var documentation: DocumentationConfiguration = DocumentationConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.documentation)
    /// Einstellungen zur Dokumentation.
    public var dokumentation: Dokumentationseinstellungen {
        get { return documentation }
        set { documentation = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.continuousIntegration)
    /// Options related to continuous integration.
    public var continuousIntegration: ContinuousIntegrationConfiguration = ContinuousIntegrationConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.continuousIntegration)
    /// Einstellungen zur fortlaufenden Einbindung.
    public var fortlaufenderEinbindung: EinstellungenFortlaufenderEinbindung {
        get { return continuousIntegration }
        set { continuousIntegration = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.repository)
    /// Options related to the project repository.
    public var repository: RepositoryConfiguration = RepositoryConfiguration()
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.repository)
    /// Einstellungen zur Dokumentation.
    public var lager: Lagerseinstellungen {
        get { return repository }
        set { repository = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.customRefreshmentTasks)
    /// Custom tasks to perform when refreshing the project.
    public var customRefreshmentTasks: [CustomTask] = []
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.customRefreshmentTasks)
    /// Sonderaufgaben, diem Auffrischen ausgeführt werden sollen.
    public var auffrischungssonderaufgaben: [Sonderaufgabe] {
        get { return customRefreshmentTasks }
        set { customRefreshmentTasks = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.customProofreadingTasks)
    /// Custom tasks to perform when proofreading.
    public var customProofreadingTasks: [CustomTask] = []
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.customProofreadingTasks)
    /// Sonderaufgaben, die bei der Korrektur ausgeführt werden sollen.
    public var korrektursonderaufgaben: [Sonderaufgabe] {
        get { return customProofreadingTasks }
        set { customProofreadingTasks = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(WorkspaceConfiguration.customValidationTasks)
    /// Custom tasks to perform when validating the project.
    public var customValidationTasks: [CustomTask] = []
    // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.customValidationTasks)
    /// Sonderaufgaben, die beim Prüfen ausgeführt werden sollen.
    public var prüfungssonderaufgaben: [Sonderaufgabe] {
        get { return customValidationTasks }
        set { customValidationTasks = newValue }
    }

    internal var _isSDG: Bool = false

    // MARK: - Opting In & Out

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
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

    public func _applySDGDefaults(openSource: Bool = true) {

        _isSDG = true
        optIntoAllTasks()
        if ¬openSource {
            documentation.api.generate = false
            documentation.api.enforceCoverage = false
            documentation.readMe.manage = false
            licence.manage = false
            gitHub.manage = false
            continuousIntegration.manage = false
        }

        documentation.primaryAuthor = "Jeremy David Giesbrecht"
        gitHub.administrators = ["SDGGiesbrecht"]

        if openSource {
            licence.licence = .apache2_0
        }

        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGSwift")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGInterface")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCommandLine")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGWeb")!))
        documentation.relatedProjects.append(.project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCornerstone")!))
    }

    public func _applySDGOverrides() {
        let project = WorkspaceContext.current.manifest.packageName
        let about = [
            "The \(project) project is maintained by Jeremy David Giesbrecht.",
            "",
            "If \(project) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
            "",
            "If \(project) saves you time, consider devoting some of it to [contributing](\(documentation.repositoryURL?.absoluteString ?? "")) back to the project.", // @exempt(from: tests)
            "",
            "> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)",
            ">",
            "> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)",
            ">",
            "> ―‎ישוע/Yeshuʼa"
            ].joinedAsLines()
        for localization in ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN"] as [LocalizationIdentifier] {
            documentation.about[localization] = Markdown(about)
        }
    }

    public func _validateSDGStandards(openSource: Bool = true) {
        let needsAPIDocumentation = WorkspaceContext.current.manifest.products.contains(where: { $0.type == .library })

        assert(documentation.currentVersion ≠ nil, "No version specified.")
        assert(¬documentation.localizations.isEmpty, "No localizations specified.")

        if openSource {
            assert(documentation.projectWebsite ≠ nil, "No project website specified.")
            if needsAPIDocumentation {
                assert(documentation.documentationURL ≠ nil, "No documentation URL specified.")
            }
            assert(documentation.repositoryURL ≠ nil, "No repository URL specified.")

            if needsAPIDocumentation {
                assert(documentation.api.encryptedTravisCIDeploymentKey ≠ nil, "No Travis CI deployment key specified.")
            }

            for localization in documentation.localizations {
                assert(documentation.about ≠ nil, "About not localized for “\(localization)”.")
            }
        }
    }

    // MARK: - Localization

    private func resolvedLocalizations<T>(_ localize: (ContentLocalization) -> T) -> [(localization: LocalizationIdentifier, value: T)] {
        let localizations = documentation.localizations
        var result: [(localization: LocalizationIdentifier, value: T)] = []
        for localization in localizations {
            if let provided = localization._reasonableMatch {
                result.append((localization: localization, value: localize(provided)))
            }
        }
        return result
    }

    internal func localizationDictionary<T>(_ localize: (ContentLocalization) -> T) -> [LocalizationIdentifier: T] {
        var dictionary: [LocalizationIdentifier: T] = [:]
        for pair in resolvedLocalizations(localize) {
            dictionary[pair.localization] = pair.value
        }
        return dictionary
    }

    internal func sequentialLocalizations<T>(_ unordered: [LocalizationIdentifier: T]) -> [T] where T : Equatable {
        var result: [T] = []
        for localization in documentation.localizations {
            if let value = unordered[localization],
                ¬result.contains(value) {
                result.append(value)
            }
        }
        return result
    }
    internal func sequentialLocalizations<T>(_ localize: (ContentLocalization) -> T) -> [T] where T : Equatable {
        var array: [T] = []
        for pair in resolvedLocalizations(localize) {
            let value = pair.value
            if ¬array.contains(value) {
                array.append(value)
            }
        }
        return array
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case provideWorkflowScripts
        case supportedPlatforms
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
        case customRefreshmentTasks
        case customProofreadingTasks
        case customValidationTasks
        case isSDG
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(provideWorkflowScripts, forKey: .provideWorkflowScripts)
        try container.encode(supportedPlatforms, forKey: .supportedPlatforms)
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
        try container.encode(customRefreshmentTasks, forKey: .customRefreshmentTasks)
        try container.encode(customProofreadingTasks, forKey: .customProofreadingTasks)
        try container.encode(customValidationTasks, forKey: .customValidationTasks)
        try container.encode(_isSDG, forKey: .isSDG)
        try super.encode(to: container.superEncoder())
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provideWorkflowScripts = try container.decode(Bool.self, forKey: .provideWorkflowScripts)
        supportedPlatforms = try container.decode(Set<Platform>.self, forKey: .supportedPlatforms)
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
        customRefreshmentTasks = try container.decode([CustomTask].self, forKey: .customRefreshmentTasks)
        customProofreadingTasks = try container.decode([CustomTask].self, forKey: .customProofreadingTasks)
        customValidationTasks = try container.decode([CustomTask].self, forKey: .customValidationTasks)
        _isSDG = try container.decode(Bool.self, forKey: .isSDG)
        try super.init(from: container.superDecoder())

        // Because “registered” must be non‐nil:
        WorkspaceConfiguration.registered = self
    }

    // MARK: - Configuration

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
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
