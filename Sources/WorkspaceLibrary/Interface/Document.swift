/*
 Document.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    enum Document {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "document"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "generates API documentation for the project."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (arguments: DirectArguments, options: Options, output: inout Command.Output) throws in

            _ = try Jazzy.default.execute(with: ["\u{2D}\u{2D}version"], output: &output)
            //_ = try Jazzy(version: Version(0, 8, 0)).execute(with: ["\u{2D}\u{2D}version"], output: &output)

            _ = try SwiftLint.default.execute(with: ["version"], output: &output)
            _ = try SwiftLint(version: Version(0, 23, 0)).execute(with: ["version"], output: &output)

            notImplementedYet()
        })
    }
}
