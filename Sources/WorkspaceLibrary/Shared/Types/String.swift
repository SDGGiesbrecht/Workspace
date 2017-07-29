/*
 String.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

typealias ScalarIndex = String.UnicodeScalarView.Index

extension String {

    static var crLF: String {
        return "\u{D}\u{A}"
    }

    var isWhitespace: Bool {
        return ¬scalars.contains(where: { $0 ∉ CharacterSet.whitespaces })
    }

    // MARK: - Searching for Token Pairs

    func range(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> Range<String.Index>? {
        return scalars.firstNestingLevel(startingWith: tokens.start.scalars, endingWith: tokens.end.scalars, in: searchRange?.sameRange(in: scalars))?.container.range.clusters(in: clusters)
    }

    func rangeOfContents(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> Range<String.Index>? {
        return scalars.firstNestingLevel(startingWith: tokens.start.scalars, endingWith: tokens.end.scalars, in: searchRange?.sameRange(in: scalars))?.contents.range.clusters(in: clusters)
    }

    func contents(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> String? {

        guard let targetRange = rangeOfContents(of: tokens, in: searchRange, requireWholeStringToMatch: requireWholeStringToMatch) else {
            return nil
        }

        return substring(with: targetRange)
    }

    mutating func replaceContentsOfEveryPair(of tokens: (start: String, end: String), with replacement: String, in searchRange: Range<Index>? = nil) {

        var possibleRemainder: Range<String.Index>? = searchRange ?? startIndex ..< endIndex

        while let remainder = possibleRemainder {
            if let range = rangeOfContents(of: tokens, in: remainder) {

                replaceSubrange(range, with: replacement)

                var location = range.lowerBound

                if ¬advance(&location, past: replacement)
                    ∨ ¬advance(&location, past: tokens.end) {
                    fatalError(message: [
                        "Failed to replace text.",
                        "This may indicate a bug in Workspace."
                        ])
                }
                possibleRemainder = location ..< endIndex
            } else {
                possibleRemainder = nil
            }
        }
    }

    // MARK: - Moving Indices

    func advance(_ index: inout Index, past string: String) -> Bool {

        var indexCopy = index
        var syncedIndex = string.startIndex
        for (ownCharacter, stringCharacter) in zip(substring(from: index).characters.lazy, string.characters.lazy) {

            if ownCharacter == stringCharacter {
                indexCopy = self.index(after: indexCopy)
                syncedIndex = string.index(after: syncedIndex)
            } else {
                return false
            }
        }
        if syncedIndex ≠ string.endIndex {
            // Not all of the string was present
            return false
        }

        index = indexCopy
        return true
    }

    private func advance(_ index: inout Index, past characters: CharacterSet, limit: Int?, advanceOne: (inout UnicodeScalarView.Index) -> Void) {

        var scalarIndex = index.samePosition(in: unicodeScalars)

        var iterationsCompleted = 0
        func notAtLimit() -> Bool {
            if let theLimit = limit {
                return iterationsCompleted < theLimit
            } else {
                return true
            }
        }
        while notAtLimit() ∧ index ≠ endIndex ∧ unicodeScalars[scalarIndex] ∈ characters {
            advanceOne(&scalarIndex)
            iterationsCompleted += 1
        }

        guard let converted = scalarIndex.samePosition(in: self) else {

            parseError(at: index, in: nil)
        }

        index = converted
    }

    func advance(_ index: inout Index, past characters: CharacterSet, limit: Int? = nil) {

        assert(limit == nil ∨ characters ≠ CharacterSet.newlines, join(lines: [
            "When counting newlines, CR + LF is not counted properly by String.advance(_:past:limit:).",
            "Use String.advance(_:pastNewlinesWithLimit:) instead."
            ]))

        advance(&index, past: characters, limit: limit, advanceOne: { $0 = unicodeScalars.index(after: $0) })
    }

    func advance(_ index: inout Index, pastNewlinesWithLimit limit: Int) {

        advance(&index, past: CharacterSet.newlines, limit: limit, advanceOne: { (mobileIndex: inout ScalarIndex) -> Void in

            if substring(with: mobileIndex.positionOfExtendedGraphemeCluster(in: self) ..< endIndex).hasPrefix(String.crLF) {
                mobileIndex = unicodeScalars.index(mobileIndex, offsetBy: 2)
            } else {
                mobileIndex = unicodeScalars.index(after: mobileIndex)
            }
        })
    }

    @discardableResult mutating func removeOneNewline(at index: Index) -> Bool {
        var position = index
        advance(&position, pastNewlinesWithLimit: 1)
        if position ≠ index {
            removeSubrange(index ..< position)
            return true
        } else {
            return false
        }
    }

    // MARK: - Errors

    func lineNumber(for index: String.UnicodeScalarView.Index) -> Int {
        return lines.distance(from: lines.startIndex, to: index.line(in: lines)) + 1
    }

    func lineNumber(for index: String.Index) -> Int {
        return lineNumber(for: index.samePosition(in: unicodeScalars))
    }

    func columnNumber(for index: String.UnicodeScalarView.Index) -> Int {
        let location = index.positionOfExtendedGraphemeCluster(in: self)
        let line = lineRange(for: location ..< location)
        return distance(from: line.lowerBound, to: location) + 1
    }

    func columnNumber(for index: String.Index) -> Int {
        return columnNumber(for: index.samePosition(in: unicodeScalars))
    }

    func locationInformation(for index: String.UnicodeScalarView.Index) -> String {
        return "Line \(lineNumber(for: index)), Column \(columnNumber(for: index))"
    }

    func locationInformation(for index: String.CharacterView.Index) -> String {
        return locationInformation(for: index.samePosition(in: unicodeScalars))
    }

    func parseError(at index: String.Index, in file: File?) -> Never {

        var duplicate = self
        duplicate.insert(contentsOf: "[Here]".characters, at: index)
        let range = duplicate.lineRange(for: index ..< index)
        let exerpt = duplicate.substring(with: range)

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
