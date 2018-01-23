/*
 XcodeProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

class XcodeProofreadingReporter : ProofreadingReporter {

    // MARK: - Static Properties

    static let `default` = XcodeProofreadingReporter()

    // MARK: - Initialization

    private init() {

    }

    // MARK: - ProofreadingReporter
    
    func reportParsing(file: String, to output: inout Command.Output) {
        // Unneeded.
    }

    func report(violation: StyleViolation, to output: inout Command.Output) {

        // [_Warning: Needs updating and testing once build succeeds again._]
        /*
        let location = file.location
        let lineNumber = file.contents.lineNumber(for: clusterRange.lowerBound)
        let column = file.contents.columnNumber(for: clusterRange.lowerBound)

        let lineRange = file.contents.lineRange(for: clusterRange)
        var line = String(file.contents[lineRange])
        if line.hasSuffix(String.crLF) {
            line.unicodeScalars.removeLast()
        }
        line.unicodeScalars.removeLast()

        let previousDistance = file.contents.distance(from: lineRange.lowerBound, to: clusterRange.lowerBound)
        let previous = String(repeating: " ", count: previousDistance)

        let markedDistance = file.contents.distance(from: clusterRange.lowerBound, to: clusterRange.upperBound)
        let marked = "^" + String(repeating: "~", count: markedDistance − 1)

        var output = [
            "\(path):\(lineNumber):\(column): warning: \(message) (\(name))",
            line,
            previous + marked
        ]
        if let replacement = clusterReplacement {
            output += [previous + replacement]
        }
        output += [""] // Final line break

         if ¬noticeOnly {
         status = false
         }
         if CommandLine.arguments[1] ≠ "proofread" {
         let colour: OutputColour
         if noticeOnly {
         colour = .yellow
         } else {
         colour = .red
         }
         print(output, in: colour, spaced: true)
         } else {
         let standardError = FileHandle.standardError
         standardError.write(output.joinAsLines().data(using: String.Encoding.utf8)!)
         }
        */
    }
}
