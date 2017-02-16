/*
 Command.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Command: String, Comparable, CustomStringConvertible, LosslessStringConvertible {

    // MARK: - Initialization

    static let current: Command = {
        if CommandLine.arguments.count > 1 {
            let name = CommandLine.arguments[1]
            if let command = Command(name) {
                return command
            } else {
                inputSyntaxError(message: "Unrecognized command: “\(name)”.")
            }
        } else {
            inputSyntaxError(message: "No command.")
        }
    }()

    // MARK: - Cases

    case initialize
    case refresh
    case proofread
    case validate

    static let all: [Command] = [
        .initialize,
        .refresh,
        .proofread,
        .validate
        ]

    static let allNames: [String] = all.map() { $0.name }

    // MARK: - Usage

    var name: String {
        return rawValue
    }

    func run(andExit shouldExit: Bool = false) {
        switch self {
        case .initialize:
            runInitialize(andExit: shouldExit)
        case .refresh:
            runRefresh(andExit: shouldExit)
        case .proofread:
            let _ = runProofread(andExit: shouldExit)
        case .validate:
            runValidate(andExit: shouldExit)
        }
    }

    // MARK: - Comparable

    static func < (lhs: Command, rhs: Command) -> Bool {
        return lhs.name < rhs.name
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return name
    }

    // MARK: - LosslessStringConvertible

    init?(_ string: String) {
        self.init(rawValue: string)
    }
}
