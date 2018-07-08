/*
 PackageRepositoryTarget.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import SDGSwiftPackageManager

import WSProject
import WSSwift

import PackageDescription4
import PackageModel

extension PackageRepository {

    internal struct Target : Hashable {

        // MARK: - Initialization

        internal init(packageDescriptionTarget: PackageDescription4.Target, package: PackageRepository) {
            self.packageDescriptionTarget = packageDescriptionTarget
            self.package = package
        }

        // MARK: - Properties

        private let packageDescriptionTarget: PackageDescription4.Target
        private let package: PackageRepository

        internal var name: String {
            return packageDescriptionTarget.name
        }

        private var sourceDirectory: URL {
            if let path = packageDescriptionTarget.path {
                return URL(fileURLWithPath: path)
            } else {
                let base: URL
                if packageDescriptionTarget.isTest {
                    base = package.location.appendingPathComponent("Tests")
                } else {
                    base = package.location.appendingPathComponent("Sources")
                }
                return base.appendingPathComponent(name)
            }
        }

        // MARK: - Resources

        internal func refresh(resources: [URL], from package: PackageRepository, output: Command.Output) throws {

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
                    let name = SwiftLanguage.identifier(for: StrictString(components.first!), casing: .type)
                    var branch = tree[name] as? [StrictString: Any] ?? [:]
                    add(components: components.dropFirst(), to: &branch, for: resource)
                    tree[name] = branch
                }
            }
        }

        private func variableName(for fileName: String) -> StrictString {
            let nameOnly = URL(fileURLWithPath: "/" + fileName).deletingPathExtension().lastPathComponent
            return SwiftLanguage.identifier(for: StrictString(nameOnly), casing: .variable)
        }

        private func source(for namespaceTree: [StrictString: Any]) throws -> StrictString {
            var result: StrictString = ""
            for name in namespaceTree.keys.sorted(by: { $0.scalars.lexicographicallyPrecedes($1.scalars) }) {
                // [_Workaround: Simple “sorted” differs between operating systems. (Swift 4.1.2)_]
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

        internal static func == (lhs: PackageRepository.Target, rhs: PackageRepository.Target) -> Bool {
            return (lhs.name, lhs.sourceDirectory) == (rhs.name, rhs.sourceDirectory)
        }

        // MARK: - Hashable

        internal var hashValue: Int {
            return name.hashValue
        }
    }
}
