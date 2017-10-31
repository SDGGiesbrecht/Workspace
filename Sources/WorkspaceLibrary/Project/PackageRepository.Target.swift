/*
 PackageRepository.Target.swift

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

    struct Target : Hashable {

        // MARK: - Initialization

        init(name: String, sourceDirectory: URL) {
            self.name = name
            self.sourceDirectory = sourceDirectory
        }

        // MARK: - Properties

        let name: String
        let sourceDirectory: URL

        // MARK: - Resources

        func refresh(resources: [URL], from package: PackageRepository, output: inout Command.Output) throws {
            var registeredNamespaces: Set<String> = []

            var resourceFile = try TextFile(possiblyAt: sourceDirectory.appendingPathComponent("Resources.swift"))

            for resource in resources.sorted() {
                var pathComponents = resource.path(relativeTo: package.location).components(separatedBy: "/").dropFirst(2)
                let fileName = pathComponents.removeLast()
                print(pathComponents)
            }

            try resourceFile.writeChanges(for: package, output: &output)
        }

        // MARK: - Equatable

        static func == (lhs: Target, rhs: Target) -> Bool {
            return (lhs.name, lhs.sourceDirectory) == (rhs.name, rhs.sourceDirectory)
        }

        // MARK: - Hashable

        var hashValue: Int {
            return name.hashValue
        }
    }
}
