/*
 ValidationStatus.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

public struct ValidationStatus {

  // MARK: - Static Properties

  private static let passOrFailSymbol = UserFacingDynamic<
    StrictString, InterfaceLocalization, Bool
  >({ localization, passing in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
      .deutschDeutschland:
      return passing ? "✓" : "✗"
    }
  })

  // MARK: - Initialization

  public init() {}

  // MARK: - Properties

  private var passing: Bool = true

  private var summary: [StrictString] = []
  private var currentSection = 0

  // MARK: - Usage

  public mutating func newSection() -> ReportSection {
    currentSection += 1
    return ReportSection(number: currentSection)
  }

  public mutating func passStep(message: UserFacing<StrictString, InterfaceLocalization>) {
    summary.append(
      (ValidationStatus.passOrFailSymbol.resolved(using: true) + " " + message.resolved())
        .formattedAsSuccess()
    )
  }

  public mutating func failStep(message: UserFacing<StrictString, InterfaceLocalization>) {
    passing = false
    summary.append(
      (ValidationStatus.passOrFailSymbol.resolved(using: false) + " " + message.resolved())
        .formattedAsError()
    )
  }

  public var validatedSomething: Bool {
    return ¬summary.isEmpty
  }

  public func reportOutcome(project: PackageRepository, output: Command.Output) throws {
    output.print(StrictString(summary.joined(separator: "\n".scalars)).separated())

    try output.listWarnings(for: project)

    let projectName: StrictString = try project.localizedIsolatedProjectName(output: output)
    if passing {
      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return "‘" + projectName + "’ passes validation."
          case .englishUnitedStates, .englishCanada:
            return "“" + projectName + "” passes validation."
          case .deutschDeutschland:
            return "„" + projectName + "“ besteht die Überprüfung."
          }
        }).resolved().formattedAsSuccess().separated()
      )
    } else {
      throw Command.Error(
        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return "‘" + projectName + "’ fails validation."
          case .englishUnitedStates, .englishCanada:
            return "“" + projectName + "” fails validation."
          case .deutschDeutschland:
            return "„" + projectName + "“ besteht die Überprüfung nicht."
          }
        }),
        exitCode: 2
      )
    }
  }
}
