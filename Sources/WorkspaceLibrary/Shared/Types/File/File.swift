/*
 File.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

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

    init<P : Path>(at path: P) throws {
        let file = try Repository._read(file: path)
        self = File(path: path, executable: file.isExecutable, contents: file.contents, isNew: false)
    }

    init<P : Path>(possiblyAt path: P, executable: Bool = false) {
        do {
            self = try File(at: path)
            if isExecutable ≠ executable {
                isExecutable = executable
                hasChanged = true
            }
        } catch {
            self = File(path: path, executable: executable, contents: "", isNew: true)
        }
    }

    /// For testing only
    init<P : Path>(_path: P, _contents: String) {
        self = File(path: _path, executable: false, contents: _contents, isNew: true)
    }

    private init<P : Path>(path: P, executable: Bool, contents: String, isNew: Bool) {
        self.path = Repository.absolute(path)
        self.isExecutable = executable
        self._contents = contents
        self.hasChanged = isNew
    }

    // MARK: - Properties

    private class Cache {
        fileprivate var headerStart: String.Index?
        fileprivate var headerEnd: String.Index?
    }
    private var cache = Cache()

    private var hasChanged: Bool
    let path: AbsolutePath

    var isExecutable: Bool {
        willSet {
            if newValue ≠ isExecutable {
                hasChanged = true
            }
        }
    }

    private var _contents: String {
        willSet {
            cache = Cache()
        }
    }
    var contents: String {
        get {
            return _contents
        }
        set {
            var new = newValue

            // Ensure singular final newline
            while new.hasSuffix("\n\n") {
                new.unicodeScalars.removeLast()
            }
            if ¬new.hasSuffix("\n") {
                new.append("\n")
            }

            // Check for changes
            if ¬new.unicodeScalars.elementsEqual(contents.unicodeScalars) {
                hasChanged = true
                _contents = new
            }
        }
    }

    var fileType: FileType? {
        return FileType(filePath: path)
    }

    var syntax: FileSyntax? {
        return fileType?.syntax
    }

    // MARK: - File Headers

    var headerStart: String.Index {

        return cached(in: &cache.headerStart) {
            () -> String.Index in

            if let parser = syntax {
                return parser.headerStart(file: self)
            } else {
                return contents.startIndex
            }
        }
    }

    var headerEnd: String.Index {

        return cached(in: &cache.headerEnd) {
            () -> String.Index in

            if let parser = syntax {

                return parser.headerEnd(file: self)

            } else {
                return headerStart
            }
        }
    }

    func fatalFileTypeError() -> Never {
        fatalError(message: [
            "Unsupported file type:",
            path.string,
            "",
            "This may indicate a bug in Workspace."
            ])
    }

    var header: String {
        get {
            guard let parser = syntax else {
                fatalFileTypeError()
            }
            return parser.header(file: self)
        }
        set {
            guard let constructor = syntax else {
                fatalFileTypeError()
            }
            constructor.insert(header: newValue, into:
                &self)
        }
    }

    var body: String {
        get {
            return contents.substring(from: headerEnd)
        }
        set {
            var new = newValue
            // Remove unnecessary initial spacing
            while new.hasPrefix("\n") {
                new.unicodeScalars.removeFirst()
            }

            let headerSource = contents.substring(with: headerStart ..< headerEnd)
            if ¬headerSource.hasSuffix("\n") {
                new = "\n" + new
            }
            if ¬headerSource.hasSuffix("\n\n") {
                new = "\n" + new
            }

            contents.replaceSubrange(headerEnd ..< contents.endIndex, with: new)
        }

    }

    // MARK: - Handling Parse Errors

    func requireAdvance(index: inout String.Index, past string: String) {

        guard contents.advance(&index, past: string) else {

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

        return require(search: { contents.range(of: $0, in: searchRange) }, tokens: tokens, range: searchRange)
    }

    func requireRangeOfContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> Range<String.Index> {

        return require(search: { contents.rangeOfContents(of: $0, in: searchRange) }, tokens: tokens, range: searchRange)
    }

    func requireContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> String {

        return require(search: { contents.contents(of: $0, in: searchRange) }, tokens: tokens, range: searchRange)
    }

    // MARK: - Writing

    func write() throws {
        if hasChanged {
            if let relative = Repository.relative(path) {
                print("Writing to “\(relative)”...")
            } else {
                print("Writing to “\(path)”...")
            }

            try Repository._write(file: contents, to: path, asExecutable: isExecutable)
        }
    }
}
