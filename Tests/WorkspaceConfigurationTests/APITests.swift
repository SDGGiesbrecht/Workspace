/*
 APITests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2021–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2021–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import WorkspaceConfiguration
import WorkspaceLocalizations

import WorkspaceProjectConfiguration

import XCTest

import SDGXCTestUtilities
import SDGLocalizationTestUtilities

class APITests: TestCase {

  override func setUp() {
    super.setUp()
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      WorkspaceContext.current = WorkspaceContext(
        _location: URL(string: "http://www.example.com")!,
        manifest: PackageManifest(_packageName: "Uninitialized", products: [])
      )
    #endif
  }

  func testArray() {
    XCTAssertEqual(["a", "b"].verbundenAlsZeile(), "a\nb")
    XCTAssertEqual([].joinedAsLines(), "")
  }

  func testCustomTask() {
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
  }

  func testIssueTemplate() {
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
  }

  func testLazyOption() throws {
    let configuration = WorkspaceConfiguration()
    var lazy = Lazy(resolve: { _ in false })
    lazy.auswerten = { _ in true }
    XCTAssert(lazy.auswerten(configuration))
    let encoded = try JSONEncoder().encode(lazy)
    let decoded = try JSONDecoder().decode(Lazy<Bool>.self, from: encoded)
    _ = decoded.resolve(configuration)
  }

  func testLicence() throws {
    XCTAssertEqual(Lizenz.urheberrecht, Licence.copyright)
    for licence in [
      Licence.apache2_0,
      Licence.mit,
      Licence.gnuGeneralPublic3_0,
      Licence.unlicense,
      Licence.copyright,
    ] {
      let configuaration = WorkspaceConfiguration()
      configuaration.licence.licence = licence
      _ = try JSONEncoder().encode(configuaration)
    }
  }

  func testLocalizationIdentifier() {
    var dictionary: [LocalizationIdentifier: Bool] = [:]
    dictionary[ContentLocalization.englishCanada] = true
    XCTAssertEqual(dictionary["🇨🇦EN"], true)
    dictionary["🇬🇧EN"] = false
    XCTAssertEqual(dictionary[ContentLocalization.englishUnitedKingdom], false)

    testCustomStringConvertibleConformance(
      of: LocalizationIdentifier("en"),
      localizations: ContentLocalization.self,
      uniqueTestName: "English",
      overwriteSpecificationInsteadOfFailing: false
    )
    testCustomStringConvertibleConformance(
      of: LocalizationIdentifier("cmn"),
      localizations: ContentLocalization.self,
      uniqueTestName: "Mandarin",
      overwriteSpecificationInsteadOfFailing: false
    )
    testCustomStringConvertibleConformance(
      of: LocalizationIdentifier("zxx"),
      localizations: ContentLocalization.self,
      uniqueTestName: "Unknown",
      overwriteSpecificationInsteadOfFailing: false
    )

    var identifier = LocalizationIdentifier("zxx")
    _ = identifier._iconOrCode
    identifier.kennzeichen = "de"
    XCTAssertEqual(identifier.kennzeichen, "de")
    _ = identifier.symbol
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
    XCTAssertEqual(Korrekturregel.überholteRessourcenOrdner, .deprecatedResourceDirectory)
    XCTAssertEqual(Korrekturregel.ausdrücklicheTypen, .explicitTypes)
  }

  func testRelatedProject() {
    var project = RelatedProjectEntry.projekt(
      ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "seite.de")!
    )
    project = RelatedProjectEntry.überschrift(text: [:])
    _ = project
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

  func testWorkspaceConfiguration() throws {
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
    #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
      configuration.korrektur.swiftFormatKonfiguration = nil
      XCTAssertNil(configuration.korrektur.swiftFormatKonfiguration)
    #endif
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
    XCTAssertEqual(ProofreadingRule.listentrennung, .listSeparation)
    XCTAssertEqual(ProofreadingRule.aufzählungszeichen, .bullets)
    XCTAssertEqual(ProofreadingRule.markdownÜberschrifte, .markdownHeadings)
    XCTAssertEqual(ProofreadingRule.sterngruppen, .asterisms)
    XCTAssertEqual(ProofreadingRule.zugriffskontrolle, .accessControl)
    XCTAssertEqual(ProofreadingRule.classFinality, .klassenentgültigkeit)

    let defaults = WorkspaceConfiguration()
    _ = try? JSONEncoder().encode(defaults)

    let filledIn = WorkspaceConfiguration()
    filledIn.documentation.localizations = ["en", "de", "zxx"]
    let copyright = filledIn.fileHeaders.copyrightNotice.resolve
    filledIn.fileHeaders.copyrightNotice = Lazy(resolve: { configuration in
      return copyright(configuration).mergedByOverwriting(from: ["zxx": "..."])
    })
    filledIn.documentation.repositoryURL = URL(string: "http://example.com")!
    filledIn.documentation.currentVersion = Version(1)
    filledIn.documentation.documentationURL = URL(string: "http://example.com")!
    filledIn.documentation.about = [
      "zxx": "...",
      "de": "...",
    ]
    filledIn.documentation.relatedProjects = [
      RelatedProjectEntry.heading(text: ["zxx": "..."]),
      RelatedProjectEntry.project(url: URL(string: "http://example.com")!),
    ]
    filledIn.documentation.primaryAuthor = "..."
    filledIn.documentation.api.dateinamensersetzungenZurWindowsVerträglichkeitHinzufügen()
    filledIn.gitHub.developmentNotes = "..."
    filledIn.gitHub.administrators = ["A", "B", "C"]
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      WorkspaceContext.current = WorkspaceContext(
        _location: URL(string: "http://www.example.com")!,
        manifest: PackageManifest(
          _packageName: "Some Package",
          products: [
            PackageManifest.Product(
              _name: "Library Product",
              type: .library,
              modules: ["SomeModule"]
            ),
            PackageManifest.Product(
              _name: "Executable Product",
              type: .executable,
              modules: ["SomeModule"]
            ),
          ]
        )
      )
    #endif
    let encoded = try JSONEncoder().encode(filledIn)
    _ = try JSONDecoder().decode(WorkspaceConfiguration.self, from: encoded)

    let manyProducts = WorkspaceConfiguration()
    manyProducts.documentation.localizations = ["en", "de", "zxx"]
    manyProducts.documentation.repositoryURL = URL(string: "http://example.com")!
    manyProducts.documentation.currentVersion = Version(0, 1)
    manyProducts.documentation.primaryAuthor = nil
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      WorkspaceContext.current = WorkspaceContext(
        _location: URL(string: "http://www.example.com")!,
        manifest: PackageManifest(
          _packageName: "Some Package",
          products: [
            PackageManifest.Product(
              _name: "Library Product",
              type: .library,
              modules: ["SomeModule"]
            ),
            PackageManifest.Product(
              _name: "Another Library Product",
              type: .library,
              modules: ["SomeOtherModule"]
            ),
            PackageManifest.Product(
              _name: "Executable Product",
              type: .executable,
              modules: ["SomeModule"]
            ),
            PackageManifest.Product(
              _name: "Another Executable Product",
              type: .executable,
              modules: ["SomeOtherModule"]
            ),
          ]
        )
      )
    #endif
    _ = try JSONEncoder().encode(manyProducts)

    let noProducts = WorkspaceConfiguration()
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      WorkspaceContext.current = WorkspaceContext(
        _location: URL(string: "http://www.example.com")!,
        manifest: PackageManifest(
          _packageName: "Some Package",
          products: []
        )
      )
    #endif
    _ = try JSONEncoder().encode(noProducts)
    configuration.generateResourceAccessors = false
    XCTAssertFalse(configuration.ressourcenzugriffErstellen)
    configuration.ressourcenzugriffErstellen = true
    XCTAssert(configuration.generateResourceAccessors)
  }

  func testWorkspaceProjectConfiguration() throws {
    #if !PLATFORM_CANNOT_USE_PLUG_INS
      let configuration = WorkspaceProjectConfiguration.configuration
    #else
      let configuration = WorkspaceConfiguration()
      configuration._applySDGDefaults()
      configuration.documentation.currentVersion = Version(0, 39, 1)
      configuration.documentation.projectWebsite = URL(
        string: "https://github.com/SDGGiesbrecht/Workspace#workspace"
      )!
      configuration.documentation.repositoryURL = URL(
        string: "https://github.com/SDGGiesbrecht/Workspace"
      )!
      configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE"]
      configuration._applySDGOverrides()
      configuration._validateSDGStandards(openSource: true)
    #endif
    let encoded = try JSONEncoder().encode(configuration)
    _ = try JSONDecoder().decode(WorkspaceConfiguration.self, from: encoded)
  }

  func testWorkspaceContext() {
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
    #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
      WorkspaceContext.aktueller = context
      _ = WorkspaceContext.aktueller
    #endif
  }
}
