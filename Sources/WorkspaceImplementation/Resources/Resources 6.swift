/*
 Resources 6.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension Resources {
  internal static var gnuGeneralPublic3_0: String {
    return String(
      data: try! Data(
        contentsOf: moduleBundle.url(forResource: "GNU General Public 3.0", withExtension: "md")!,
        options: [.mappedIfSafe]
      ),
      encoding: String.Encoding.utf8
    )!
  }
}
