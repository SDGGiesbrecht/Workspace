/*
 GitHubConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceLocalizations

// @localization(🇩🇪DE) @crossReference(GitHubConfiguration)
/// Einstellungen zu GitHub.
///
/// ```shell
/// $ arbeitsbereich auffrischen github
/// ```
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(GitHubConfiguration)
/// Options related to GitHub.
///
/// ```shell
/// $ workspace refresh github
/// ```
public struct GitHubConfiguration: Codable {

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(GitHubConfiguration.manage)
  /// Whether or not to manage the project’s GitHub configuration files.
  ///
  /// This is off by default.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.manage)
  /// Ob Arbeitsbereich die GitHub‐Konfigurationsdateien verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(GitHubConfiguration.manage)
  /// A list of the administrator’s GitHub usernames.
  public var administrators: [StrictString] = []
  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.manage)
  /// Eine Liste der Benutzernamen für die GitHub‐Verwalter.
  public var verwalter: [StrengeZeichenkette] {
    get { return administrators }
    set { administrators = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(GitHubConfiguration.developmentNotes)
  /// Project specific development notes.
  public var developmentNotes: Markdown?
  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.developmentNotes)
  /// Besondere Entwicklungshinweise zum Projekt.
  public var entwicklungshinweise: Markdown? {
    get { return developmentNotes }
    set { developmentNotes = newValue }
  }

  private static func contributingTemplate(
    for localization: LocalizationIdentifier
  ) -> StrictString? {
    guard let match = localization._reasonableMatch else {
      return nil
    }
    switch match {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return StrictString(Resources.contributingTemplate)
    case .deutschDeutschland:
      return StrictString(Resources.mitwirkenVorlage)
    }
  }

  private static func developmentNotesHeading(
    for localization: LocalizationIdentifier
  ) -> StrictString {
    switch localization._bestMatch {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Development Notes"
    case .deutschDeutschland:
      return "Enwicklungshinweise"
    }
  }

  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.contributingInstructions)
  /// Die Mitwirkungsanweisungen.
  ///
  /// Wenn nicht angegeben, wird diese Einstellung aus den anderen GitHub‐Einstellungen hergeleitet.
  ///
  /// Mitwirkungsanweisungen sind Anweisungen in einer `CONTRIBUTING.md`‐Datei, zu der GitHub neue Mitwirkende hinweist.
  public var mitwirkungsanweisungen: BequemeEinstellung<[Lokalisationskennzeichen: Markdown]> {
    get { return contributingInstructions }
    set { contributingInstructions = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(GitHubConfiguration.contributingInstructions)
  /// The contributing instructions.
  ///
  /// By default, this is assembled from the other GitHub options.
  ///
  /// Contributing instructions are instructions in a `CONTRIBUTING.md` file which GitHub directs contributors to read.
  public var contributingInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<
    [LocalizationIdentifier: Markdown]
  >(resolve: { configuration in
    var localizations = configuration.documentation.localizations
    if localizations.isEmpty {
      localizations.append(LocalizationIdentifier(ContentLocalization.fallbackLocalization))
    }

    var result: [LocalizationIdentifier: Markdown] = [:]
    for localization in localizations {
      if var template = GitHubConfiguration.contributingTemplate(for: localization) {

        #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
          template.replaceMatches(
            for: "#packageName".scalars.literal(),
            with: WorkspaceContext.current.manifest.packageName.scalars
          )
        #endif

        if let url = configuration.documentation.repositoryURL {
          template.replaceMatches(
            for: "#cloneScript".scalars.literal(),
            with: " `git clone https://github.com/user/\(url.lastPathComponent)`"
              .scalars
          )
        } else {
          template.replaceMatches(for: "#cloneScript".scalars.literal(), with: "".scalars)
        }

        let administrators = configuration.gitHub.administrators
        var administratorList: StrictString
        if administrators.isEmpty {
          switch localization._bestMatch {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            administratorList = "an administrator"
          case .deutschDeutschland:
            administratorList = "einem Verwalter"
          }
        } else if administrators.count == 1 {
          administratorList = administrators.first!
        } else {
          let separator: StrictString
          let finalSeparator: StrictString
          switch localization._bestMatch {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            separator = ", "
            finalSeparator = " or "
          case .deutschDeutschland:
            separator = ", "
            finalSeparator = " oder "
          }
          let commas = administrators.dropLast().joined(separator: separator)
          let or = finalSeparator + administrators.last!
          administratorList = commas + or
        }
        template.replaceMatches(for: "#administrators".scalars.literal(), with: administratorList)

        if let notes = configuration.gitHub.developmentNotes {
          template.append(
            contentsOf: [
              "",
              "## \(GitHubConfiguration.developmentNotesHeading(for: localization))",
              "",
              notes,
            ].joinedAsLines()
          )
        }

        result[localization] = template
      }
    }  // @exempt(from: tests) False positive with Swift 5.0.1.
    return result
  })

  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.issueTemplates)
  /// Die Themavorlagen.
  ///
  /// Wenn nicht angegeben, wird diese Einstellung aus den anderen GitHub‐Einstellungen hergeleitet.
  ///
  /// Eine Themavorlage ist eine Markdown‐Datei in einem `.github`‐Verzeichnis, die GitHub verwendet wenn jemand eine neue Thema erstellt.
  public var themavorlagen: BequemeEinstellung<[Lokalisationskennzeichen: [Themavorlage]]> {
    get { return issueTemplates }
    set { issueTemplates = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(GitHubConfiguration.issueTemplates)
  /// The issue templates.
  ///
  /// By default, these are assembled from the other GitHub options.
  ///
  /// An issue template is a markdown file in a `.github` folder which GitHub uses when someone creates a new issue.
  public var issueTemplates: Lazy<[LocalizationIdentifier: [IssueTemplate]]> = Lazy<
    [LocalizationIdentifier: [IssueTemplate]]
  >(resolve: { configuration in

    var localizations = configuration.documentation.localizations
    if localizations.isEmpty {
      localizations.append(
        LocalizationIdentifier(ContentLocalization.fallbackLocalization)
      )
    }

    var result: [LocalizationIdentifier: [IssueTemplate]] = [:]
    for localization in localizations {
      for providedTemplate in ProvidedIssueTemplate.allCases {
        if let language = localization._reasonableMatch {
          result[localization, default: []].append(
            providedTemplate.constructed(for: language)
          )
        }
      }
    }
    return result
  })

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(GitHubConfiguration.pullRequestTemplate)
  /// The pull request template.
  ///
  /// This defaults to a generic template.
  ///
  /// A pull request template is a markdown file in a `.github` folder which GitHub uses when someone creates a new pull request.
  public var pullRequestTemplate: Markdown = StrictString(Resources.pullRequestTemplate)
  // @localization(🇩🇪DE) @crossReference(GitHubConfiguration.pullRequestTemplate)
  /// Eine Abziehungsanforderungsvorlage.
  ///
  /// Wenn nicht angegeben, wird eine allgemeine Vorlage verwendet.
  ///
  /// Eine Abziehungsanforderungsvorlage ist eine Markdown‐Datei in einem `.github`‐Verzeichnis, die GitHub verwendet wenn jemand eine neue Abziehungsanforderung erstellt.
  public var abziehungsanforderungsvorlage: Markdown {
    get { return pullRequestTemplate }
    set { pullRequestTemplate = newValue }
  }
}
