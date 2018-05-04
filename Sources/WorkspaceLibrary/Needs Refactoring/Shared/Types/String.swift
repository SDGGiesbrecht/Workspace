/*
 String.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation


typealias ScalarIndex = String.UnicodeScalarView.Index

extension String {

    var isWhitespace: Bool {
        return ¬scalars.contains(where: { $0 ∉ CharacterSet.whitespaces })
    }

    // MARK: - Errors

    func lineNumber(for index: String.UnicodeScalarView.Index) -> Int {
        return lines.distance(from: lines.startIndex, to: index.line(in: lines)) + 1
    }

    func columnNumber(for index: String.UnicodeScalarView.Index) -> Int {
        let location = index.cluster(in: clusters)
        let line = lineRange(for: location ..< location)
        return distance(from: line.lowerBound, to: location) + 1
    }

    func locationInformation(for index: String.UnicodeScalarView.Index) -> String {
        return "Line \(lineNumber(for: index)), Column \(columnNumber(for: index))"
    }

    func parseError(at index: String.Index, in file: File?) -> Never {

        var duplicate = self
        duplicate.insert(contentsOf: "[Here]".clusters, at: index)
        let range = duplicate.lineRange(for: index ..< index)
        let exerpt = String(duplicate[range])

        var message: [String] = [
            "A parse error occurred:",
            exerpt
        ]

        if let fileInfo = file {
            message.append(fileInfo.path.string)
        }

        message.append(contentsOf: [
            "",
            "This may indicate a bug in Workspace."
            ])

        fatalError(message: message)
    }
}
