/*
 ReportSection.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

public struct ReportSection {

  // MARK: - Initialization

  internal init(number: Int) {
    self.number = number
  }

  // MARK: - Properties

  private let number: Int

  // MARK: - Usage

  private var identifier: StrictString {
    return "§" + number.inDigits()
  }

  public var anchor: StrictString {
    return " (" + identifier + ")"
  }

  public var crossReference: UserFacing<StrictString, InterfaceLocalization> {
    let identifier = self.identifier
    return UserFacing({ localization in
      switch localization {
      case .englishUnitedKingdom:
        #if os(macOS)
          return " (See ⌘F ‘" + identifier + "’)"
        #elseif os(Windows) || os(Linux) || os(Android)
          return " (See Ctrl + F ‘" + identifier + "’)"
        #endif
      case .englishUnitedStates, .englishCanada:
        #if os(macOS)
          return " (See ⌘F “" + identifier + "”)"
        #elseif os(Windows) || os(Linux) || os(Android)
          return " (See Ctrl + F “" + identifier + "”)"
        #endif
      case .deutschDeutschland:
        #if os(macOS)
          return " (Siehe ⌘F „" + identifier + "“)"
        #elseif os(Windows) || os(Linux) || os(Android)
          return " (Siehe Strg + F „" + identifier + "“)"
        #endif
      }
    })
  }
}
