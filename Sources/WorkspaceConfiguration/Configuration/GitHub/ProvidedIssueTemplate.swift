/*
 ProvidedIssueTemplate.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSLocalizations

internal enum ProvidedIssueTemplate: CaseIterable {

  // MARK: - Cases

  case bugReport
  case featureRequest
  case documentationCorrection
  case question

  // MARK: - Construction

  internal func constructed(for localization: ContentLocalization) -> IssueTemplate {
    let name: StrictString
    switch self {
    case .bugReport:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Bug Report"
      case .deutschDeutschland:
        name = "Fehlermeldung"
      }
    case .featureRequest:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Feature Request"
      case .deutschDeutschland:
        name = "Erweiterungswünsch"
      }
    case .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Documentation Correction"
      case .deutschDeutschland:
        name = "Dokumentationsberichtigung"
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Question"
      case .deutschDeutschland:
        name = "Frage"
      }
    }

    let description: StrictString
    switch self {
    case .bugReport:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        description = "Report a bug that needs fixing"
      case .deutschDeutschland:
        description = "Einen Programmfehler melden"
      }
    case .featureRequest:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        description = "Request a new feature that would be helpful"
      case .deutschDeutschland:
        description = "Ein neues Leistungsmerkmal anfordern, das hilfreich wäre"
      }
    case .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        description = "Report something incorrect or unclear in the documentation"
      case .deutschDeutschland:
        description = "Fehler oder Unklarheiten in der Dokumentation melden"
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        description = "Ask a question"
      case .deutschDeutschland:
        description = "Eine Frage stellen"
      }
    }

    var contents: [StrictString] = ["<!\u{2D}\u{2D}"]
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      contents.append(contentsOf: [
        " Reminder:",
        " Have you searched to see if a related issue exists already?",
        " If one exists, please add your information there instead."
      ])
    case .deutschDeutschland:
      contents.append(contentsOf: [
        " Erinnerung:",
        " Haben Sie die bereits bestehende Themen nach ähnliches durchsucht?",
        " Sollte etwas bereits bestehen, bitte melden Sie Eure Informationen dort."
      ])
    }
    contents.append(contentsOf: [
      " \u{2D}\u{2D}>",
      ""
    ])

    switch self {
    case .bugReport, .featureRequest, .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Description")
      case .deutschDeutschland:
        contents.append("### Beschreibung")
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Question")
      case .deutschDeutschland:
        contents.append("### Frage")
      }
    }
    contents.append("")

    switch self {
    case .bugReport:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("Such‐and‐such appears broken.")
      case .deutschDeutschland:
        contents.append("Soundso scheint fehlerhaft.")
      }
    case .featureRequest:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("Such‐and‐such would be a nice feature.")
      case .deutschDeutschland:
        contents.append("Soundso wäre ein ganz hilfreiches Merkmal.")
      }
    case .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append(
          "There appears to be a mistake in the documentation about such‐and‐such."
        )
      case .deutschDeutschland:
        contents.append(
          "In die Dokumentation über soundso gibt es anscheinend einen Fehler."
        )
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("How can I do such‐and‐such?")
      case .deutschDeutschland:
        contents.append("Wie kann ich soundso machen?")
      }
    }

    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    #if !os(WASI)
      if self == .bugReport {
        let products = WorkspaceContext.current.manifest.products
        contents.append("")
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          contents.append(contentsOf: [
            "### Demonstration"
          ])
        case .deutschDeutschland:
          contents.append(contentsOf: [
            "### Nachweis"
          ])
        }
        contents.append("")
        if products.contains(where: { $0.type == .executable }) {
          contents.append("```shell")
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            contents.append(contentsOf: [
              "$ this command •triggers \u{22}the bug\u{22}"
            ])
          case .deutschDeutschland:
            contents.append(contentsOf: [
              "$ dieser behehl •löst \u{22}den Fehler aus\u{22}"
            ])
          }
          contents.append(contentsOf: [
            "```",
            ""
          ])
        }
        if products.contains(where: { $0.type == .library }) {
          contents.append("```swift")
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            contents.append(contentsOf: [
              "let thisCode = trigger(theBug)"
            ])
          case .deutschDeutschland:
            contents.append(contentsOf: [
              "diese.quelltext = löst[denFehler].aus()"
            ])
          }
          contents.append(contentsOf: [
            "```",
            ""
          ])
        }
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          contents.append(
            "<!\u{2D}\u{2D} Or provide a link to a demonstration elsewhere. \u{2D}\u{2D}>"
          )
        case .deutschDeutschland:
          contents.append(
            "<!\u{2D}\u{2D} Oder einen Verweis bereitstellen, zum Nachweis sonstwo. \u{2D}\u{2D}>"
          )
        }
      }
    #endif

    switch self {
    case .bugReport, .featureRequest, .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        let task: StrictString
        switch self {
        case .bugReport, .documentationCorrection, .question:
          task = "fix"
        case .featureRequest:
          task = "implement"
        }
        contents.append(contentsOf: [
          "",
          "### Availability to Help",
          "",
          "<!\u{2D}\u{2D} Keep only one of the following lines. \u{2D}\u{2D}>",
          "I **would like to help** \(task) it, and I think **I know my way around**.",
          "I **would like to help** \(task) it, but **I would need some guidance**.",
          "I **would not like to help** \(task) it."
        ])
      case .deutschDeutschland:
        let task: StrictString
        switch self {
        case .bugReport, .documentationCorrection, .question:
          task = "zu beheben"
        case .featureRequest:
          task = "umzusetzen"
        }
        contents.append(contentsOf: [
          "",
          "### Hilfsbereitschaft",
          "",
          "<!\u{2D}\u{2D} Nur eine der folgenden Zeilen behalten. \u{2D}\u{2D}>",
          "Ich **möchte helfen**, es \(task), und ich glaube, **ich kenne mich aus**.",
          "Ich **möchte helfen**, es \(task), aber **ich braüchte etwas Anleitung**.",
          "Ich **möchte nicht helfen**, es \(task)."
        ])
      }
    case .question:
      break
    }

    contents.append("")
    switch self {
    case .bugReport:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Possible Solution")
      case .deutschDeutschland:
        contents.append("### Mögliche Lösung")
      }
    case .featureRequest:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Design Thoughts")
      case .deutschDeutschland:
        contents.append("### Gestaltungsgedanken")
      }
    case .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Recommended Correction")
      case .deutschDeutschland:
        contents.append("### Verbesserungsvorschlag")
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append("### Documentation Suggestion")
      case .deutschDeutschland:
        contents.append("### Dokumentationsvorschlag")
      }
    }
    switch self {
    case .bugReport, .featureRequest:
      contents.append("")
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append(contentsOf: [
          "It might work to do something like..."
        ])
      case .deutschDeutschland:
        contents.append(contentsOf: [
          "Eine Möglichkeit wäre ..."
        ])
      }
    case .documentationCorrection:
      contents.append("")
      switch localization {
      case .englishUnitedKingdom:
        contents.append(contentsOf: [
          "‘It makes more sense written like this.’"
        ])
      case .englishUnitedStates, .englishCanada:
        contents.append(contentsOf: [
          "“It makes more sense written like this.”"
        ])
      case .deutschDeutschland:
        contents.append(contentsOf: [
          "„So geschrieben wäre es verständlicher.“"
        ])
      }
    case .question:
      contents.append(contentsOf: [
        "",
        "<!\u{2D}\u{2D}"
      ])
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append(contentsOf: [
          " Where did you look for the answer?",
          " (Answering this may help us organize the documentation more intuitively.)"
        ])
      case .deutschDeutschland:
        contents.append(contentsOf: [
          " Wo haben Sie die Antwort gesucht?",
          " (Die Antwort auf dieser frage könnte uns helfen, die Dokumentation besser zu ordnen.)"
        ])
      }
      contents.append(contentsOf: [
        " \u{2D}\u{2D}>",
        ""
      ])
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        contents.append(contentsOf: [
          "I expected to find the answer under such‐and‐such."
        ])
      case .deutschDeutschland:
        contents.append(contentsOf: [
          "Ich erwartete, die Antwort unter soundso zu finden."
        ])
      }
    }

    var labels: [StrictString] = []
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      labels.append("🇬🇧🇺🇸🇨🇦EN")
    case .deutschDeutschland:
      labels.append("🇩🇪DE")
    }
    switch self {
    case .bugReport:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        labels.append("Bug")
      case .deutschDeutschland:
        labels.append("Programmfehler")
      }
    case .featureRequest:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        labels.append("Enhancement")
      case .deutschDeutschland:
        labels.append("Erweiterung")
      }
    case .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        labels.append("Documentation")
      case .deutschDeutschland:
        labels.append("Dokumentation")
      }
    case .question:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        labels.append("Question")
      case .deutschDeutschland:
        labels.append("Frage")
      }
    }
    switch self {
    case .bugReport, .featureRequest, .documentationCorrection:
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        labels.append("Needs Investigation")
      case .deutschDeutschland:
        labels.append("Benötigt Untersuchung")
      }
    case .question:
      break
    }

    return IssueTemplate(
      name: name,
      description: description,
      content: contents.joinedAsLines(),
      labels: labels
    )
  }
}
