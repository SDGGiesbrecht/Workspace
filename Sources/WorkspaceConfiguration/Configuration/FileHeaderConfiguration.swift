/*
 FileHeaderConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(FileHeaderConfiguration)
/// Einstellungen zu Dateivorspänne.
///
/// ```shell
/// $ arbeitsbereich auffrischen dateivorspänne
/// ```
///
/// Ein Dateivorspann ist eine Kommentarauschnitt am Anfang jeder Datei im Projekt. Typische Vorspänne...
///
/// - identifizieren das Projekt zu dem die Datei gehört.
/// - weisen auf dem Urheberrecht hin.
/// - weisen auf der Lizenz hin.
///
/// ### Präzise Festlegung eines Vorspanns
///
/// Weil Arbeitsbereich existierende Vorspänne überschreibt, ist es wichtig zu wissen, wie Arbeitsbereich Vorspänne erkennt.
///
/// Arbeitsbereich betrachtet jeden Kommentar am Dateianfang als Vorspann, mit folgender Begrenzungen:
///
/// Ein Dateivorspann kann ein einziger Blockkommentar sein:
///
/// ```swift
/// /*
///  Hier ist ein Vorspann.
///  Hier zählt auch zum Vorspann.
///  */
/// /* Hier zählt nicht zum Vorspann. */
/// ```
///
/// Andernfalls kann ein Vorspann eine lückenlose zusammenhängende Folge von Zeilenkommentare sein:
///
/// ```swift
/// // Hier ist ein Vorspann.
/// // Hier zählt auch zum Vorspann.
///
/// // Hier zählt nicht zum Vorspann.
/// ```
///
/// Dokumentationskommentare sind nie Vorspänne.
///
/// ```swift
/// /**
///  Hier ist kein Vorspann.
///  */
/// ```
///
/// In Schalenskripte, das Shebang kommt vor dem Vorspann und zählt nich dazu.
///
/// ```shell
/// #!/bin/bash ← Das zählt nicht zum Vorspann.
///
/// # Hier ist ein Vorspann.
/// ```
public typealias Dateivorspannseinstellungen = FileHeaderConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(FileHeaderConfiguration)
/// Options related to file headers.
///
/// ```shell
/// $ workspace refresh file‐headers
/// ```
///
/// A file header is a commented section at the top of each file in a project. Typical uses for file headers include:
///
/// - Identifing which project the file belongs to.
/// - Indicating copyright.
/// - Providing licence reminders.
///
/// ### Precise Definition of a File Header
///
/// Because Workspace overwrites existing file headers, it is important to know how Workspace identifies them.
///
/// Workspace considers any comment that starts a file to be a file header, with the following constraints:
///
/// A file header may be a single block comment:
///
/// ```swift
/// /*
///  This is a header.
///  This is more of the same header.
///  */
/// /* This is not part of the header. */
/// ```
///
/// Alternatively, a file header may be a continous sequence of line comments:
///
/// ```swift
/// // This is a header.
/// // This is more of the same header.
///
/// // This is not part of the header.
/// ```
///
/// Documentation comments are never headers.
///
/// ```swift
/// /**
///  This is not a header.
///  */
/// ```
///
/// In shell scripts, the shebang line precedes the header and is not part of it.
///
/// ```shell
/// #!/bin/bash ← This is not part of the header.
///
/// # This is a header
/// ```
public struct FileHeaderConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(FileHeaderConfiguration.manage)
  /// Whether or not to manage the project file headers.
  ///
  /// This is off by default.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(FileHeaderConfiguration.manage)
  /// Ob Arbeitsbereich Dateivorspänne verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇩🇪DE) @crossReference(FileHeaderConfiguration.copyrightNotice)
  /// Der Urheberrechtshinweis.
  ///
  /// Wenn nicht angegeben, wird diese Einstellung aus andere Dokumentations‐ und Lizenzeneinstellungen hergeleitet.
  ///
  /// Arbeitsbereich wird `#daten` mit die Urheberrechtsdaten der Datei ersetzen. (z. B. „©2016–2017“).
  ///
  /// ### Datenrechnung
  ///
  /// Arbeitsbereich verwendet das vorbestehende Anfangsdatum wenn der Vorspann schon Daten enthält. Arbeitsbereich sucht die Zeichenketten `©`, `(C)`, oder `(c)` aus, die von vier Ziffern gefolgt werden, und erkennt sie mit oder ohne ein Lehrzeichen inzwischen. Falls keine gefunden wird, verwendet Arbeitsbereich das aktuelle Datum als Anfangsdatum.
  ///
  /// Arbeitsbereich verwendet immer das aktuelle Datum als Enddatum.
  public var urheberrechtshinweis:
    BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>
  {
    get { return copyrightNotice }
    set { copyrightNotice = newValue }
  }
  // @localization(🇬🇧EN) @crossReference(FileHeaderConfiguration.copyrightNotice)
  /// The copyright notice.
  ///
  /// By default, this is assembled from the other documentation and licence options.
  ///
  /// Workspace will replace the dynamic element `#dates` with the file’s copyright dates. (e.g. ‘©2016–2017’).
  ///
  /// ### Determination of the Dates
  ///
  /// Workspace uses any pre‐existing start date if it can detect one already in the file header. Workspace searches for `©`, `(C)`, or `(c)` followed by an optional space and four digits. If none is found, Workspace will use the current date as the start date.
  ///
  /// Workspace always uses the current date as the end date.
  // @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(FileHeaderConfiguration.copyrightNotice)
  /// The copyright notice.
  ///
  /// By default, this is assembled from the other documentation and licence options.
  ///
  /// Workspace will replace the dynamic element `#dates` with the file’s copyright dates. (e.g. “©2016–2017”).
  ///
  /// ### Determination of the Dates
  ///
  /// Workspace uses any pre‐existing start date if it can detect one already in the file header. Workspace searches for `©`, `(C)`, or `(c)` followed by an optional space and four digits. If none is found, Workspace will use the current date as the start date.
  ///
  /// Workspace always uses the current date as the end date.
  public var copyrightNotice: Lazy<[LocalizationIdentifier: StrictString]> = Lazy<
    [LocalizationIdentifier: StrictString]
  >(resolve: { configuration in
    let packageName = StrictString(WorkspaceContext.current.manifest.packageName)
    return configuration.localizationDictionary { localization in
      let projectName = configuration.projectName[localization] ?? packageName
      if let author = configuration.documentation.primaryAuthor {
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Copyright #dates \(author) and the \(projectName) project contributors."
        case .deutschDeutschland:
          return
            "Urheberrecht #dates \(author) und die Mitwirkenden des \(projectName)‐Projekts."
        }
      } else {
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Copyright #dates the \(projectName) project contributors."
        case .deutschDeutschland:
          return "Urheberrecht #dates die Mitwirkenden des \(projectName)‐Projekts."
        }
      }
    }
  })

  // @localization(🇩🇪DE) @crossReference(FileHeaderConfiguration)
  /// Der ganze inhalt des Dateivorspanns.
  ///
  /// Wenn nicht angegeben, wird diese Einstellung aus andere Dokumentations‐ und Lizenzeneinstellungen hergeleitet.
  ///
  /// Arbeitsbereich ersetzt `#dateiname` mit dem Name der bestimmten Datei.
  public var inhalt: BequemeEinstellung<StrengeZeichenkette> {
    get { return contents }
    set { contents = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(FileHeaderConfiguration)
  /// The entire contents of the file header.
  ///
  /// By default, this is assembled from the other documentation and licence options.
  ///
  /// Workspace will replace the dynamic element `#filename` with the name of the particular file.
  public var contents: Lazy<StrictString> = Lazy<StrictString>(resolve: { configuration in

    let localizations = configuration.documentation.localizations
    let packageName = StrictString(WorkspaceContext.current.manifest.packageName)

    var header: [StrictString] = [
      "#filename",
      ""
    ]

    header.append(
      contentsOf: configuration.sequentialLocalizations({ localization in
        let projectName = configuration.projectName[localization] ?? packageName
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "This source file is part of the \(projectName) open source project."
        case .deutschDeutschland:
          return "Diese Quelldatei ist Teil des quelloffenen \(projectName)‐Projekt."
        }
      })
    )
    if let site = configuration.documentation.projectWebsite {
      header.append(StrictString(site.absoluteString))
    }

    header.append("")

    let copyrightNotices = configuration.fileHeaders.copyrightNotice.resolve(configuration)
    var orderedNotices = configuration.sequentialLocalizations(copyrightNotices)
    if orderedNotices.isEmpty {
      orderedNotices = ["#dates"]
    }
    header.append(contentsOf: orderedNotices)

    if configuration._isSDG {
      header.append("")
      header.append(
        contentsOf: configuration.sequentialLocalizations({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "Soli Deo gloria."
          }
        })
      )
    }

    if let licence = configuration.licence.licence {
      header.append(contentsOf: [
        "",
        licence.notice
      ])
    }

    return header.joinedAsLines()
  })
}
