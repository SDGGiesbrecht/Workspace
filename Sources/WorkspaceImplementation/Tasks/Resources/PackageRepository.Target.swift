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

      private let loadedTarget: PackageModel.Target
      private let package: PackageRepository

      internal var name: String {
        return loadedTarget.name
      }

      private var sourceDirectory: URL {
        return loadedTarget.sources.root.asURL
      }

      // MARK: - Resources

      internal func refresh(
        resources: [URL],
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
        for resources: [URL],
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

        source.append(
          contentsOf: (try namespaceTreeSource(
            for: resources,
            of: package,
            accessControl: accessControl
          )) + "\n"
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
        for resources: [URL],
        of package: PackageRepository,
        accessControl: String
      ) throws -> StrictString {
        return try source(
          for: namespaceTree(for: resources, of: package),
          accessControl: accessControl
        )
      }

      private func namespaceTree(
        for resources: [URL],
        of package: PackageRepository
      ) -> [StrictString: Any] {
        var tree: [StrictString: Any] = [:]
        for resource in resources {
          let pathComponentsArray = resource.path(relativeTo: package.location).components(
            separatedBy: "/"
          ).dropFirst(2).map({ String($0.contents) })
          let pathComponents = pathComponentsArray[pathComponentsArray.startIndex...]
          add(components: pathComponents, to: &tree, for: resource)
        }
        return tree
      }

      private func add(
        components: ArraySlice<String>,
        to tree: inout [StrictString: Any],
        for resource: URL
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

      private func variableName(for fileName: String) -> StrictString {
        let nameOnly = URL(fileURLWithPath: "/" + fileName)
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

            if let resource = value as? URL {
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
        for resource: URL,
        named name: StrictString,
        accessControl: String
      ) throws -> StrictString {
        let fileExtension = resource.pathExtension
        let initializer: (StrictString, StrictString)
        switch fileExtension {
        case "command", "css", "html", "js", "md", "sh", "txt", "xcscheme", "yml":
          initializer = ("String(data: ", ", encoding: String.Encoding.utf8)!")
        default:
          initializer = ("", "")
        }

        let data = try Data(from: resource)
        // #warning(Debugging...)
        print(data.count)

        var byteArray = data.lazy
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

        let variableStart: StrictString = "\(accessControl)static let \(name) = \(initializer.0)"
        let variableEnd: StrictString = initializer.1

        // #warning(Swift 5.6, The compiler hangs for some platforms if long literals are used (Workspace’s own licence resources are big enough to trigger the problem).)
        // 2 ↑ (0 < x ≤ 15)
        let problematicLength: Int = 2 ↑ 15
        if data.count ≥ problematicLength {
          let base64String = data.base64EncodedString()

          var declaration: StrictString = "#if arch(arm) |\u{7C} arch(arm64_32)\n"
          declaration += variableStart
          declaration += "Data(base64Encoded: \u{22}"
          declaration += base64String.scalars
          declaration += "\u{22})!"
          declaration += variableEnd
          declaration += "\n#else\n"
          declaration += variableStart
          declaration += "Data(["
          declaration += byteArray.scalars
          declaration += "] as [UInt8])"
          declaration += variableEnd
          declaration += "\n#endif"
          return declaration
        } else {
          var declaration: StrictString = variableStart
          declaration += "Data(["
          declaration += byteArray.scalars
          declaration += "] as [UInt8])"
          declaration += variableEnd
          return declaration
        }
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
