/*
 APITests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralTestImports

import SDGExternalProcess

import WorkspaceConfiguration
import WSProject

class APITests : TestCase {

    static var triggeredVersionChecks: Void?
    override func setUp() {
        super.setUp()
        Command.Output.testMode = true
        PackageRepository.emptyRelatedProjectCache() // Make sure starting state is consistent.
        CustomTask.emptyCache()
    }

    func testAllDisabled() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "AllDisabled").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testAllTasks() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.optIntoAllTasks()
        configuration.documentation.localizations = ["🇮🇱עב"]
        configuration.licence.licence = .copyright
        configuration.documentation.api.yearFirstPublished = 2018
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["🇮🇱עב"] = "#dates"
            return result
        })
        PackageRepository(mock: "AllTasks").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testArray() {
        XCTAssertEqual(["a", "b"].verbundenAlsZeile(), "a\nb")
    }

    func testBadStyle() {
        let configuration = WorkspaceConfiguration()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customProofreadingTasks.append(failing)
        PackageRepository(mock: "BadStyle").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testBrokenExample() {
        PackageRepository(mock: "BrokenExample").test(commands: [
            ["refresh", "examples"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testBrokenTests() {
        PackageRepository(mock: "BrokenTests").test(commands: [
            ["test"]
            ], localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCheckedInDocumentation() throws {
        var output = try mockCommand.withRootBehaviour().execute(with: ["export‐interface", "•language", "en"]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(for: CompositePattern([
            LiteralPattern("\n".scalars),
            RepetitionPattern(" ".scalars),
            LiteralPattern("\n".scalars)
            ]), with: "\n\n".scalars)
        try output.save(
            to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
                .appendingPathComponent("Resources/Tool/English.txt"))
        output = try mockCommand.withRootBehaviour().execute(with: ["export‐interface", "•language", "de"]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(for: CompositePattern([
            LiteralPattern("\n".scalars),
            RepetitionPattern(" ".scalars),
            LiteralPattern("\n".scalars)
            ]), with: "\n\n".scalars)
        try output.save(
            to: PackageRepository.beforeDirectory(for: "CheckedInDocumentation")
                .appendingPathComponent("Resources/Tool/Deutsch.txt"))

        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.api.enforceCoverage = false
        configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE", "zxx"]
        configuration.documentation.api.generate = true
        configuration.documentation.about["🇨🇦EN"] = "Stuff about the creators...\n\n...and more stuff..."
        configuration.documentation.about["🇺🇸EN"] = ""
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.documentation.api.ignoredDependencies.remove("Swift")
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
            var result = builtIn.resolve(configuration)
            result["zxx"] = "#dates"
            return result
        })
        configuration.provideWorkflowScripts = false
        PackageRepository(mock: "CheckedInDocumentation").test(commands: [
            ["refresh"],
            ["validate", "•job", "miscellaneous"],
            ["validate", "•job", "deployment"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCheckForUpdates() throws {
        _ = try Workspace.command.execute(with: ["check‐for‐updates"]).get()
    }

    func testConfiguration() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults(openSource: false)
        XCTAssertFalse(configuration.documentation.readMe.manage)

        configuration.fortlaufenderEinbindung.verwalten = false
        XCTAssertFalse(configuration.fortlaufenderEinbindung.verwalten)
        configuration.fortlaufenderEinbindung.auserhalbFortlaufenderEinbindungSimulatorÜberspringen = true
        XCTAssert(configuration.fortlaufenderEinbindung.auserhalbFortlaufenderEinbindungSimulatorÜberspringen)
        configuration.customRefreshmentTasks.append(Sonderaufgabe(
            ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "domain.tld")!,
            version: Version(1, 0),
            ausführbareDatei: "werkzeug",
            argumente: ["argument"]))
        XCTAssertEqual(configuration.customRefreshmentTasks.last?.version.major, 1)
        configuration.dokumentation.programmierschnittstelle.erstellen = false
        XCTAssertFalse(configuration.dokumentation.programmierschnittstelle.erstellen)
        configuration.dokumentation.programmierschnittstelle.abdeckungErzwingen = false
        XCTAssertFalse(configuration.dokumentation.programmierschnittstelle.abdeckungErzwingen)
        configuration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 1
        XCTAssertEqual(configuration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung, 1)
        configuration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk = BequemeEinstellung(auswerten: { _ in [:] })
        XCTAssertEqual(
            configuration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk
                .auswerten(configuration),
            [:])
        configuration.dokumentation.programmierschnittstelle.verschlüsselterTravisCIVerteilungsschlüssel = ""
        XCTAssertEqual(
            configuration.dokumentation.programmierschnittstelle.verschlüsselterTravisCIVerteilungsschlüssel,
            "")
        configuration.dokumentation.programmierschnittstelle.übergegangeneAbhängigkeiten.insert("...")
        XCTAssert(configuration.dokumentation.programmierschnittstelle.übergegangeneAbhängigkeiten.contains("..."))
        configuration.dokumentation.localisations = ["und"]
        XCTAssertEqual(configuration.dokumentation.localisations, ["und"])
        configuration.dokumentation.lokalisationen = ["zxx"]
        XCTAssertEqual(configuration.dokumentation.lokalisationen, ["zxx"])
        configuration.dokumentation.aktuelleVersion = Version(1, 0)
        XCTAssertEqual(configuration.dokumentation.aktuelleVersion, Version(1, 0))
        configuration.dokumentation.projektSeite = EinheitlicherRessourcenzeiger(string: "seite.de")
        XCTAssertEqual(configuration.dokumentation.projektSeite, EinheitlicherRessourcenzeiger(string: "seite.de"))
        configuration.dokumentation.dokumentationsRessourcenzeiger = EinheitlicherRessourcenzeiger(
            string: "dokumentation.de")
        XCTAssertEqual(
            configuration.dokumentation.dokumentationsRessourcenzeiger,
            EinheitlicherRessourcenzeiger(string: "dokumentation.de"))
        configuration.dokumentation.lagerRessourcenzeiger = EinheitlicherRessourcenzeiger(string: "lager.de")
        XCTAssertEqual(
            configuration.dokumentation.lagerRessourcenzeiger,
            EinheitlicherRessourcenzeiger(string: "lager.de"))
        configuration.dokumentation.hauptautor = "Autor"
        XCTAssertEqual(configuration.dokumentation.hauptautor, "Autor")
        configuration.dokumentation.installationsanleitungen = BequemeEinstellung(auswerten: { _ in [:] })
        XCTAssertEqual(configuration.dokumentation.installationsanleitungen.auswerten(configuration), [:])
        configuration.dokumentation.einführungsanleitungen = BequemeEinstellung(auswerten: { _ in [:] })
        XCTAssertEqual(configuration.dokumentation.einführungsanleitungen.auswerten(configuration), [:])
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
        configuration.dateiVorspänne.urheberrechtshinweis = BequemeEinstellung(auswerten: { _ in [:] })
        XCTAssertNil(configuration.dateiVorspänne.urheberrechtshinweis.auswerten(configuration)["de"])
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
    }

    func testConfiguartionContext() {
        let context = WorkspaceContext(
            _location: URL(string: "site.tld")!,
            manifest: PackageManifest(_packageName: "Package", products: [
                PackageManifest.Product(_name: "Product", type: .library, modules: ["Module"])
                ]))
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
        let configuration = WorkspaceConfiguration()
        configuration.provideWorkflowScripts = false
        configuration.continuousIntegration.manage = true
        configuration.licence.manage = true
        configuration.licence.licence = .mit
        configuration.fileHeaders.manage = true
        PackageRepository(mock: "ContinuousIntegrationWithoutScripts").test(commands: [
            ["refresh", "continuous‐integration"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomProofread() {
        let configuration = WorkspaceConfiguration()
        configuration.proofreading.rules.remove(.colonSpacing)
        configuration.proofreading.unicodeRuleScope.remove(.ambiguous)
        for rule in ProofreadingRule.allCases {
            _ = rule.category
        }
        configuration.licence.manage = true
        configuration.licence.licence = .gnuGeneralPublic3_0
        configuration.fileHeaders.manage = true
        let passing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: [])
        configuration.customProofreadingTasks.append(passing)
        PackageRepository(mock: "CustomProofread").test(commands: [
            ["proofread"],
            ["proofread", "•xcode"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.currentVersion = Version(1, 2, 3)
        configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Repository")!
        configuration.documentation.localizations = ["en"]
        configuration.documentation.installationInstructions = Lazy(resolve: { configuration in
            return [
                "en": StrictString([
                    "## Installation",
                    "",
                    "Build from source at tag `\(configuration.documentation.currentVersion!.string())` of `\(configuration.documentation.repositoryURL!.absoluteString)`."
                    ].joinedAsLines())
            ]
        })
        configuration.licence.manage = true
        configuration.licence.licence = .unlicense
        configuration.fileHeaders.manage = true
        PackageRepository(mock: "CustomReadMe").test(commands: [
            ["refresh", "read‐me"],
            ["refresh", "licence"],
            ["refresh", "file‐headers"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testCustomTasks() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let passing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: [])
        configuration.customRefreshmentTasks.append(passing)
        configuration.customValidationTasks.append(passing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        configuration.xcode.manage = true
        PackageRepository(mock: "CustomTasks").test(commands: [
            ["refresh"],
            ["validate"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)

        var aufgabe = Sonderaufgabe(
            ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "domain.tld")!,
            version: Version(1, 0),
            ausführbareDatei: "werkzeug")
        aufgabe.ressourcenzeiger = EinheitlicherRessourcenzeiger(string: "other.tld")!
        XCTAssertEqual(aufgabe.ressourcenzeiger, EinheitlicherRessourcenzeiger(string: "other.tld")!)
        aufgabe.version = Version(2, 0)
        XCTAssertEqual(aufgabe.version, Version(2, 0))
        aufgabe.ausführbareDatei = "andere"
        XCTAssertEqual(aufgabe.ausführbareDatei, "andere")
        aufgabe.argumente = ["eins", "zwei"]
        XCTAssertEqual(aufgabe.argumente, ["eins", "zwei"])
    }

    func testDefaults() {
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
        PackageRepository(mock: "Default").test(commands: commands, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testDeutsch() throws {
        var output = try mockCommand.withRootBehaviour().execute(with: ["export‐interface", "•language", "de"]).get()
        // macOS & Linux have different JSON whitespace.
        output.scalars.replaceMatches(for: CompositePattern([
            LiteralPattern("\n".scalars),
            RepetitionPattern(" ".scalars),
            LiteralPattern("\n".scalars)
            ]), with: "\n\n".scalars)
        try output.save(
            to: PackageRepository.beforeDirectory(for: "Deutsch")
                .appendingPathComponent("Resources/werkzeug/Deutsch.txt"))

        let konfiguration = ArbeitsbereichKonfiguration()
        konfiguration.optimizeForTests()
        konfiguration.dokumentation.lokalisationen = ["de"]
        konfiguration.dokumentation.programmierschnittstelle.erstellen = true
        konfiguration.dokumentation.programmierschnittstelle.verschlüsselterTravisCIVerteilungsschlüssel = "..."
        konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2000
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
        PackageRepository(mock: "Deutsch").test(commands: commands, configuration: konfiguration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testExecutable() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.documentation.localizations = ["en"]
        PackageRepository(mock: "Executable").test(commands: [
            ["refresh", "licence"],
            ["refresh", "read‐me"],
            ["document"],
            ["validate", "documentation‐coverage"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingCustomTasks() {
        let configuration = WorkspaceConfiguration()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customRefreshmentTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "FailingCustomTasks").test(commands: [
            ["refresh"]
            ], configuration: configuration, localizations: FastTestLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingCustomValidation() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        let failing = CustomTask(url: URL(string: "file:///tmp/Developer/Dependency")!, version: Version(1, 0, 0), executable: "Dependency", arguments: ["fail"])
        configuration.customValidationTasks.append(failing)
        configuration.provideWorkflowScripts = false
        configuration.proofreading.rules = []
        configuration.testing.prohibitCompilerWarnings = false
        configuration.testing.enforceCoverage = false
        configuration.documentation.api.enforceCoverage = false
        PackageRepository(mock: "FailingCustomValidation").test(commands: [
            ["validate"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, withCustomTask: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingDocumentationCoverage() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.documentation.localizations = ["zxx"]
        configuration.xcode.manage = true
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        PackageRepository(mock: "FailingDocumentationCoverage").test(commands: [
            ["validate", "documentation‐coverage"],
            ["document"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testFailingTests() {
        let configuration = WorkspaceConfiguration()
        configuration.xcode.manage = true
        configuration.testing.exemptPaths.insert("Sources/FailingTests/Exempt")
        // Attempt to remove existing derived data so that the build is clean.
        // Otherwise Xcode skips the build stages where the awaited warnings occur.
        do {
            for url in try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Developer/Xcode/DerivedData"), includingPropertiesForKeys: nil, options: []) {
                if url.lastPathComponent.contains("FailingTests") {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch {}
        // This test may fail if derived data is not in the default location. See above.
        PackageRepository(mock: "FailingTests").test(commands: [
            ["validate", "build"],
            ["validate", "test‐coverage"],
            ["validate", "build", "•job", "miscellaneous"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testHeaders() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["🇨🇦EN"]
        PackageRepository(mock: "Headers").test(commands: [
            ["refresh", "file‐headers"],
            ["refresh", "examples"],
            ["refresh", "inherited‐documentation"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testHelp() throws {
        testCommand(Workspace.command, with: ["help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["proofread", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace proofread)", overwriteSpecificationInsteadOfFailing: false)
        #if os(Linux) // Linux has no “xcode” subcommand, causing spec mis‐match.
        for localization in InterfaceLocalization.allCases {
            try LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                _ = try Workspace.command.execute(with: ["refresh", "help"])
            }
        }
        #else
        testCommand(Workspace.command, with: ["refresh", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh)", overwriteSpecificationInsteadOfFailing: false)
        #endif
        testCommand(Workspace.command, with: ["validate", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace validate)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["document", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace document)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "continuous‐integration", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh continuous‐integration)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "examples", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh examples)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "inherited‐documentation", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh inherited‐documentation)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "resources", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh resources)", overwriteSpecificationInsteadOfFailing: false)
        testCommand(Workspace.command, with: ["refresh", "scripts", "help"], localizations: InterfaceLocalization.self, uniqueTestName: "Help (workspace refresh scripts)", overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidResourceDirectory() {
        PackageRepository(mock: "InvalidResourceDirectory").test(commands: [
            ["refresh", "resources"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testInvalidTarget() {
        PackageRepository(mock: "InvalidTarget").test(commands: [
            ["refresh", "resources"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testIssueTemplate() {
        var vorlage = Themavorlage(
            name: "",
            beschreibung: "",
            inhalt: "",
            etiketten: [])
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

    func testLazyOption() {
        var lazy = Lazy(resolve: { _ in false })
        lazy.auswerten = { _ in true }
        XCTAssert(lazy.auswerten(WorkspaceConfiguration()))
    }

    func testLicence() {
        XCTAssertEqual(Lizenz.urheberrecht, Licence.copyright)
    }

    func testLocalizationIdentifier() {
        var dictionary: [LocalizationIdentifier: Bool] = [:]
        dictionary[ContentLocalization.englishCanada] = true
        XCTAssertEqual(dictionary["🇨🇦EN"], true)
        dictionary["🇬🇧EN"] = false
        XCTAssertEqual(dictionary[ContentLocalization.englishUnitedKingdom], false)

        testCustomStringConvertibleConformance(of: LocalizationIdentifier("en"), localizations: FastTestLocalization.self, uniqueTestName: "English", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("cmn"), localizations: FastTestLocalization.self, uniqueTestName: "Mandarin", overwriteSpecificationInsteadOfFailing: false)
        testCustomStringConvertibleConformance(of: LocalizationIdentifier("zxx"), localizations: FastTestLocalization.self, uniqueTestName: "Unknown", overwriteSpecificationInsteadOfFailing: false)

        var identifier = LocalizationIdentifier("zxx")
        identifier.kennzeichen = "de"
        XCTAssertEqual(identifier.kennzeichen, "de")
        _ = identifier.symbol
    }

    func testMissingDocumentation() {
        PackageRepository(mock: "MissingDocumentation").test(commands: [
            ["refresh", "inherited‐documentation"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingExample() {
        PackageRepository(mock: "MissingExample").test(commands: [
            ["refresh", "examples"]
            ], localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMissingReadMeLocalization() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["zxx"]
        configuration.documentation.readMe.contents.resolve = { _ in [:] }
        PackageRepository(mock: "MissingReadMeLocalization").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: InterfaceLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testMultipleProducts() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "MultipleProducts").test(commands: [
            ["refresh", "read‐me"]
            ], configuration: configuration, localizations: FastTestLocalization.self, overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLibraries() {
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
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testNoLocalizations() {
        PackageRepository(mock: "NoLocalizations").test(
            commands: [
                ["refresh", "read‐me"],
                ["validate", "documentation‐coverage"]
            ],
            localizations: InterfaceLocalization.self,
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testNurDeutsch() {
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
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testOneLocalization() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        PackageRepository(mock: "OneLocalization").test(
            commands: [
                ["refresh", "github"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testOneProductMultipleModules() {
        let configuration = WorkspaceConfiguration()
        configuration.documentation.localizations = ["en"]
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.repositoryURL = URL(string: "https://somewhere.tld/repository")!
        PackageRepository(mock: "OneProductMultipleModules").test(
            commands: [
                ["refresh", "read‐me"]
            ],
            configuration: configuration,
            localizations: FastTestLocalization.self,
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testOnlyBritish() {
        let configuration = WorkspaceConfiguration()
        configuration.gitHub.manage = true
        PackageRepository(mock: "OnlyBritish").test(
            commands: [
                ["refresh", "github"],
                ["normalize"]
            ],
            configuration: configuration,
            localizations: OnlyBritish.self,
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testPartialReadMe() {
        let configuration = WorkspaceConfiguration()
        configuration.optimizeForTests()
        configuration.xcode.manage = true
        configuration.documentation.currentVersion = Version(0, 1, 0)
        configuration.documentation.repositoryURL = URL(string: "http://example.com")!
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        configuration.documentation.api.yearFirstPublished = 2018
        configuration.gitHub.developmentNotes = "..."
        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
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
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testProofreadingRule() {
        XCTAssertEqual(Korrekturregel.überholteBedingungsdokumentation, .deprecatedConditionDocumentation)
        XCTAssertEqual(Korrekturregel.warnungenVonHand, .manualWarnings)
        XCTAssertEqual(Korrekturregel.fehlendeImplementierung, .missingImplementation)
        XCTAssertEqual(Korrekturregel.notlösungsErinnerungen, .workaroundReminders)
        XCTAssertEqual(Korrekturregel.verträglichkeitsschriftzeichen, .compatibilityCharacters)
        XCTAssertEqual(Korrekturregel.widerstandGegenAutomatischenEinzug, .autoindentResilience)
        XCTAssertEqual(Korrekturregel.überschrifte, .marks)
        XCTAssertEqual(Korrekturregel.syntaxhervorhebung, .syntaxColoring)
        XCTAssertEqual(Korrekturregel.abstandGeschweifterKlammern, .braceSpacing)
        XCTAssertEqual(Korrekturregel.doppelpunktabstand, .colonSpacing)
        XCTAssertEqual(Korrekturregel.hervorhebungsGroßschreibung, .calloutCasing)
        XCTAssertEqual(Korrekturregel.abschlusssignaturplatzierung, .closureSignaturePosition)
        XCTAssertEqual(Korrekturregel.übergabewertenzusammenstellung, .parameterGrouping)
        XCTAssertEqual(Korrekturregel.überholteBedingungsdokumentation.klasse, .überholung)
        XCTAssertEqual(Korrekturregel.warnungenVonHand.klasse, .absichtlich)
        XCTAssertEqual(Korrekturregel.verträglichkeitsschriftzeichen.klasse, .funktionalität)
        XCTAssertEqual(Korrekturregel.syntaxhervorhebung.klasse, .dokumentation)
        XCTAssertEqual(Korrekturregel.unicode.klasse, .textstil)
        XCTAssertEqual(Korrekturregel.übergabewertenzusammenstellung.klasse, .quellstil)
    }

    func testRelatedProject() {
        var project = RelatedProjectEntry.projekt(ressourcenzeiger: EinheitlicherRessourcenzeiger(string: "seite.de")!)
        project = RelatedProjectEntry.überschrift(text: [:])
        _ = project
    }

    func testSDGLibrary() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(string: "https://example.github.io/SDG/SDG")!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.encryptedTravisCIDeploymentKey = "0123456789abcdef"
        configuration.gitHub.administrators = ["John Doe", "Jane Doe"]
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        for localization in configuration.documentation.localizations {
            configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .heading(text: ["🇨🇦EN": "Heading"]),
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
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
            withDependency: true, overwriteSpecificationInsteadOfFailing: false)
    }

    func testSDGTool() {
        let configuration = WorkspaceConfiguration()
        configuration._applySDGDefaults()
        configuration.optimizeForTests()
        configuration.supportedPlatforms.remove(.iOS)
        configuration.supportedPlatforms.remove(.watchOS)
        configuration.supportedPlatforms.remove(.tvOS)
        configuration.licence.licence = .apache2_0
        configuration.documentation.currentVersion = Version(1, 0, 0)
        configuration.documentation.projectWebsite = URL(string: "https://example.github.io/SDG/SDG")!
        configuration.documentation.documentationURL = URL(string: "https://example.github.io/SDG")!
        configuration.documentation.repositoryURL = URL(string: "https://github.com/JohnDoe/SDG")!
        configuration.documentation.primaryAuthor = "John Doe"
        configuration.documentation.api.yearFirstPublished = 2017
        configuration.documentation.api.encryptedTravisCIDeploymentKey = "0123456789abcdef"
        configuration.gitHub.administrators = ["John Doe"]
        configuration.documentation.localizations = ["🇨🇦EN", "🇬🇧EN", "🇺🇸EN", "🇩🇪DE", "🇫🇷FR", "🇬🇷ΕΛ", "🇮🇱עב", "zxx"]
        for localization in configuration.documentation.localizations {
            configuration.documentation.about[localization] = "..."
        }
        configuration.documentation.about["🇨🇦EN"] = "This project is just a test."
        configuration.documentation.relatedProjects = [
            .project(url: URL(string: "https://github.com/SDGGiesbrecht/Workspace")!)
        ]
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customSameLineToken", scope: .sameLine))
        configuration.testing.exemptionTokens.insert(TestCoverageExemptionToken("customPreviousLineToken", scope: .previousLine))

        let builtIn = configuration.fileHeaders.copyrightNotice
        configuration.fileHeaders.copyrightNotice = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
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
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testSelfSpecificScripts() throws {
        try FileManager.default.do(in: repositoryRoot) {
            _ = try Workspace.command.execute(with: ["refresh", "scripts"]).get()
            _ = try Workspace.command.execute(with: ["refresh", "continuous‐integration"]).get()
        }
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
