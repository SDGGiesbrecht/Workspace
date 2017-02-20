/*
 DependencyGraph.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct DependencyGraph {

    static func updateDependencyGraph() {

        requireBash(["swift", "package", "update"])

        let dependencyFiles = Repository.allFiles(at: RelativePath("Packages"))
        var dependencies: [String: Version] = [:]
        for dependecyFile in dependencyFiles {
            guard let folderName = dependecyFile.string.contents(of: ("/", "/")) else {
                fatalError(message: [
                    "Failed to parse dependency data from path:",
                    "",
                    dependecyFile.string,
                    "",
                    "This may indicate a bug in Workspace."
                    ])
            }

            let parts = folderName.components(separatedBy: "-")
            guard parts.count == 2 else {
                fatalError(message: [
                    "Failed to parse dependency data from folder name:",
                    "",
                    folderName,
                    "",
                    "This may indicate a bug in Workspace."
                    ])
            }

            let name = parts[0]
            guard let version = Version(parts[1]) else {
                fatalError(message: [
                    "Failed to parse dependency version from folder name:",
                    "",
                    folderName,
                    "",
                    "This may indicate a bug in Workspace."
                    ])
            }

            dependencies[name] = version
        }

        var packageDescription = require() { try File(at: RelativePath("Package.swift")) }
        var body = packageDescription.body

        for (name, version) in dependencies {
            if let packageRange = body.range(of: (".Package(url: \u{22}", "\(name)\u{22}, versions: \u{22}")) {
                if let closingQuote = body.range(of: "\u{22}", in: packageRange.upperBound ..< body.endIndex) {
                    let versionRange = packageRange.upperBound ..< closingQuote.lowerBound

                    if let minimumVersion = Version(body[versionRange]) {
                        if minimumVersion < version {

                            body.replaceSubrange(versionRange, with: "\(version)")
                        }
                    }
                }
            }
        }

        packageDescription.body = body
        require() { try packageDescription.write() }
    }
}
