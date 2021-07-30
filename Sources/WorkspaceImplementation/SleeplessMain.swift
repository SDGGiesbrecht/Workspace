/*
 SleeplessMain.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
#if !PLATFORM_LACKS_DISPATCH
  import Dispatch
#endif

import SDGText
import SDGLocalization

import WorkspaceLocalizations
import WorkspaceProjectConfiguration

public struct SleeplessMain {

  #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
    public static func main() {  // @exempt(from: tests)
      #if !PLATFORM_LACKS_DISPATCH
        DispatchQueue.global(qos: .utility).sync {

          #if os(Windows) || os(Linux) || os(Android)
            Workspace.main()
          #else
            let reason = UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Workspace"
              case .deutschDeutschland:
                return "Arbeitsbereich"
              }
            })
            ProcessInfo.processInfo.performActivity(
              options: [.userInitiated, .idleSystemSleepDisabled],
              reason: String(reason.resolved())
            ) {
              Workspace.main()
            }
          #endif
        }
      #endif
    }
  #endif
}
