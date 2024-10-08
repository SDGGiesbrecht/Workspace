/*
 Command.Output.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

extension Command.Output {

  private enum MockLocalization: String, InputLocalization {
    case english = "en"
    static let fallbackLocalization: MockLocalization = .english
  }

  static var mock: Command.Output = {
    class SendableClass: @unchecked Sendable {
      fileprivate init() {}
      fileprivate var result: Command.Output?
    }
    let waiting = SendableClass()
    do {
      _ = try Command(
        name: UserFacing<StrictString, MockLocalization>({ _ in "" }),
        description: UserFacing<StrictString, MockLocalization>({ _ in "" }),
        directArguments: [],
        options: [],
        execution: { (_, _, output: Command.Output) in
          waiting.result = output
        }
      ).execute(with: []).get()
    } catch {}
    return waiting.result!
  }()
}
