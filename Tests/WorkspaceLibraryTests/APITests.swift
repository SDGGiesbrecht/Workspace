/*
 APITests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralTestImports

import SDGExternalProcess

import WorkspaceConfiguration
import WSProject

class APITests: TestCase {

  static let configureGit: Void = {
    if ProcessInfo.isInGitHubAction {
      #if os(Linux)
        _ = try? Git.runCustomSubcommand(
          [
            "config", "\u{2D}\u{2D}global", "user.email", "john.doe@example.com"
          ],
          versionConstraints: Version(0, 0, 0)..<Version(100, 0, 0)
        ).get()
        _ = try? Git.runCustomSubcommand(
          ["config", "\u{2D}\u{2D}global", "user.name", "John Doe"],
          versionConstraints: Version(0, 0, 0)..<Version(100, 0, 0)
        )
        .get()
      #endif
    }
  }()
  override func setUp() {
    super.setUp()
    Command.Output.testMode = true
    PackageRepository.emptyRelatedProjectCache()  // Make sure starting state is consistent.
    CustomTask.emptyCache()
    APITests.configureGit
  }

  func testAllDisabled() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.provideWorkflowScripts = false
      configuration.proofreading.rules = []
      configuration.proofreading.swiftFormatConfiguration = nil
      configuration.testing.prohibitCompilerWarnings = false
      configuration.testing.enforceCoverage = false
      configuration.documentation.api.enforceCoverage = false
      PackageRepository(mock: "AllDisabled").test(
        commands: [
          ["refresh"],
          ["validate"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testAllTasks() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.optIntoAllTasks()
      configuration.documentation.localizations = ["🇮🇱עב"]
      configuration.licence.licence = .copyright
      configuration.documentation.api.yearFirstPublished = 2018
      let builtIn = configuration.fileHeaders.copyrightNotice
      configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
        resolve: { configuration in
          var result = builtIn.resolve(configuration)
          result["🇮🇱עב"] = "#dates"
          return result
        })
      PackageRepository(mock: "AllTasks").test(
        commands: [
          ["refresh"],
          ["validate"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testArray() {
    XCTAssertEqual(["a", "b"].verbundenAlsZeile(), "a\nb")
  }

  func testBadStyle() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.normalize = true
      configuration.proofreading.swiftFormatConfiguration?.rules["AlwaysUseLowerCamelCase"] = true
      let failing = CustomTask(
        url: URL(string: "file:///tmp/Developer/Dependency")!,
        version: Version(1, 0, 0),
        executable: "Dependency",
        arguments: ["fail"]
      )
      configuration.customProofreadingTasks.append(failing)
      PackageRepository(mock: "BadStyle").test(
        commands: [
          ["proofread"],
          ["proofread", "•xcode"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        withCustomTask: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testBrokenExample() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "BrokenExample").test(
        commands: [
          ["refresh", "examples"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testBrokenTests() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "BrokenTests").test(
        commands: [
          ["test"]
        ],
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCheckedInDocumentation() throws {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      var output = try mockCommand.withRootBehaviour().execute(with: [
        "export‐interface", "•language", "en"
      ]).get()
      // macOS & Linux have different JSON whitespace.
      output.scalars.replaceMatches(
        for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
        with: "\n\n".scalars
      )
      try output.save(
        to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
          .appendingPathComponent("Resources/Tool/English.txt")
      )
      output = try mockCommand.withRootBehaviour().execute(with: [
        "export‐interface", "•language", "de"
      ]).get()
      // macOS & Linux have different JSON whitespace.
      output.scalars.replaceMatches(
        for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
        with: "\n\n".scalars
      )
      try output.save(
        to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
          .appendingPathComponent("Resources/Tool/Deutsch.txt")
      )

      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.normalize = true
      configuration.documentation.repositoryURL = URL(string: "http://example.com")!
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.api.enforceCoverage = false
      configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE", "zxx"]
      configuration.documentation.api.generate = true
      configuration.documentation.about["🇨🇦EN"] =
        "Stuff about the creators...\n\n...and more stuff..."
      configuration.documentation.about["🇺🇸EN"] = ""
      configuration.documentation.api.yearFirstPublished = 2018
      configuration.documentation.api.ignoredDependencies.remove("Swift")
      configuration.documentation.api.applyWindowsCompatibilityFileNameReplacements()
      configuration.proofreading.swiftFormatConfiguration?.rules["UseShorthandTypeNames"] = false
      configuration.proofreading.swiftFormatConfiguration?.rules["UseEnumForNamespacing"] = false
      configuration.documentation.relatedProjects = [
        .heading(text: [
          "🇬🇧EN": "Heading",
          "🇺🇸EN": "Heading",
          "🇨🇦EN": "Heading",
          "🇩🇪DE": "Überschrift",
          "zxx": "..."
        ]),
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
      ]
      let builtIn = configuration.fileHeaders.copyrightNotice
      configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
        resolve: { configuration in
          var result = builtIn.resolve(configuration)
          result["zxx"] = "#dates"
          return result
        })
      configuration.provideWorkflowScripts = false
      PackageRepository(mock: "CheckedInDocumentation").test(
        commands: [
          ["refresh"],
          ["validate", "•job", "miscellaneous"],
          ["validate", "•job", "deployment"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCheckForUpdates() throws {
    #if !os(Windows)  // #workaround(SDGSwift 1.0.0, Git cannot find itself.)
      // #workaround(Swift 5.2.4, Emulator lacks Git, but processes don’t work anyway.)
      #if !os(Android)
        _ = try Workspace.command.execute(with: ["check‐for‐updates"]).get()
      #endif
    #endif
  }

  func testConfiguration() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration._applySDGDefaults(openSource: false)
      XCTAssertFalse(configuration.documentation.readMe.manage)

      configuration.fortlaufenderEinbindung.verwalten = false
      XCTAssertFalse(configuration.fortlaufenderEinbindung.verwalten)
      configuration.fortlaufenderEinbindung.auserhalbFortlaufenderEinbindungSimulatorÜberspringen =
        true
      XCTAssert(
        configuration.fortlaufenderEinbindung
          .auserhalbFortlaufenderEinbindungSimulatorÜberspringen
      )
      configuration.customRefreshmentTasks.append(
        Sonderaufgabe(
          ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "domain.tld")!,
          version: Version(1, 0),
          ausführbareDatei: "werkzeug",
          argumente: ["argument"]
        )
      )
      XCTAssertEqual(configuration.customRefreshmentTasks.last?.version.major, 1)
      configuration.dokumentation.programmierschnittstelle.erstellen = false
      XCTAssertFalse(configuration.dokumentation.programmierschnittstelle.erstellen)
      configuration.dokumentation.programmierschnittstelle.abdeckungErzwingen = false
      XCTAssertFalse(configuration.dokumentation.programmierschnittstelle.abdeckungErzwingen)
      configuration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 1
      XCTAssertEqual(
        configuration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung,
        1
      )
      configuration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
        BequemeEinstellung(auswerten: { _ in [:] })
      XCTAssertEqual(
        configuration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk
          .auswerten(configuration),
        [:]
      )
      configuration.dokumentation.programmierschnittstelle
        .durchGitHubSeitenVeröffentlichen = true
      XCTAssertEqual(
        configuration.dokumentation.programmierschnittstelle
          .durchGitHubSeitenVeröffentlichen,
        true
      )
      configuration.dokumentation.programmierschnittstelle.übergegangeneAbhängigkeiten.insert(
        "..."
      )
      XCTAssert(
        configuration.dokumentation.programmierschnittstelle.übergegangeneAbhängigkeiten
          .contains("...")
      )
      configuration.dokumentation.localisations = ["und"]
      XCTAssertEqual(configuration.dokumentation.localisations, ["und"])
      configuration.dokumentation.lokalisationen = ["zxx"]
      XCTAssertEqual(configuration.dokumentation.lokalisationen, ["zxx"])
      configuration.dokumentation.aktuelleVersion = Version(1, 0)
      XCTAssertEqual(configuration.dokumentation.aktuelleVersion, Version(1, 0))
      configuration.dokumentation.projektSeite = EinheitlicherRessourcenzeiger(string: "seite.de")
      XCTAssertEqual(
        configuration.dokumentation.projektSeite,
        EinheitlicherRessourcenzeiger(string: "seite.de")
      )
      configuration.dokumentation.dokumentationsRessourcenzeiger = EinheitlicherRessourcenzeiger(
        string: "dokumentation.de"
      )
      XCTAssertEqual(
        configuration.dokumentation.dokumentationsRessourcenzeiger,
        EinheitlicherRessourcenzeiger(string: "dokumentation.de")
      )
      configuration.dokumentation.lagerRessourcenzeiger = EinheitlicherRessourcenzeiger(
        string: "lager.de"
      )
      XCTAssertEqual(
        configuration.dokumentation.lagerRessourcenzeiger,
        EinheitlicherRessourcenzeiger(string: "lager.de")
      )
      configuration.dokumentation.hauptautor = "Autor"
      XCTAssertEqual(configuration.dokumentation.hauptautor, "Autor")
      configuration.dokumentation.installationsanleitungen = BequemeEinstellung(auswerten: { _ in
        [:]
      })
      XCTAssertEqual(
        configuration.dokumentation.installationsanleitungen.auswerten(configuration),
        [:]
      )
      configuration.dokumentation.einführungsanleitungen = BequemeEinstellung(auswerten: { _ in [:]
      })
      XCTAssertEqual(
        configuration.dokumentation.einführungsanleitungen.auswerten(configuration),
        [:]
      )
      configuration.dokumentation.über = ["zxx": "..."]
      XCTAssertEqual(configuration.dokumentation.über, ["zxx": "..."])
      configuration.dokumentation.verwandteProjekte = []
      XCTAssert(configuration.dokumentation.verwandteProjekte.isEmpty)
      configuration.dokumentation.liesMich.verwalten = false
      XCTAssertFalse(configuration.dokumentation.liesMich.verwalten)
      configuration.dokumentation.liesMich.inhalt = BequemeEinstellung(auswerten: { _ in [:] })
      XCTAssertEqual(configuration.dokumentation.liesMich.inhalt.auswerten(configuration), [:])
      _ = LiesMichEinstellungen.programmierschnittstellenverweis(für: configuration, auf: "zxx")
      configuration.license.manage = false
      XCTAssertFalse(configuration.license.manage)
      configuration.lizenz.manage = true
      XCTAssert(configuration.lizenz.manage)
      configuration.arbeitsablaufsskripteBereitstellen = false
      XCTAssertFalse(configuration.arbeitsablaufsskripteBereitstellen)
      configuration.lager.ignoredPaths.insert("...")
      configuration.xcode.verwalten = false
      XCTAssertFalse(configuration.xcode.verwalten)
      configuration.license.license = nil
      XCTAssertNil(configuration.license.license)
      configuration.lizenz.lizenz = .mit
      XCTAssertEqual(configuration.lizenz.lizenz, .mit)
      XCTAssert(wahr)
      XCTAssertFalse(falsch)
      configuration.dateiVorspänne.verwalten = true
      XCTAssert(configuration.dateiVorspänne.verwalten)
      configuration.dateiVorspänne.urheberrechtshinweis = BequemeEinstellung(auswerten: { _ in [:] }
      )
      XCTAssertNil(
        configuration.dateiVorspänne.urheberrechtshinweis.auswerten(configuration)["de"]
      )
      configuration.dateiVorspänne.inhalt = BequemeEinstellung(auswerten: { _ in "" })
      XCTAssertEqual(configuration.dateiVorspänne.inhalt.auswerten(configuration), "")
      configuration.git.verwalten = true
      XCTAssert(configuration.git.verwalten)
      configuration.git.weitereEinträgeZuGitÜbergehen = []
      XCTAssertEqual(configuration.git.weitereEinträgeZuGitÜbergehen, [])
      configuration.gitHub.verwalten = true
      XCTAssert(configuration.gitHub.verwalten)
      configuration.gitHub.verwalter = []
      XCTAssertEqual(configuration.gitHub.verwalter, [])
      configuration.gitHub.entwicklungshinweise = ""
      XCTAssertEqual(configuration.gitHub.entwicklungshinweise, "")
      configuration.gitHub.themavorlagen = BequemeEinstellung(auswerten: { _ in [:] })
      XCTAssert(configuration.gitHub.themavorlagen.auswerten(configuration).isEmpty)
      configuration.gitHub.abziehungsanforderungsvorlage = ""
      XCTAssertEqual(configuration.gitHub.abziehungsanforderungsvorlage, "")
      configuration.lizenz.verwalten = true
      XCTAssert(configuration.lizenz.verwalten)
      configuration.korrektur.regeln = []
      XCTAssertEqual(configuration.korrektur.regeln, [])
      configuration.korrektur.geltungsbereichUnicodeRegel = []
      XCTAssertEqual(configuration.korrektur.geltungsbereichUnicodeRegel, [])
      configuration.lager.übergegangeneDateiarten = []
      XCTAssertEqual(configuration.lager.übergegangeneDateiarten, [])
      configuration.lager.übergegangenePfade = []
      XCTAssertEqual(configuration.lager.übergegangenePfade, [])
      configuration.testen.übersetzerwarnungenVerbieten = false
      XCTAssertFalse(configuration.testen.übersetzerwarnungenVerbieten)
      configuration.testen.abdeckungErzwingen = false
      XCTAssertFalse(configuration.testen.abdeckungErzwingen)
      configuration.testen.ausnahmensZeichen = []
      XCTAssertEqual(configuration.testen.ausnahmensZeichen, [])
      configuration.testen.ausnahmspfade = []
      XCTAssertEqual(configuration.testen.ausnahmspfade, [])
      configuration.unterstützteSchichte = []
      XCTAssertEqual(configuration.unterstützteSchichte, [])
      configuration.prüfungssonderaufgaben = []
      XCTAssert(configuration.prüfungssonderaufgaben.isEmpty)
      configuration.korrektursonderaufgaben = []
      XCTAssert(configuration.korrektursonderaufgaben.isEmpty)
      configuration.auffrischungssonderaufgaben = []
      XCTAssert(configuration.auffrischungssonderaufgaben.isEmpty)
      configuration.alleAufgabenEinschalten()
      configuration.gitHub.mitwirkungsanweisungen = BequemeEinstellung(auswerten: { _ in [:] })
      XCTAssert(configuration.gitHub.mitwirkungsanweisungen.auswerten(configuration).isEmpty)
      configuration.projektname["de"] = "Lokalisiert"
      XCTAssertEqual(configuration.projektname["de"], "Lokalisiert")
      configuration.korrektur.swiftFormatKonfiguration = nil
      XCTAssertNil(configuration.korrektur.swiftFormatKonfiguration)
      configuration.normalise = true
      XCTAssert(configuration.normalise)
      configuration.normalisieren = false
      XCTAssertFalse(configuration.normalisieren)
      configuration.dokumentation.programmierschnittstelle.dateinamensersetzungen = [:]
      XCTAssertEqual(
        configuration.dokumentation.programmierschnittstelle.dateinamensersetzungen,
        [:]
      )
      XCTAssertEqual(Schicht.netz, Platform.web)
    #endif
  }

  func testConfiguartionContext() {
    let context = WorkspaceContext(
      _location: URL(string: "site.tld")!,
      manifest: PackageManifest(
        _packageName: "Package",
        products: [
          PackageManifest.Product(_name: "Product", type: .library, modules: ["Module"])
        ]
      )
    )
    XCTAssertEqual(context.standort, URL(string: "site.tld")!)
    XCTAssertEqual(context.ladeliste.paketenName, "Package")
    XCTAssertEqual(context.ladeliste.produktmodule.first, "Module")
    XCTAssertEqual(context.ladeliste.produkte.first?.art, .bibliotek)
    XCTAssertNotEqual(context.ladeliste.produkte.first?.art, .ausführbareDatei)
    XCTAssertEqual(context.ladeliste.produkte.first?.module.first, "Module")
    WorkspaceContext.aktueller = context
    _ = WorkspaceContext.aktueller
  }

  func testContinuousIntegrationWithoutScripts() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.provideWorkflowScripts = false
      configuration.normalize = true
      configuration.continuousIntegration.manage = true
      configuration.licence.manage = true
      configuration.licence.licence = .mit
      configuration.fileHeaders.manage = true

      // Text rules but no syntax rules.
      configuration.proofreading.rules = [.manualWarnings]

      PackageRepository(mock: "ContinuousIntegrationWithoutScripts").test(
        commands: [
          ["refresh", "continuous‐integration"],
          ["refresh", "licence"],
          ["refresh", "file‐headers"],
          ["proofread"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCustomProofread() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.normalize = true
      configuration.proofreading.rules.remove(.calloutCasing)
      configuration.proofreading.unicodeRuleScope.remove(.ambiguous)
      for rule in ProofreadingRule.allCases {
        _ = rule.category
      }
      configuration.licence.manage = true
      configuration.licence.licence = .gnuGeneralPublic3_0
      configuration.fileHeaders.manage = true
      let passing = CustomTask(
        url: URL(string: "file:///tmp/Developer/Dependency")!,
        version: Version(1, 0, 0),
        executable: "Dependency",
        arguments: []
      )
      configuration.customProofreadingTasks.append(passing)
      PackageRepository(mock: "CustomProofread").test(
        commands: [
          ["proofread"],
          ["proofread", "•xcode"],
          ["refresh", "licence"],
          ["refresh", "file‐headers"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        withCustomTask: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCustomReadMe() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.currentVersion = Version(1, 2, 3)
      configuration.documentation.repositoryURL = URL(
        string: "https://github.com/User/Repository"
      )!
      configuration.documentation.localizations = ["en"]
      configuration.documentation.installationInstructions = Lazy(resolve: { configuration in
        return [
          "en": StrictString(
            [
              "## Installation",
              "",
              "Build from source at tag `\(configuration.documentation.currentVersion!.string())` of `\(configuration.documentation.repositoryURL!.absoluteString)`."
            ].joinedAsLines()
          )
        ]
      })
      configuration.licence.manage = true
      configuration.licence.licence = .unlicense
      configuration.fileHeaders.manage = true
      PackageRepository(mock: "CustomReadMe").test(
        commands: [
          ["refresh", "read‐me"],
          ["refresh", "licence"],
          ["refresh", "file‐headers"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testCustomTasks() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      let passing = CustomTask(
        url: URL(string: "file:///tmp/Developer/Dependency")!,
        version: Version(1, 0, 0),
        executable: "Dependency",
        arguments: []
      )
      configuration.customRefreshmentTasks.append(passing)
      configuration.customValidationTasks.append(passing)
      configuration.provideWorkflowScripts = false
      configuration.proofreading.rules = []
      configuration.proofreading.swiftFormatKonfiguration = nil
      configuration.testing.prohibitCompilerWarnings = false
      configuration.testing.enforceCoverage = false
      configuration.documentation.api.enforceCoverage = false
      configuration.xcode.manage = true
      PackageRepository(mock: "CustomTasks").test(
        commands: [
          ["refresh"],
          ["validate"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        withCustomTask: true,
        overwriteSpecificationInsteadOfFailing: false
      )

      var aufgabe = Sonderaufgabe(
        ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "domain.tld")!,
        version: Version(1, 0),
        ausführbareDatei: "werkzeug"
      )
      aufgabe.ressourcenzeiger = EinheitlicherRessourcenzeiger(string: "other.tld")!
      XCTAssertEqual(
        aufgabe.ressourcenzeiger,
        EinheitlicherRessourcenzeiger(string: "other.tld")!
      )
      aufgabe.version = Version(2, 0)
      XCTAssertEqual(aufgabe.version, Version(2, 0))
      aufgabe.ausführbareDatei = "andere"
      XCTAssertEqual(aufgabe.ausführbareDatei, "andere")
      aufgabe.argumente = ["eins", "zwei"]
      XCTAssertEqual(aufgabe.argumente, ["eins", "zwei"])
    #endif
  }

  func testDefaults() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let commands: [[StrictString]] = [
        ["refresh", "scripts"],
        ["refresh", "resources"],
        ["refresh", "examples"],
        ["refresh", "inherited‐documentation"],
        ["normalize"],

        ["proofread"],
        ["validate", "build"],
        ["test"],
        ["validate", "test‐coverage"],
        ["validate", "documentation‐coverage"],

        ["proofread", "•xcode"],
        ["validate", "build", "•job", "macos"],

        ["refresh"],
        ["validate"],
        ["validate", "•job", "macos"]
      ]
      PackageRepository(mock: "Default").test(
        commands: commands,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testDeutsch() throws {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      var output = try mockCommand.withRootBehaviour().execute(with: [
        "export‐interface", "•language", "de"
      ]).get()
      // macOS & Linux have different JSON whitespace.
      output.scalars.replaceMatches(
        for: "\n".scalars + RepetitionPattern(" ".scalars) + "\n".scalars,
        with: "\n\n".scalars
      )
      try output.save(
        to: PackageRepository.beforeDirectory(for: "Deutsch")
          .appendingPathComponent("Resources/werkzeug/Deutsch.txt")
      )

      let konfiguration = ArbeitsbereichKonfiguration()
      konfiguration.optimizeForTests()
      konfiguration.dokumentation.lokalisationen = ["de"]
      konfiguration.dokumentation.programmierschnittstelle.erstellen = true
      konfiguration.dokumentation.programmierschnittstelle
        .durchGitHubSeitenVeröffentlichen = true
      konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2000
      konfiguration.dokumentation.programmierschnittstelle
        .dateinamensersetzungenZurWindowsVerträglichkeitHinzufügen()
      var commands: [[StrictString]] = [
        ["auffrischen", "skripte"],
        ["auffrischen", "git"],
        ["auffrischen", "fortlaufende‐einbindung"],
        ["auffrischen", "ressourcen"],
        ["normalisieren"],
        ["prüfen", "erstellung"],
        ["prüfen", "testabdeckung"],
        ["prüfen", "dokumentationsabdeckung"],
        ["dokumentieren"]
      ]
      #if !os(Linux)
        commands.append(["auffrischen", "xcode"])
      #endif
      PackageRepository(mock: "Deutsch").test(
        commands: commands,
        configuration: konfiguration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testExecutable() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.supportedPlatforms.remove(.iOS)
      configuration.supportedPlatforms.remove(.watchOS)
      configuration.supportedPlatforms.remove(.tvOS)
      configuration.documentation.localizations = ["en"]
      PackageRepository(mock: "Executable").test(
        commands: [
          ["refresh", "licence"],
          ["refresh", "read‐me"],
          ["document"],
          ["validate", "documentation‐coverage"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testFailingCustomTasks() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      let failing = CustomTask(
        url: URL(string: "file:///tmp/Developer/Dependency")!,
        version: Version(1, 0, 0),
        executable: "Dependency",
        arguments: ["fail"]
      )
      configuration.customRefreshmentTasks.append(failing)
      configuration.provideWorkflowScripts = false
      configuration.proofreading.rules = []
      configuration.testing.prohibitCompilerWarnings = false
      configuration.testing.enforceCoverage = false
      configuration.documentation.api.enforceCoverage = false
      PackageRepository(mock: "FailingCustomTasks").test(
        commands: [
          ["refresh"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        withCustomTask: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testFailingCustomValidation() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      let failing = CustomTask(
        url: URL(string: "file:///tmp/Developer/Dependency")!,
        version: Version(1, 0, 0),
        executable: "Dependency",
        arguments: ["fail"]
      )
      configuration.customValidationTasks.append(failing)
      configuration.provideWorkflowScripts = false
      configuration.proofreading.rules = []
      configuration.proofreading.swiftFormatConfiguration = nil
      configuration.testing.prohibitCompilerWarnings = false
      configuration.testing.enforceCoverage = false
      configuration.documentation.api.enforceCoverage = false
      PackageRepository(mock: "FailingCustomValidation").test(
        commands: [
          ["validate"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        withCustomTask: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testFailingDocumentationCoverage() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.documentation.localizations = ["zxx"]
      configuration.xcode.manage = true
      configuration.documentation.repositoryURL = URL(string: "http://example.com")!
      configuration.documentation.api.applyWindowsCompatibilityFileNameReplacements()
      PackageRepository(mock: "FailingDocumentationCoverage").test(
        commands: [
          ["validate", "documentation‐coverage"],
          ["document"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testFailingTests() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.xcode.manage = true
      configuration.testing.exemptPaths.insert("Sources/FailingTests/Exempt")
      // Attempt to remove existing derived data so that the build is clean.
      // Otherwise Xcode skips the build stages where the awaited warnings occur.
      do {
        for url in try FileManager.default.contentsOfDirectory(
          at: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(
            "Library/Developer/Xcode/DerivedData"
          ),
          includingPropertiesForKeys: nil,
          options: []
        ) {
          if url.lastPathComponent.contains("FailingTests") {
            try? FileManager.default.removeItem(at: url)
          }
        }
      } catch {}
      // This test may fail if derived data is not in the default location. See above.
      PackageRepository(mock: "FailingTests").test(
        commands: [
          ["validate", "build"],
          ["validate", "test‐coverage"],
          ["validate", "build", "•job", "miscellaneous"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testHeaders() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["🇨🇦EN"]
      PackageRepository(mock: "Headers").test(
        commands: [
          ["refresh", "file‐headers"],
          ["refresh", "examples"],
          ["refresh", "inherited‐documentation"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testHelp() throws {
    #if !os(Android)  // #workaround(Swift 5.2.4, Segmentation fault)
      testCommand(
        Workspace.command,
        with: ["help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["proofread", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace proofread)",
        overwriteSpecificationInsteadOfFailing: false
      )
      #if os(Linux)  // Linux has no “xcode” subcommand, causing spec mis‐match.
        for localization in InterfaceLocalization.allCases {
          try LocalizationSetting(orderOfPrecedence: [localization.code]).do {
            _ = try Workspace.command.execute(with: ["refresh", "help"]).get()
          }
        }
      #else
        testCommand(
          Workspace.command,
          with: ["refresh", "help"],
          localizations: InterfaceLocalization.self,
          uniqueTestName: "Help (workspace refresh)",
          overwriteSpecificationInsteadOfFailing: false
        )
      #endif
      testCommand(
        Workspace.command,
        with: ["validate", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace validate)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["document", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace document)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["refresh", "continuous‐integration", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace refresh continuous‐integration)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["refresh", "examples", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace refresh examples)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["refresh", "inherited‐documentation", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace refresh inherited‐documentation)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["refresh", "resources", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace refresh resources)",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCommand(
        Workspace.command,
        with: ["refresh", "scripts", "help"],
        localizations: InterfaceLocalization.self,
        uniqueTestName: "Help (workspace refresh scripts)",
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testInvalidResourceDirectory() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "InvalidResourceDirectory").test(
        commands: [
          ["refresh", "resources"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testInvalidTarget() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "InvalidTarget").test(
        commands: [
          ["refresh", "resources"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testIssueTemplate() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      var vorlage = Themavorlage(
        name: "",
        beschreibung: "",
        inhalt: "",
        etiketten: []
      )
      vorlage.beschreibung = "..."
      XCTAssertEqual(vorlage.beschreibung, "...")
      vorlage.titel = "..."
      XCTAssertEqual(vorlage.titel, "...")
      vorlage.inhalt = "..."
      XCTAssertEqual(vorlage.inhalt, "...")
      vorlage.etiketten = ["..."]
      XCTAssertEqual(vorlage.etiketten, ["..."])
      vorlage.beauftragte = ["..."]
      XCTAssertEqual(vorlage.beauftragte, ["..."])
    #endif
  }

  func testLazyOption() {
    var lazy = Lazy(resolve: { _ in false })
    lazy.auswerten = { _ in true }
    XCTAssert(lazy.auswerten(WorkspaceConfiguration()))
  }

  func testLicence() {
    XCTAssertEqual(Lizenz.urheberrecht, Licence.copyright)
  }

  func testLocalizationIdentifier() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      var dictionary: [LocalizationIdentifier: Bool] = [:]
      dictionary[ContentLocalization.englishCanada] = true
      XCTAssertEqual(dictionary["🇨🇦EN"], true)
      dictionary["🇬🇧EN"] = false
      XCTAssertEqual(dictionary[ContentLocalization.englishUnitedKingdom], false)

      testCustomStringConvertibleConformance(
        of: LocalizationIdentifier("en"),
        localizations: FastTestLocalization.self,
        uniqueTestName: "English",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCustomStringConvertibleConformance(
        of: LocalizationIdentifier("cmn"),
        localizations: FastTestLocalization.self,
        uniqueTestName: "Mandarin",
        overwriteSpecificationInsteadOfFailing: false
      )
      testCustomStringConvertibleConformance(
        of: LocalizationIdentifier("zxx"),
        localizations: FastTestLocalization.self,
        uniqueTestName: "Unknown",
        overwriteSpecificationInsteadOfFailing: false
      )

      var identifier = LocalizationIdentifier("zxx")
      identifier.kennzeichen = "de"
      XCTAssertEqual(identifier.kennzeichen, "de")
      _ = identifier.symbol
    #endif
  }

  func testMissingDocumentation() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "MissingDocumentation").test(
        commands: [
          ["refresh", "inherited‐documentation"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testMissingExample() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "MissingExample").test(
        commands: [
          ["refresh", "examples"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testMissingReadMeLocalization() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["zxx"]
      configuration.documentation.readMe.contents.resolve = { _ in [:] }
      PackageRepository(mock: "MissingReadMeLocalization").test(
        commands: [
          ["refresh", "read‐me"]
        ],
        configuration: configuration,
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testMultipleProducts() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["en"]
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
      PackageRepository(mock: "MultipleProducts").test(
        commands: [
          ["refresh", "read‐me"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testNoLibraries() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["en"]
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
      PackageRepository(mock: "NoLibraries").test(
        commands: [
          ["refresh", "read‐me"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testNoLocalizations() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      PackageRepository(mock: "NoLocalizations").test(
        commands: [
          ["refresh", "read‐me"],
          ["validate", "documentation‐coverage"]
        ],
        localizations: InterfaceLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testNurDeutsch() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.gitHub.manage = true
      PackageRepository(mock: "NurDeutsch").test(
        commands: [
          ["auffrischen", "github"],
          ["normalisieren"],
          ["korrekturlesen"],
          ["prüfen", "erstellung"],
          ["testen"]
        ],
        configuration: configuration,
        localizations: NurDeutsch.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testOneLocalization() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["en"]
      PackageRepository(mock: "OneLocalization").test(
        commands: [
          ["refresh", "github"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testOneProductMultipleModules() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.documentation.localizations = ["en"]
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
      configuration.supportedPlatforms.remove(.windows)
      configuration.supportedPlatforms.remove(.android)
      PackageRepository(mock: "OneProductMultipleModules").test(
        commands: [
          ["refresh", "read‐me"],
          ["refresh", "continuous‐integration"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testOnlyBritish() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.gitHub.manage = true
      PackageRepository(mock: "OnlyBritish").test(
        commands: [
          ["refresh", "github"],
          ["normalize"]
        ],
        configuration: configuration,
        localizations: OnlyBritish.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testPartialReadMe() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration.optimizeForTests()
      configuration.xcode.manage = true
      configuration.documentation.currentVersion = Version(0, 1, 0)
      configuration.documentation.repositoryURL = URL(string: "http://example.com")!
      configuration.documentation.localizations = [
        "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"
      ]
      configuration.documentation.api.yearFirstPublished = 2018
      configuration.gitHub.developmentNotes = "..."
      let builtIn = configuration.fileHeaders.copyrightNotice
      configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
        resolve: { configuration in
          var result = builtIn.resolve(configuration)
          result["🇫🇷FR"] = "#dates"
          result["🇬🇷ΕΛ"] = "#dates"
          result["🇮🇱עב"] = "#dates"
          result["zxx"] = "#dates"
          return result
        })
      PackageRepository(mock: "PartialReadMe").test(
        commands: [
          ["refresh", "read‐me"],
          ["refresh", "github"],
          ["document"]
        ],
        configuration: configuration,
        localizations: FastTestLocalization.self,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testProofreadingRule() {
    XCTAssertEqual(Korrekturregel.überholteTestlisten, .deprecatedTestManifests)
    XCTAssertEqual(Korrekturregel.warnungenVonHand, .manualWarnings)
    XCTAssertEqual(Korrekturregel.fehlendeImplementierung, .missingImplementation)
    XCTAssertEqual(Korrekturregel.notlösungsErinnerungen, .workaroundReminders)
    XCTAssertEqual(Korrekturregel.verträglichkeitsschriftzeichen, .compatibilityCharacters)
    XCTAssertEqual(Korrekturregel.überschrifte, .marks)
    XCTAssertEqual(Korrekturregel.syntaxhervorhebung, .syntaxColoring)
    XCTAssertEqual(Korrekturregel.hervorhebungsGroßschreibung, .calloutCasing)
    XCTAssertEqual(Korrekturregel.abschlusssignaturplatzierung, .closureSignaturePosition)
    XCTAssertEqual(Korrekturregel.übergabewertenzusammenstellung, .parameterGrouping)
    XCTAssertEqual(Korrekturregel.überholteTestlisten.klasse, .überholung)
    XCTAssertEqual(Korrekturregel.warnungenVonHand.klasse, .absichtlich)
    XCTAssertEqual(Korrekturregel.verträglichkeitsschriftzeichen.klasse, .funktionalität)
    XCTAssertEqual(Korrekturregel.syntaxhervorhebung.klasse, .dokumentation)
    XCTAssertEqual(Korrekturregel.unicode.klasse, .textstil)
    XCTAssertEqual(Korrekturregel.übergabewertenzusammenstellung.klasse, .quellstil)
  }

  func testRelatedProject() {
    var project = RelatedProjectEntry.projekt(
      ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "seite.de")!
    )
    project = RelatedProjectEntry.überschrift(text: [:])
    _ = project
  }

  func testSDGLibrary() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration._applySDGDefaults()
      configuration.optimizeForTests()
      configuration.licence.licence = .apache2_0
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.projectWebsite = URL(
        string: "https://example.github.io/SDG/SDG"
      )!
      configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
      configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
      configuration.documentation.primaryAuthor = "John Doe"
      configuration.documentation.api.yearFirstPublished = 2017
      configuration.documentation.api.serveFromGitHubPagesBranch = true
      configuration.gitHub.administrators = ["John Doe", "Jane Doe"]
      configuration.documentation.localizations = [
        "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"
      ]
      for localization in configuration.documentation.localizations {
        configuration.documentation.about[localization] = "..."
      }
      configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
      configuration.documentation.relatedProjects = [
        .heading(text: ["🇨🇦EN": "Heading"]),
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
      ]
      configuration.testing.exemptionTokens.insert(
        TestCoverageExemptionToken("customSameLineToken", scope: .sameLine)
      )
      configuration.testing.exemptionTokens.insert(
        TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine)
      )

      let builtIn = configuration.fileHeaders.copyrightNotice
      configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
        resolve: { configuration in
          var result = builtIn.resolve(configuration)
          result["🇫🇷FR"] = "#dates"
          result["🇬🇷ΕΛ"] = "#dates"
          result["🇮🇱עב"] = "#dates"
          result["zxx"] = "#dates"
          return result
        })
      var commands: [[StrictString]] = [
        ["refresh", "scripts"],
        ["refresh", "git"],
        ["refresh", "read‐me"],
        ["refresh", "licence"],
        ["refresh", "github"],
        ["refresh", "continuous‐integration"],
        ["refresh", "resources"],
        ["refresh", "file‐headers"],
        ["refresh", "examples"],
        ["refresh", "inherited‐documentation"],
        ["normalize"]
      ]
      #if !os(Linux)
        commands.append(["refresh", "xcode"])
      #endif
      commands.append(contentsOf: [
        ["proofread"],
        ["validate", "build"],
        ["test"],
        ["validate", "test‐coverage"],
        ["validate", "documentation‐coverage"],

        ["proofread", "•xcode"],
        ["validate"]
      ])
      PackageRepository(mock: "SDGLibrary").test(
        commands: commands,
        configuration: configuration,
        sdg: true,
        localizations: FastTestLocalization.self,
        withDependency: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testSDGTool() {
    #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
      let configuration = WorkspaceConfiguration()
      configuration._applySDGDefaults()
      configuration.optimizeForTests()
      configuration.supportedPlatforms.remove(.iOS)
      configuration.supportedPlatforms.remove(.watchOS)
      configuration.supportedPlatforms.remove(.tvOS)
      configuration.licence.licence = .apache2_0
      configuration.documentation.currentVersion = Version(1, 0, 0)
      configuration.documentation.projectWebsite = URL(
        string: "https://example.github.io/SDG/SDG"
      )!
      configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
      configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
      configuration.documentation.primaryAuthor = "John Doe"
      configuration.documentation.api.yearFirstPublished = 2017
      configuration.documentation.api.serveFromGitHubPagesBranch = true
      configuration.gitHub.administrators = ["John Doe"]
      configuration.documentation.localizations = [
        "🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"
      ]
      for localization in configuration.documentation.localizations {
        configuration.documentation.about[localization] = "..."
      }
      configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
      configuration.documentation.relatedProjects = [
        .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
      ]
      configuration.testing.exemptionTokens.insert(
        TestCoverageExemptionToken("customSameLineToken", scope: .sameLine)
      )
      configuration.testing.exemptionTokens.insert(
        TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine)
      )

      let builtIn = configuration.fileHeaders.copyrightNotice
      configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(
        resolve: { configuration in
          var result = builtIn.resolve(configuration)
          result["🇫🇷FR"] = "#dates"
          result["🇬🇷ΕΛ"] = "#dates"
          result["🇮🇱עב"] = "#dates"
          result["zxx"] = "#dates"
          return result
        })
      var commands: [[StrictString]] = [
        ["refresh", "scripts"],
        ["refresh", "git"],
        ["refresh", "read‐me"],
        ["refresh", "licence"],
        ["refresh", "github"],
        ["refresh", "continuous‐integration"],
        ["refresh", "resources"],
        ["refresh", "file‐headers"],
        ["refresh", "examples"],
        ["refresh", "inherited‐documentation"],
        ["normalize"]
      ]
      #if !os(Linux)
        commands.append(["refresh", "xcode"])
      #endif
      commands.append(contentsOf: [
        ["proofread"],
        ["validate", "build"],
        ["test"],
        ["validate", "test‐coverage"],
        ["validate", "documentation‐coverage"],

        ["proofread", "•xcode"]
      ])
      PackageRepository(mock: "SDGTool").test(
        commands: commands,
        configuration: configuration,
        sdg: true,
        localizations: FastTestLocalization.self,
        withDependency: true,
        overwriteSpecificationInsteadOfFailing: false
      )
    #endif
  }

  func testSelfSpecificScripts() throws {
    #if !os(Android)  // #workaround(Swift 5.2.4, Segmentation fault.)
      #if !os(Windows)  // #workaround(Swift 5.2.4, SegFault)
        try FileManager.default.do(in: repositoryRoot) {
          _ = try Workspace.command.execute(with: ["refresh", "scripts"]).get()
          _ = try Workspace.command.execute(with: ["refresh", "continuous‐integration"]).get()
        }
      #endif
    #endif
  }

  func testTestCoverageExemptionToken() {
    var zeichen = Testabdeckungsausnahmszeichen("...", geltungsbereich: .selbeZeile)
    zeichen.zeichen = ""
    XCTAssertEqual(zeichen.zeichen, "")
    zeichen.geltungsbereich = .vorstehendeZeile
    XCTAssertEqual(zeichen.geltungsbereich, .vorstehendeZeile)
  }

  func testUnicodeRuleScope() {
    XCTAssertEqual(GeltungsbereichUnicodeRegel.maschinenkennzeichungen, .machineIdentifiers)
    XCTAssertEqual(GeltungsbereichUnicodeRegel.menschlicheSprache, .humanLanguage)
    XCTAssertEqual(GeltungsbereichUnicodeRegel.uneindeutig, .ambiguous)
  }
}
