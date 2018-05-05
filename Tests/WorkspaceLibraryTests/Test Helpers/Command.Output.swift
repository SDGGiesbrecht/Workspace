/*
 Command.Output.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

extension Command.Output {

    private enum MockLocalization : String, InputLocalization {
        case english = "en"
        static let fallbackLocalization: MockLocalization = .english
        static let cases: [MockLocalization] = [.english]
    }

    static var mock: Command.Output = {
        var result: Command.Output?
        do {
            try Command(name: UserFacingText<MockLocalization>({ _ in "" }), description: UserFacingText<MockLocalization>({ _ in "" }), directArguments: [], options: [], execution: { (_, _, output: Command.Output) in
                result = output
            }).execute(with: [])
        } catch {}
        return result!
    }()
}
