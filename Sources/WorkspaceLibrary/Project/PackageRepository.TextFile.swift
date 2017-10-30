/*
 TextFile.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

extension PackageRepository {

    struct TextFile {

        // MARK: - Initialization

        init(at location: URL) throws {
            let contents = try String(from: location)
            let executable = try location.resourceValues(forKeys: [.isExecutableKey]).isExecutable!
            self = TextFile(location: location, executable: executable, contents: contents, isNew: false)
        }

        init(possiblyAt location: URL, executable: Bool = false) {
            do {
                self = try TextFile(at: location)
                if isExecutable ≠ executable {
                    isExecutable = executable
                    hasChanged = true
                }
            } catch {
                self = TextFile(location: location, executable: executable, contents: "", isNew: true)
            }
        }

        private init(location: URL, executable: Bool, contents: String, isNew: Bool) {
            self.location = location
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
        let location: URL

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
    }
}
