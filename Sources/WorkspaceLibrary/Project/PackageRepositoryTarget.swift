/*
 PackageRepositoryTarget.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

import SDGSwift

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

        func refresh(resources: [URL], from package: PackageRepository, output: Command.Output) throws {

            var resourceFile = try TextFile(possiblyAt: sourceDirectory.appendingPathComponent("Resources.swift"))
            resourceFile.body = String(try generateSource(for: resources, of: package))
            try resourceFile.writeChanges(for: package, output: output)
        }

        private func generateSource(for resources: [URL], of package: PackageRepository) throws -> StrictString {
            var source: StrictString = "import Foundation\n\n"

            let enumName = PackageRepository.Target.resourceNamespace.resolved(for: InterfaceLocalization.fallbackLocalization)
            source += "internal enum " + enumName + " {}\n"

            var registeredAliases: Set<StrictString> = [enumName]
            for alias in InterfaceLocalization.cases.map({ PackageRepository.Target.resourceNamespace.resolved(for: $0) }) where alias ∉ registeredAliases {
                registeredAliases.insert(alias)
                source += "internal typealias "
                source += alias
                source += " = "
                source += enumName
                source += "\n"
            }

            source.append(contentsOf: "\n")

            source.append(contentsOf: "extension Resources {\n".scalars)

            source.append(contentsOf: (try namespaceTreeSource(for: resources, of: package)) + "\n")

            source.append(contentsOf: "}\n".scalars)
            return source
        }

        private static let resourceNamespace = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
            switch localization {
            case .englishCanada:
                return "Resources"
            }
        })

        private func namespaceTreeSource(for resources: [URL], of package: PackageRepository) throws -> StrictString {
            return try source(for: namespaceTree(for: resources, of: package))
        }

        private func namespaceTree(for resources: [URL], of package: PackageRepository) -> [StrictString: Any] {
            var tree: [StrictString: Any] = [:]
            for resource in resources {
                let pathComponentsArray = resource.path(relativeTo: package.location).components(separatedBy: "/").dropFirst(2).map({ String($0.contents) })
                let pathComponents = pathComponentsArray[pathComponentsArray.startIndex...]
                add(components: pathComponents, to: &tree, for: resource)
            }
            return tree
        }

        private func add(components: ArraySlice<String>, to tree: inout [StrictString: Any], for resource: URL) {
            if ¬components.isEmpty {
                if components.count == 1 {
                    tree[variableName(for: components.first!)] = resource
                } else {
                    let name = SwiftLanguage.default.identifier(for: StrictString(components.first!), casing: .type)
                    var branch = tree[name] as? [StrictString: Any] ?? [:]
                    add(components: components.dropFirst(), to: &branch, for: resource)
                    tree[name] = branch
                }
            }
        }

        private func variableName(for fileName: String) -> StrictString {
            let nameOnly = URL(fileURLWithPath: "/" + fileName).deletingPathExtension().lastPathComponent
            return SwiftLanguage.default.identifier(for: StrictString(nameOnly), casing: .variable)
        }

        private func source(for namespaceTree: [StrictString: Any]) throws -> StrictString {
            var result: StrictString = ""
            for name in namespaceTree.keys.sorted() {
                try autoreleasepool {
                    let value = namespaceTree[name]

                    if let resource = value as? URL {
                        try result.append(contentsOf: source(for: resource, named: name) + "\n")
                    } else if let namespace = value as? [StrictString: Any] {
                        result.append(contentsOf: "enum " + name + " {\n")
                        result.append(contentsOf: try source(for: namespace))
                        result.append(contentsOf: "}\n")
                    } else {
                        unreachable()
                    }
                }
            }

            if result.scalars.last == "\n" {
                result.scalars.removeLast()
            }
            return StrictString(result.lines.map({ (lineInformation) in
                return "    " + StrictString(lineInformation.line)
            }).joined(separator: "\n".scalars) + "\n")
        }

        private func source(for resource: URL, named name: StrictString) throws -> StrictString {
            let fileExtension = resource.pathExtension
            let initializer: (StrictString, StrictString)
            switch fileExtension {
            case "command", "md", "sh", "txt", "yml":
                initializer = ("String(data: ", ", encoding: String.Encoding.utf8)!")
            default:
                initializer = ("", "")
            }

            let data = try Data(from: resource)
            let string = data.base64EncodedString()
            var declaration: StrictString = "static let "
            declaration += name
            declaration += " = "
            declaration += initializer.0
            declaration += "Data(base64Encoded: \u{22}"
            declaration += string.scalars
            declaration += "\u{22})!"
            declaration += initializer.1
            return declaration
        }

        // MARK: - Equatable

        static func == (lhs: PackageRepository.Target, rhs: PackageRepository.Target) -> Bool {
            return (lhs.name, lhs.sourceDirectory) == (rhs.name, rhs.sourceDirectory)
        }

        // MARK: - Hashable

        var hashValue: Int {
            return name.hashValue
        }
    }
}
