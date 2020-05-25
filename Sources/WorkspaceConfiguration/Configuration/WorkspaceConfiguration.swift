/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import SDGSwiftConfiguration

import WSLocalizations

// @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration)
// @documentation(ArbeitsbereichKonfiguration)
// #example(1, beispielskonfiguration)
/// Die Wurzel der Programmierschnittstelle für Konfigurationsdateien.
///
/// Arbeitsbereich kann durch eine Swift‐Datei Namens `Arbeitsbereich.swift` im Projektwurzel konfiguriert werden.
///
/// Der Inhalt einer Konfigurationsdatei könnte etwa so aussehen:
///
/// ```swift
/// import WorkspaceConfiguration
///
/// /*
///  Externe Pakete sind mit dieser Syntax einführbar:
///  import [Modul] // [Ressourcenzeiger], [Version], [Produkt]
///  */
/// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
///
/// let konfiguration = ArbeitsbereichKonfiguration()
/// konfiguration.alleAufgabenEinschalten()
///
/// konfiguration.unterstützteSchichte = [.macOS, .windows, .linux, .android]
///
/// konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
/// konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
/// konfiguration.dokumentation
///   .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
/// konfiguration.dokumentation
///   .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")
///
/// konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017
///
/// konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
/// konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(
///     auswerten: { konfiguration in
///       return [
///         "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
///         "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
///       ]
///     }
///   )
///
/// konfiguration.dokumentation.hauptautor = "Max Mustermann"
/// ```
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
/// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
///
/// let configuration = WorkspaceConfiguration()
/// configuration.optIntoAllTasks()
///
/// configuration.supportedPlatforms = [.macOS, .windows, .linux, .android]
///
/// configuration.documentation.currentVersion = Version(1, 0, 0)
/// configuration.documentation.projectWebsite = URL(string: "project.uk")
/// configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
/// configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")
///
/// configuration.documentation.api.yearFirstPublished = 2017
///
/// configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
/// configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
///   resolve: { configuration in
///     return [
///       "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
///       "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
///       "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
///       "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
///     ]
///   })
///
/// configuration.documentation.primaryAuthor = "John Doe"
/// ```
public final class WorkspaceConfiguration: Configuration {

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

  // @localization(🇬🇧EN)
  /// The localised forms of the project name, if they differ from the package name.
  // @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceConfiguration.projectName)
  /// The localized forms of the project name, if they differ from the package name.
  public var projectName: [LocalizationIdentifier: StrictString] = [:]
  // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.projectName)
  /// Die lokalisierte Formen des Projektnamens, wo sie sich von dem Paketenname unterscheiden.
  public var projektname: [LocalizationIdentifier: StrictString] {
    get { return projectName }
    set { projectName = newValue }
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
  // @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(WorkspaceConfiguration.licence)
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

  // @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(WorkspaceConfiguration.normalize)
  /// Whether or not to normalize project files.
  ///
  /// This is off by default.
  ///
  /// ```swift
  /// $ workspace normalize
  /// ```
  public var normalize: Bool = false
  // @localization(🇬🇧EN)
  // @crossReference(WorkspaceConfiguration.normalize)
  /// Whether or not to normalise project files.
  ///
  /// This is off by default.
  ///
  /// ```swift
  /// $ workspace normalise
  /// ```
  public var normalise: Bool {
    get { return normalize }
    set { normalize = newValue }
  }
  // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.normalize)
  /// Ob Arbeitsbereich die Projektdateien normalisieren soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  ///
  /// ```shell
  /// $ arbeitsbereich normalisieren
  /// ```
  public var normalisieren: Bool {
    get { return normalize }
    set { normalize = newValue }
  }

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
  public var continuousIntegration: ContinuousIntegrationConfiguration =
    ContinuousIntegrationConfiguration()
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

  // @localization(🇩🇪DE) @crossReference(WorkspaceConfiguration.optIntoAllTasks())
  /// Schaltet alle Aungaben ein, die nicht automatisch eingeschaltet sind.
  ///
  /// - Warning: Viele solche Aufgaben schreiben zu Projekt‐Dateien.
  public func alleAufgabenEinschalten() {
    optIntoAllTasks()
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(WorkspaceConfiguration.optIntoAllTasks())
  /// Opts into all tasks which are off by default.
  ///
  /// - Warning: Many opt‐in tasks involve writing into project files.
  public func optIntoAllTasks() {
    git.manage = true
    licence.manage = true
    fileHeaders.manage = true
    gitHub.manage = true
    xcode.manage = true
    normalize = true
    documentation.readMe.manage = true
    continuousIntegration.manage = true
    documentation.api.generate = true
  }

  public func _applySDGDefaults(openSource: Bool = true) {

    _isSDG = true
    optIntoAllTasks()
    if openSource {
      documentation.api.serveFromGitHubPagesBranch = true
    } else {
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

    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    #if !os(WASI)
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGKeyboardDesign")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGSwift")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGInterface")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCommandLine")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGWeb")!)
      )
      documentation.relatedProjects.append(
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/SDGCornerstone")!)
      )
    #endif
  }

  public func _applySDGOverrides() {
    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    #if !os(WASI)
      let project = WorkspaceContext.current.manifest.packageName
      let repositoryURL =
        documentation.repositoryURL?.absoluteString
        ?? ""  // @exempt(from: tests)
      let about = [
        "The \(project) project is maintained by Jeremy David Giesbrecht.",
        "",
        "If \(project) saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).",
        "",
        "If \(project) saves you time, consider devoting some of it to [contributing](\(repositoryURL)) back to the project.",
        "",
        "> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)",
        ">",
        "> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)",
        ">",
        "> ―‎ישוע/Yeshuʼa",
      ].joinedAsLines()
      for localization in ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN"] as [LocalizationIdentifier] {
        documentation.about[localization] = Markdown(about)
      }
    #endif
  }

  public func _validateSDGStandards(openSource: Bool = true) {
    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    #if !os(WASI)
      let needsAPIDocumentation = ¬WorkspaceContext.current.manifest.products.isEmpty
    #endif

    assert(documentation.currentVersion ≠ nil, "No version specified.")
    assert(¬documentation.localizations.isEmpty, "No localizations specified.")

    if openSource {
      // #workaround(Swift 5.2.4, Web lacks Foundation.)
      #if !os(WASI)
        assert(documentation.projectWebsite ≠ nil, "No project website specified.")
        if needsAPIDocumentation {
          assert(documentation.documentationURL ≠ nil, "No documentation URL specified.")
        }
        assert(documentation.repositoryURL ≠ nil, "No repository URL specified.")
      #endif

      for localization in documentation.localizations {
        assert(documentation.about ≠ nil, "About not localized for “\(localization)”.")
      }
    }
  }

  // MARK: - Localization

  private func resolvedLocalizations<T>(_ localize: (ContentLocalization) -> T) -> [(
    localization: LocalizationIdentifier, value: T
  )] {
    let localizations = documentation.localizations
    var result: [(localization: LocalizationIdentifier, value: T)] = []
    for localization in localizations {
      if let provided = localization._reasonableMatch {
        result.append((localization: localization, value: localize(provided)))
      }
    }
    return result
  }

  internal func localizationDictionary<T>(_ localize: (ContentLocalization) -> T)
    -> [LocalizationIdentifier: T]
  {
    var dictionary: [LocalizationIdentifier: T] = [:]
    for pair in resolvedLocalizations(localize) {
      dictionary[pair.localization] = pair.value
    }
    return dictionary
  }

  internal func sequentialLocalizations<T>(_ unordered: [LocalizationIdentifier: T]) -> [T]
  where T: Equatable {
    var result: [T] = []
    for localization in documentation.localizations {
      if let value = unordered[localization],
        ¬result.contains(value)
      {
        result.append(value)
      }
    }
    return result
  }
  internal func sequentialLocalizations<T>(_ localize: (ContentLocalization) -> T) -> [T]
  where T: Equatable {
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

  private enum CodingKeys: CodingKey {
    case provideWorkflowScripts
    case projectName
    case supportedPlatforms
    case git
    case licence
    case fileHeaders
    case gitHub
    case xcode
    case normalize
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
    try container.encode(projectName, forKey: .projectName)
    try container.encode(supportedPlatforms, forKey: .supportedPlatforms)
    try container.encode(git, forKey: .git)
    try container.encode(licence, forKey: .licence)
    try container.encode(fileHeaders, forKey: .fileHeaders)
    try container.encode(gitHub, forKey: .gitHub)
    try container.encode(xcode, forKey: .xcode)
    try container.encode(normalize, forKey: .normalize)
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
    projectName = try container.decode(
      [LocalizationIdentifier: StrictString].self,
      forKey: .projectName
    )
    supportedPlatforms = try container.decode(Set<Platform>.self, forKey: .supportedPlatforms)
    git = try container.decode(GitConfiguration.self, forKey: .git)
    licence = try container.decode(LicenceConfiguration.self, forKey: .licence)
    fileHeaders = try container.decode(FileHeaderConfiguration.self, forKey: .fileHeaders)
    gitHub = try container.decode(GitHubConfiguration.self, forKey: .gitHub)
    xcode = try container.decode(XcodeConfiguration.self, forKey: .xcode)
    normalize = try container.decode(Bool.self, forKey: .normalize)
    proofreading = try container.decode(ProofreadingConfiguration.self, forKey: .proofreading)
    testing = try container.decode(TestingConfiguration.self, forKey: .testing)
    documentation = try container.decode(
      DocumentationConfiguration.self,
      forKey: .documentation
    )
    continuousIntegration = try container.decode(
      ContinuousIntegrationConfiguration.self,
      forKey: .continuousIntegration
    )
    repository = try container.decode(RepositoryConfiguration.self, forKey: .repository)
    customRefreshmentTasks = try container.decode(
      [CustomTask].self,
      forKey: .customRefreshmentTasks
    )
    customProofreadingTasks = try container.decode(
      [CustomTask].self,
      forKey: .customProofreadingTasks
    )
    customValidationTasks = try container.decode(
      [CustomTask].self,
      forKey: .customValidationTasks
    )
    _isSDG = try container.decode(Bool.self, forKey: .isSDG)
    try super.init(from: container.superDecoder())

    // Because “registered” must be non‐nil:
    WorkspaceConfiguration.registered = self
  }

  // MARK: - Configuration

  // @localization(🇩🇪DE)
  /// Erstellt eine Arbeitsberich‐Konfiguration mit den Anfangseinstellungen.
  ///
  /// Anfangseinstellungen sind allgemein nicht invasiv. Die meisten Aufgaben, die zu Projekt‐Dateien schreiben sind nicht automatisch eingeschaltet.
  ///
  /// Um alle Aufgaben einzuschalten, gibt es `alleAufgabenEinschalten()`.
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
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

// Just to help the documenter resolve the difference between SDGSwiftConfiguration.Configuration and SwiftFormatConfiguration.Configuration.
// @notLocalized(🇬🇧EN) @notLocalized(🇺🇸EN) @notLocalized(🇨🇦EN) @notLocalized(🇩🇪DE)
/// An alias for `SDGSwiftConfiguration.Configuration`.
public typealias Configuration = SDGSwiftConfiguration.Configuration
