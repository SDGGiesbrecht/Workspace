/*
 File.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

struct File {

    static func managmentWarning(section: Bool, documentation: DocumentationLink) -> [String] {
        let place = section ? "section" : "file"
        return [
            "!!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!",
            "This \(place) is managed by Workspace.",
            "Manual changes will not persist.",
            "For more information, see:",
            documentation.url,
            "!!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!"
        ]
    }

    // MARK: - Initialization

    init(_ textFile: TextFile) {
        self.textFile = textFile
    }

    init<P : Path>(at path: P) throws {
        textFile = try TextFile(alreadyAt: URL(fileURLWithPath: Repository.absolute(path).string))
    }

    init<P : Path>(possiblyAt path: P, executable: Bool = false) {
        textFile = (try? TextFile(possiblyAt: URL(fileURLWithPath: Repository.absolute(path).string), executable: executable))!
    }

    // MARK: - Properties

    var textFile: TextFile

    var contents: String {
        get {
            return textFile.contents
        }
        set {
            textFile.contents = newValue
        }
    }

    var path: AbsolutePath {
        return AbsolutePath(textFile.location.path)
    }

    var isExecutable: Bool {
        return textFile.isExecutable
    }

    var fileType: FileType? {
        return FileType(filePath: AbsolutePath(textFile.location.path))
    }

    var syntax: FileSyntax? {
        return fileType?.syntax
    }

    // MARK: - File Header

    var header: String {
        get {
            return textFile.header
        }
        set {
            textFile.header = newValue
        }
    }

    var body: String {
        get {
            return textFile.body
        }
        set {
            textFile.body = newValue
        }
    }

    // MARK: - Writing

    func write(output: inout Command.Output) throws {
        try textFile.writeChanges(for: Repository.packageRepository, output: &output)
    }

    // MARK: - Handling Parse Errors

    func requireAdvance(index: inout String.Index, past string: String) {

        guard contents.clusters.advance(&index, over: string.clusters) else {

            string.parseError(at: index, in: self)
        }
    }

    func missingContentError(content: String, range: Range<String.Index>) -> Never {

        var message: [String] = [
            "Expected “\(content)” in:",
            path.string
            ]

        if range.lowerBound == contents.startIndex ∧ range.upperBound == contents.endIndex {
            // Whole file

            fatalError(message: message)
        }

        let appendix: [String] = [
            "Range:",
            content.locationInformation(for: range.lowerBound),
            content.locationInformation(for: range.upperBound)
            ]
        message.append(contentsOf: appendix)

        fatalError(message: message)
    }

    func requireRange(of searchTerm: String, in range: Range<String.Index>? = nil) -> Range<String.Index> {
        let rangeToSearch: Range<String.Index>
        if let searchRange = range {
            rangeToSearch = searchRange
        } else {
            rangeToSearch = contents.startIndex ..< contents.endIndex
        }

        if let result = contents.scalars.firstMatch(for: searchTerm.scalars, in: rangeToSearch.sameRange(in: contents.scalars))?.range.clusters(in: contents.clusters) {
            return result
        } else {
            missingContentError(content: searchTerm, range: rangeToSearch)
        }
    }

    private func require<T>(search: ((String, String)) -> T?, tokens: (String, String), range: Range<String.Index>?) -> T {

        if let result = search(tokens) {
            return result
        } else {
            missingContentError(content: "\(tokens.0)...\(tokens.1)", range: range ?? contents.startIndex ..< contents.endIndex)
        }
    }

    func requireRange(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> Range<String.Index> {

        return require(search: { contents.scalars.firstNestingLevel(startingWith: $0.0.scalars, endingWith: $0.1.scalars, in: searchRange?.sameRange(in: contents.scalars))?.container.range.clusters(in: contents.clusters) }, tokens: tokens, range: searchRange)
    }

    func requireRangeOfContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> Range<String.Index> {

        return require(search: { contents.scalars.firstNestingLevel(startingWith: $0.0.scalars, endingWith: $0.0.scalars, in: searchRange?.sameRange(in: contents.scalars))?.contents.range.clusters(in: contents.clusters) }, tokens: tokens, range: searchRange)
    }

    func requireContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> String {

        return require(search: {
            guard let result = contents.scalars.firstNestingLevel(startingWith: $0.0.scalars, endingWith: $0.1.scalars, in: searchRange?.sameRange(in: contents.scalars))?.contents.contents else {
                return nil
            }
            return String(result)
        }, tokens: tokens, range: searchRange)
    }
}
