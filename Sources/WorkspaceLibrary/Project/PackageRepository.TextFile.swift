/*
 PackageRepository.TextFile.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

extension PackageRepository {

    struct TextFile {

        // MARK: - Initialization

        init(alreadyAt location: URL) throws {
            let fileType = try FileType(url: location)

            let contents = try String(from: location)
            let executable = try location.resourceValues(forKeys: [.isExecutableKey]).isExecutable == true
            self.init(location: location, fileType: fileType, executable: executable, contents: contents, isNew: false)
        }

        init(possiblyAt location: URL, executable: Bool = false) throws {
            do {
                self = try TextFile(alreadyAt: location)
                if isExecutable ≠ executable {
                    isExecutable = executable
                    hasChanged = true
                }
            } catch {
                let fileType = try FileType(url: location)
                self = TextFile(location: location, fileType: fileType, executable: executable, contents: "", isNew: true)
            }
        }

        init(mockFileWithContents contents: String, fileType: FileType) {
            let temporary = FileManager.default.url(in: .temporary, at: "Mock File")
            self.init(location: temporary, fileType: fileType, executable: false, contents: contents, isNew: true)
        }

        private init(location: URL, fileType: FileType, executable: Bool, contents: String, isNew: Bool) {
            self.location = location
            self.isExecutable = executable
            self._contents = contents
            self.hasChanged = isNew
            self.fileType = fileType
        }

        // MARK: - Properties

        private class Cache {
            fileprivate var headerStart: String.ScalarView.Index?
            fileprivate var headerEnd: String.ScalarView.Index?
        }
        private var cache = Cache()

        private var hasChanged: Bool
        let location: URL

        var isExecutable: Bool {
            willSet {
                if newValue ≠ isExecutable {
                    hasChanged = true
                }
            }
        }

        let fileType: FileType

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
                    new.scalars.removeLast()
                }
                if ¬new.hasSuffix("\n") {
                    new.append("\n")
                }

                // Check for changes
                if ¬new.scalars.elementsEqual(contents.scalars) {
                    hasChanged = true
                    _contents = new
                }
            }
        }

        // MARK: - File Headers

        var headerStart: String.Index {

            return cached(in: &cache.headerStart) {
                () -> String.ScalarView.Index in

                return fileType.syntax.headerStart(file: self)
            }
        }

        var headerEnd: String.Index {

            return cached(in: &cache.headerEnd) {
                () -> String.ScalarView.Index in

                return fileType.syntax.headerEnd(file: self)
            }
        }

        var header: String {
            get {
                return fileType.syntax.header(file: self)
            }
            set {
                fileType.syntax.insert(header: newValue, into: &self)
            }
        }

        var body: String {
            get {
                return String(contents[headerEnd...])
            }
            set {
                var new = newValue
                // Remove unnecessary initial spacing
                while new.hasPrefix("\n") {
                    new.scalars.removeFirst()
                }

                let headerSource = String(contents[headerStart ..< headerEnd])
                if ¬headerSource.hasSuffix("\n") {
                    new = "\n" + new
                }
                if ¬headerSource.hasSuffix("\n\n") {
                    new = "\n" + new
                }

                contents.replaceSubrange(headerEnd ..< contents.endIndex, with: new)
            }

        }

        // MARK: - Writing

        func writeChanges(for repository: PackageRepository, output: inout Command.Output) throws {
            if hasChanged {
                print(UserFacingText<InterfaceLocalization, String>({ (localization, path) in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Writing to “\(path)”...")
                    }
                }).resolved(using: location.path(relativeTo: repository.location)))

                try contents.save(to: location)
                if isExecutable {
                    try FileManager.default.setAttributes([.posixPermissions: 0o777], ofItemAtPath: location.path)
                }

                repository.resetCache()
            }
        }
    }
}
