/*
 PackageRepository.Target.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGMathematics
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftPackageManager

  import PackageModel
  import SwiftFormat

  import WorkspaceLocalizations

  extension PackageRepository {

    @available(macOS 10.15, *)
    internal struct Target: Comparable, Hashable {

      // MARK: - Initialization

      internal init(
        loadedTarget: PackageModel.Target,
        package: PackageRepository
      ) {
        self.loadedTarget = loadedTarget
        self.package = package
      }

      // MARK: - Properties

      internal let loadedTarget: PackageModel.Target
      private let package: PackageRepository

      internal var name: String {
        return loadedTarget.name
      }

      private var sourceDirectory: URL {
        return loadedTarget.sources.root.asURL
      }

      // MARK: - Resources

      internal func refresh(
        resources: [Resource],
        from package: PackageRepository,
        output: Command.Output
      ) throws {
        let resourceFileLocation = sourceDirectory.appendingPathComponent("Resources.swift")

        var source = String(try generateSource(for: resources, of: package))
        try SwiftLanguage.format(
          generatedCode: &source,
          accordingTo: try package.configuration(output: output),
          for: resourceFileLocation
        )

        var resourceFile = try TextFile(possiblyAt: resourceFileLocation)
        resourceFile.body = source

        try resourceFile.writeChanges(for: package, output: output)
      }

      private func generateSource(
        for resources: [Resource],
        of package: PackageRepository
      ) throws -> StrictString {
        let accessControl: String
        switch loadedTarget.type {
        case .library, .systemModule, .binary:
          accessControl = "internal "
        case .executable, .plugin, .test, .snippet:
          accessControl = ""
        }

        var source: StrictString = "import Foundation\n\n"

        let enumName = PackageRepository.Target.resourceNamespace.resolved(
          for: InterfaceLocalization.fallbackLocalization
        )
        source += "\(accessControl)enum " + enumName + " {}\n"

        var registeredAliases: Set<StrictString> = [enumName]
        for alias in InterfaceLocalization.allCases.map({
          PackageRepository.Target.resourceNamespace.resolved(for: $0)
        }) where alias ∉ registeredAliases {
          registeredAliases.insert(alias)
          source += "\(accessControl)typealias "
          source += alias
          source += " = "
          source += enumName
          source += "\n"
        }

        source.append(contentsOf: "\n")

        source.append(contentsOf: "extension Resources {\n".scalars)

        // #workaround(Swift 5.6.1, Standard accessor tripped by symlinks.)
        if resources.contains(where: { $0.deprecated == false }) {
          source.append(
            contentsOf: [
              "#if !os(WASI)",
              "  private static let moduleBundle: Bundle = {",
              "    let main = Bundle.main.executableURL?.resolvingSymlinksInPath().deletingLastPathComponent()",
              "    let module = main?.appendingPathComponent(\u{22}\(try self.package.packageName())_\(self.name).bundle\u{22})",
              "    return module.flatMap({ Bundle(url: $0) }) ?? Bundle.module",
              "  }()",
              "#endif",
            ].joined(separator: "\n")
          )
        }

        source.append(
          contentsOf: try namespaceTreeSource(
            for: resources,
            of: package,
            accessControl: accessControl
          ) + "\n"
        )

        source.append(contentsOf: "}\n".scalars)
        return source
      }

      private static let resourceNamespace = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Resources"
          case .deutschDeutschland:
            return "Ressourcen"
          }
        })

      private func namespaceTreeSource(
        for resources: [Resource],
        of package: PackageRepository,
        accessControl: String
      ) throws -> StrictString {
        return try source(
          for: namespaceTree(for: resources, of: package),
          accessControl: accessControl
        )
      }

      private func namespaceTree(
        for resources: [Resource],
        of package: PackageRepository
      ) -> [StrictString: Any] {
        var tree: [StrictString: Any] = [:]
        for resource in resources {
          add(components: resource.namespace[...], to: &tree, for: resource)
        }
        return tree
      }

      private func add(
        components: ArraySlice<StrictString>,
        to tree: inout [StrictString: Any],
        for resource: Resource
      ) {
        if ¬components.isEmpty {
          if components.count == 1 {
            tree[variableName(for: components.first!)] = resource
          } else {
            let name = SwiftLanguage.identifier(
              for: StrictString(components.first!),
              casing: .type
            )
            var branch = tree[name] as? [StrictString: Any] ?? [:]
            add(components: components.dropFirst(), to: &branch, for: resource)
            tree[name] = branch
          }
        }
      }

      private func variableName(for fileName: StrictString) -> StrictString {
        let nameOnly = URL(fileURLWithPath: "/" + String(fileName))
          .deletingPathExtension().lastPathComponent
        return SwiftLanguage.identifier(for: StrictString(nameOnly), casing: .variable)
      }

      private func source(
        for namespaceTree: [StrictString: Any],
        accessControl: String
      ) throws -> StrictString {
        var result: StrictString = ""
        for name in namespaceTree.keys.sorted() {
          try purgingAutoreleased {
            let value = namespaceTree[name]

            if let resource = value as? Resource {
              try result.append(
                contentsOf: source(for: resource, named: name, accessControl: accessControl)
                  + "\n"
              )
            } else if let namespace = value as? [StrictString: Any] {
              result.append(contentsOf: "\(accessControl)enum " + name + " {\n")
              result.append(contentsOf: try source(for: namespace, accessControl: accessControl))
              result.append(contentsOf: "}\n")
            } else {
              unreachable()
            }
          }
        }

        if result.scalars.last == "\n" {
          result.scalars.removeLast()
        }
        return result.lines.map({ (lineInformation) in
          return "  " + StrictString(lineInformation.line)
        }).joined(separator: "\n") + "\n"
      }

      private func source(
        for resource: Resource,
        named name: StrictString,
        accessControl: String
      ) throws -> StrictString {
        if ¬resource.deprecated,
          let loadName = resource.bundledName
        {
          return
            ([
              // #workaround(Swift 5.6.1, Some platforms do not support bundled resources yet.)
              "#if os(WASI)",
              try embeddedSource(for: resource, named: name, accessControl: accessControl),
              "#else",
              bundledSource(
                for: resource,
                named: name,
                loadName: loadName,
                accessControl: accessControl
              ),
              "#endif",
            ] as [StrictString]).joinedAsLines()
        } else {
          return try embeddedSource(for: resource, named: name, accessControl: accessControl)
        }
      }

      private func bundledSource(
        for resource: Resource,
        named name: StrictString,
        loadName: StrictString,
        accessControl: String
      ) -> StrictString {
        let resourceName: StrictString = "\u{22}\(loadName)\u{22}"
        let resourceExtension: StrictString
        if let bundledExtension = resource.bundledExtension {
          resourceExtension = "\u{22}\(bundledExtension)\u{22}"
        } else {
          resourceExtension = "nil"
        }
        let url: StrictString =
          "moduleBundle.url(forResource: \(resourceName), withExtension: \(resourceExtension))!"
        let data: StrictString = "try! Data(contentsOf: \(url), options: [.mappedIfSafe])"
        return accessor(
          for: resource,
          named: name,
          data: data,
          accessControl: accessControl
        )
      }

      private func embeddedSource(
        for resource: Resource,
        named name: StrictString,
        accessControl: String
      ) throws -> StrictString {

        let data = try Data(from: resource.origin)

        // #workaround(Swift 5.6.1, The compiler hangs for some platforms if long literals are used (Workspace’s own licence resources are big enough to trigger the problem).)
        let problematicLength: Int = 2 ↑ 15
        var unprocessed: Data.SubSequence = data[...]
        var sections: [Data.SubSequence] = []
        while ¬unprocessed.isEmpty {
          let prefix = unprocessed.prefix(problematicLength)
          sections.append(prefix)
          unprocessed.removeFirst(prefix.count)
        }

        var source: [StrictString] = sections.enumerated().lazy.map({ index, section in

          var byteArray = section.lazy
            .map({ byte in
              var hexadecimal = String(byte, radix: 16, uppercase: true)
              while hexadecimal.scalars.count < 2 {
                hexadecimal.scalars.prepend("0")
              }
              return "0x\(hexadecimal),"
            })
            .joined(separator: " ")
          // Creates some consistent line breaks, which is convenient if the files are checked in.
          byteArray.scalars.replaceMatches(for: "0, ".scalars, with: "0,\n".scalars)

          let variable = indexedVariable(name: name, index: index)
          return "private static let \(variable): [UInt8] = [\n\(byteArray)\n]"
        })

        let variables: StrictString = (0..<source.count).lazy.map({ index in
          return indexedVariable(name: name, index: index)
        }).joined(separator: ", ")

        source.append(
          accessor(
            for: resource,
            named: name,
            data: "Data(([\(variables)] as [[UInt8]]).lazy.joined())",
            accessControl: accessControl
          )
        )
        return source.joinedAsLines()
      }

      private func indexedVariable(name: StrictString, index: Int) -> StrictString {
        return "\(name)\(index.inDigits(thousandsSeparator: "_"))"
      }

      private func accessor(
        for resource: Resource,
        named name: StrictString,
        data: StrictString,
        accessControl: String
      ) -> StrictString {

        let constructor = resource.constructor
        let type = constructor.type
        let initializer = constructor.initializationFromData(data)

        return
          ([
            "\(accessControl)static var \(name): \(type) {",
            "  return \(initializer)",
            "}",
          ] as [StrictString]).joinedAsLines()
      }

      // MARK: - Comparable

      internal static func < (
        lhs: PackageRepository.Target,
        rhs: PackageRepository.Target
      ) -> Bool {
        return (lhs.name, lhs.sourceDirectory) < (rhs.name, rhs.sourceDirectory)
      }

      // MARK: - Equatable

      internal static func == (
        lhs: PackageRepository.Target,
        rhs: PackageRepository.Target
      ) -> Bool {
        return (lhs.name, lhs.sourceDirectory) == (rhs.name, rhs.sourceDirectory)
      }

      // MARK: - Hashable

      internal func hash(into hasher: inout Hasher) {
        hasher.combine(name)
      }
    }
  }
#endif
