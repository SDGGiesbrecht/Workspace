/*
 PackageRepository.swift

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

    // MARK: - Cache

    private class Cache {
        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
    }
    private static var caches: [URL: Cache] = [:]

    // MARK: - Structure

    var targets: [Target] {
        notImplementedYetAndCannotReturn()
    }

    // MARK: - Files

    func allFiles() throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].allFiles) {
            () -> [URL] in

            var failureReason: Error? // Thrown after enumeration stops. (See below.)
            guard let enumerator = FileManager.default.enumerator(at: location, includingPropertiesForKeys: [.isDirectoryKey], options: [], errorHandler: { (_, error: Error) -> Bool in
                failureReason = error
                return false // Stop.
            }) else {
                throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Cannot enumerate the project files."
                    }
                }))
            }

            var result: [URL] = []
            for object in enumerator {
                guard let url = object as? URL else {
                    throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishCanada:
                            return StrictString("Unexpected \(type(of: object)) encountered while enumerating project files.")
                        }
                    }))
                }

                if ¬(try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory!, // Skip directories.
                    url.lastPathComponent ≠ ".DS_Store", // Skip irrelevant operating system files.
                    ¬url.path.hasSuffix("~") {
                    
                    result.append(url)
                }
            }

            if let error = failureReason {
                throw error
            }

            return result
        }
    }
    
    func trackedFiles() throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].trackedFiles) {
            () -> [URL] in
            
            notImplementedYet()
            return try allFiles()
        }
        /*
        var cacheCopy = cache
        defer { cache = cacheCopy }
        
        return cached(in: &cacheCopy.trackedFiles) {
            () -> [RelativePath] in
         
            let ignoredSummary = requireBash(["git", "status", "\u{2D}\u{2D}ignored"], silent: true)
            var ignoredPaths: [String] = [
                ".git/"
            ]
            if let header = ignoredSummary.range(of: "Ignored files:") {
         
                let remainder = String(ignoredSummary[header.upperBound...])
                for line in remainder.lines.lazy.dropFirst(3).map({ String($0.line) }) {
                    if line.isWhitespace {
                        break
                    } else {
                        var start = line.scalars.startIndex
                        line.scalars.advance(&start, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
                        ignoredPaths.append(String(line.scalars.suffix(from: start)))
                    }
                }
         
            }
         
            let result = allRealFiles.filter() { (path: RelativePath) -> Bool in
         
                for ignored in ignoredPaths {
                    if path.string.hasPrefix(ignored) {
                        return false
                    }
                }
                return true
            }
         
            return result
        }*/
    }

    // MARK: - Resources

    func refreshResources() throws {
        print(join(lines: try trackedFiles().map({ $0.path })))
        notImplementedYet()
    }
}
