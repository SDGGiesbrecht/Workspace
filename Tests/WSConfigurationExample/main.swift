/*
 main.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @example(sampleConfiguration)
import WorkspaceConfiguration

/*
 Exernal packages can be imported with this syntax:
 import [module] // [url], [version], [product]
 */
import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow

let configuration = WorkspaceConfiguration()
configuration.optIntoAllTasks()

configuration.supportedPlatforms = [.macOS, .windows, .linux, .android]

configuration.documentation.currentVersion = Version(1, 0, 0)
configuration.documentation.projectWebsite = URL(string: "project.uk")
configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")

configuration.documentation.api.yearFirstPublished = 2017

configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
  resolve: { configuration in
    return [
      "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
      "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
      "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
      "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
      "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
    ]
  })

configuration.documentation.primaryAuthor = "John Doe"
// @endExample

// @beispiel(beispielskonfiguration)
import WorkspaceConfiguration

/*
 Externe Pakete sind mit dieser Syntax einführbar:
 import [Modul] // [Ressourcenzeiger], [Version], [Produkt]
 */
import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow

let konfiguration = ArbeitsbereichKonfiguration()
konfiguration.alleAufgabenEinschalten()

konfiguration.unterstützteSchichte = [.macOS, .windows, .linux, .android]

konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
konfiguration.dokumentation
  .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
konfiguration.dokumentation
  .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")

konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017

konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
  BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(auswerten: { konfiguration in
    return [
      "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
      "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
    ]
  })

konfiguration.dokumentation.hauptautor = "Max Mustermann"
// @beispielBeenden
