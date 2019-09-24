/*
 SDGSwift.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGSwift 0.13.0, Belongs in SDGSwift.)

import SDGLogic
import WSGeneralImports

import SDGSwift

extension PackageRepository {
    internal func ignoredFiles() -> Swift.Result<[Foundation.URL], SDGSwift.Git.Error> {
        return Git.ignoredFiles(in: self)
    }
}

extension Git {
    fileprivate static func ignoredFiles(in repository: PackageRepository) -> Result<[URL], Git.Error> {

        return runCustomSubcommand([
            "status",
            "\u{2D}\u{2D}ignored",
            "\u{2D}\u{2D}porcelain"
            ], in: repository.location).map { ignoredSummary in
                let indicator = Array("!! ".scalars)
                var result: [URL] = []
                for line in ignoredSummary.lines.lazy.map({ $0.line })
                    where line.hasPrefix(indicator) {
                        let relativePath = String(line.dropFirst(indicator.count))
                        result.append(repository.location.appendingPathComponent(relativePath))
                }
                return result
        }
    }
}
