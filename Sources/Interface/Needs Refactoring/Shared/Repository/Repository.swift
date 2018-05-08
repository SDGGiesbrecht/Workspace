/*
 Repository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

struct Repository {

    // MARK: - Bridging

    static let packageRepository = PackageRepository(at: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))

    static func paths(from urls: [URL]) -> [RelativePath] {
        return urls.map { (url) in
            return RelativePath(url.path(relativeTo: packageRepository.location))
        }
    }

    static var standInOutput: Command.Output = {
        var result: Command.Output?
        _ = try? Command(name: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }), description: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }), directArguments: [], options: [], execution: { (_, _, output: Command.Output) in
            result = output
        }).execute(with: [])
        return result!
    }()

    // MARK: - Constants

    private static let fileManager = FileManager.default
    static let repositoryPath: AbsolutePath = AbsolutePath(fileManager.currentDirectoryPath)
    static let folderName = URL(fileURLWithPath: repositoryPath.string).lastPathComponent
    static let root: RelativePath = RelativePath("")

    // MARK: - Repository

    static var allFiles: [RelativePath] {
        let urls = require { try packageRepository.allFiles() }
        return paths(from: urls)
    }

    static var trackedFiles: [RelativePath] {
        let urls = require { try packageRepository.trackedFiles(output: standInOutput) }
        return paths(from: urls)
    }

    static var sourceFiles: [RelativePath] {
        let urls = require { try packageRepository.sourceFiles(output: standInOutput) }
        return paths(from: urls)
    }

    private static func path(_ possiblePath: RelativePath, isIn path: RelativePath) -> Bool {

        if path == Repository.root {
            return true
        }

        if possiblePath == path {
            // The file itself
            return true
        }

        if possiblePath.string.hasPrefix(path.string + "/") {
            // In that folder.
            return true
        }

        return false
    }

    static func allFiles(at path: RelativePath) -> [RelativePath] {
        return allFiles.filter { (possiblePath: RelativePath) -> Bool in

            return Repository.path(possiblePath, isIn: path)
        }
    }

    // MARK: - Files

    static func unsupportedPathType() -> Never {
        fatalError(message: [
            "Unsupported path type.",
            "This may indicate a bug in Workspace."
            ])
    }

    static func absolute<P : Path>(_ path: P) -> AbsolutePath {
        if let absolute = path as? AbsolutePath {
            return absolute
        } else if let relative = path as? RelativePath {
            return repositoryPath.subfolderOrFile(relative.string)
        } else {
            unsupportedPathType()
        }
    }

    static func relative<P : Path>(_ path: P) -> RelativePath? {
        if let relative = path as? RelativePath {
            return relative
        } else if let absolute = path as? AbsolutePath {

            let pathString = absolute.string

            let root = Repository.absolute(Repository.root).string
            var startIndex = pathString.startIndex
            if pathString.clusters.advance(&startIndex, over: root.clusters) {
                return RelativePath(String(pathString[startIndex...]))
            } else {
                return nil
            }

        } else {
            unsupportedPathType()
        }
    }

    // MARK: - File Actions

    static func delete<P : Path>(_ path: P) throws {

        defer {
            Repository.packageRepository.resetCache(debugReason: relative(path)?.string ?? "delete")
        }

        #if os(Linux)
            // [_Workaround: Skip unavailable catching of NSErrors on Linux. (Swift 3.0.2)_]
            // Linux crashes if it attempts to catch the error.
            try? fileManager.removeItem(atPath: absolute(path).string)
        #else
            do {
                try fileManager.removeItem(atPath: absolute(path).string)
            } catch let error as NSError {

                if let POSIX = (error.userInfo[NSUnderlyingErrorKey] as? NSError),
                    POSIX.domain == NSPOSIXErrorDomain,
                    POSIX.code == 2 /* No such file or directory. */ {

                    return
                }
            }
        #endif
    }

    private static func prepareForWrite<P : Path>(path: P) {

        try? delete(path)

        try? fileManager.createDirectory(atPath: absolute(path).directory, withIntermediateDirectories: true, attributes: nil)
    }

    // MARK: - Linked Repositories

    static func linkedRepository(from url: URL) -> PackageRepository {
        let name = Repository.nameOfLinkedRepository(atURL: url.absoluteString)
        let repositoryLocation = URL(fileURLWithPath: linkedRepository(named: name).string)
        let repository = PackageRepository(at: repositoryLocation)
        return repository
    }

    static func nameOfLinkedRepository(atURL url: String) -> String {
        guard let urlObject = URL(string: url) else {
            fatalError(message: [
                "Invalid URL:",
                "",
                url
                ])
        }

        let name = urlObject.lastPathComponent

        let repository = Workspace.linkedRepositories.subfolderOrFile(name)

        if ¬fileManager.fileExists(atPath: absolute(repository).string) {
            prepareForWrite(path: repository)
            try? fileManager.do(in: URL(fileURLWithPath: Workspace.linkedRepositories.string)) {
                requireBash(["git", "clone", url])
            }
        }

        try? fileManager.do(in: URL(fileURLWithPath: repository.string)) {
            requireBash(["git", "pull"], silent: true)
        }

        return name
    }

    static func linkedRepository(named name: String) -> AbsolutePath {
        return Workspace.linkedRepositories.subfolderOrFile(name)
    }
}
