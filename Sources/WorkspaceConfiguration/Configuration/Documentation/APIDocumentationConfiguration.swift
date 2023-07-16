/*
 APIDocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

// @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration)
/// Einstellungen zur Programmierschnittstellendokumentation.
public typealias Programmierschnittstellendokumentationseinstellungen =
  APIDocumentationConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(APIDocumentationConfiguration)
/// Options related to API documentation.
public struct APIDocumentationConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(APIDocumentationConfiguration.generate)
  /// Whether or not to generate API documentation.
  ///
  /// This is off by default.
  ///
  /// ```shell
  /// $ workspace document
  /// ```
  public var generate: Bool = false
  // @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration.generate)
  /// Ob Arbeitsbereich Programmierschnittstellendokumentation erstellen soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  ///
  /// ```shell
  /// $ arbeitsbereich dokumentieren
  /// ```
  public var erstellen: Bool {
    get { return generate }
    set { generate = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(APIDocumentationConfiguration.enforceCoverage)
  /// Whether or not to enforce documentation coverage.
  ///
  /// This is on by default.
  ///
  /// ```shell
  /// $ workspace validate documentation‐coverage
  /// ```
  public var enforceCoverage: Bool = true
  // @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration.enforceCoverage)
  /// Ob Arbeitsbereich Dokementationsabdeckung erzwingen soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung ein.
  ///
  /// ```shell
  /// $ arbeitsbereich prüfen dokumentationsabdeckung
  /// ```
  public var abdeckungErzwingen: Bool {
    get { return enforceCoverage }
    set { enforceCoverage = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(APIDocumentationConfiguration.yearFirstPublished)
  /// The year the documentation was first published.
  ///
  /// This will be used as the lower bound when generating copyright dates. (The upper bound will always be the present.)
  public var yearFirstPublished: GregorianYear?
  // @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration.yearFirstPublished)
  /// Das Jahr, in dem die Dokumentation zum ersten mal veröffentlicht wurde.
  ///
  /// Dies wird als untere Grenze verwendet, wenn die Urheberrechtsdaten erstellt werden. (Die obere Grenze ist immer die Gegenwart.)
  public var jahrErsterVeröffentlichung: GregorianischesJahr? {
    get { return yearFirstPublished }
    set { yearFirstPublished = newValue }
  }

  // @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration.copyrightNotice)
  /// Der Urheberrechtsschutzvermerk.
  ///
  /// Wenn nicht angegeben, wird diese Einstellung von dem des Dateivorspanns hergeleitet.
  ///
  /// Arbeitsbereich wird das dynamische Element `#daten` mit die berechnete Urheberrechtsdaten ersetzen. (z. B. „©2016–2017“).
  public var urheberrechtsschutzvermerk:
    BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>
  {
    get { return copyrightNotice }
    set { copyrightNotice = newValue }
  }
  // @localization(🇬🇧EN) @crossReference(APIDocumentationConfiguration.copyrightNotice)
  /// The copyright notice.
  ///
  /// By default, this is assembled from the file header copyright notice.
  ///
  /// Workspace will replace the dynamic element `#dates` with the computed copyright dates. (e.g. ‘©2016–2017’).
  // @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(APIDocumentationConfiguration.copyrightNotice)
  /// The copyright notice.
  ///
  /// By default, this is assembled from the file header copyright notice.
  ///
  /// Workspace will replace the dynamic element `#dates` with the computed copyright dates. (e.g. “©2016–2017”).
  public var copyrightNotice: Lazy<[LocalizationIdentifier: StrictString]> = Lazy<
    [LocalizationIdentifier: StrictString]
  >(resolve: { configuration in
    return configuration.fileHeaders.copyrightNotice.resolve(configuration)
      .mapKeyValuePairs { localization, notice in
        if let provided = localization._reasonableMatch {
          switch provided {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return (localization, notice + " All rights reserved.")
          case .deutschDeutschland:
            return (localization, notice + " Alle rechte vorbehalten.")
          }
        } else {
          return (localization, notice)
        }
      }
  })

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(APIDocumentationConfiguration.serveFromGitHubPagesBranch)
  /// Whether or not to automatically serve the documentation using GitHub Pages.
  ///
  /// By setting this to `true`, projects with continuous integration management active can avoid checking generated files into the main branch.
  ///
  /// Workspace will only generate documentation in continuous integration and stop generating it locally. (If needed for coverage checks, Workspace may still do so in a temporary directory.) The generated documentation will be automatically published to GitHub Pages via the gh&#x2D;pages branch, making the `docs` directory unnecessary.
  public var serveFromGitHubPagesBranch: Bool = false
  // @localization(🇩🇪DE) @crossReference(APIDocumentationConfiguration.serveFromGitHubPagesBranch)
  /// Ob Arbeitsbereich die Dokumentation automatisch durch GitHub Seiten veröffentlichen soll.
  ///
  /// Mit dieser Einstellung eingeschalltet, Projekte mit aktivierten Verwaltung von fortlaufenden Einbindung können das Eintragen der erstellten Dateien zur Hauptzweig vermeiden.
  ///
  /// Arbeitsbereich wird die Dokumentation nur während fortlaufenden Einbindung erstellen, und aufhören, es auf lokalen Geräte zu erstellen. (Falls es für Abdeckungsprüfungen benötigt wird, erstellt es Arbeitsbereich nur in eine vorübergehende Verzeichnis.) Die erstellte Dokumentation wird automatisch zu GitHub Pages durch den gh&#x2D;pages Zweig, damit das `docs` Verzeichnis unnötig wird.
  public var durchGitHubSeitenVeröffentlichen: Bool {
    get { return serveFromGitHubPagesBranch }
    set { serveFromGitHubPagesBranch = newValue }
  }
}
