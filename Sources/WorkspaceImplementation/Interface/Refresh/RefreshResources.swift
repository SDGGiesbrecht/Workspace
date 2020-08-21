/*
 RefreshResources.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension Workspace.Refresh {

  internal enum Resources {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "resources"
      case .deutschDeutschland:
        return "ressourcen"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "regenerates code providing access to the project’s resources."
        case .deutschDeutschland:
          return
            "erstellt den Quelltext neu, der zugriff auf die Ressourcen des Projekts bereitstellt."
        }
      })

    private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return [
            "Workspace can embed resources in Swift package targets.",
            "",
            "Workspace will find and embed any file located within a project’s ‘Resources’ directory. The structure of the ‘Resources’ directory reflects the targets and namespaces under which the resources will be available in Swift code. Immediate subdirectories must correspond to targets; optional deeper nested directories produce namespaces. For example, a project with the following file...",
            "",
            "Resources/MyLibrary/Templates/Basic Template.txt",
            "",
            "...can use the file from within the ‘MyLibrary’ target like this...",
            "",
            "let template: String = Resoures.Templates.basicTemplate",
            "print(template)",
            "",
            "By default, files are embedded as ‘Data’, but some file extensions will be recognized and given a more specific Swift type (such as ‘.txt’ embedded as ‘String’).",
          ].joinedAsLines()
        case .englishUnitedStates, .englishCanada:
          return [
            "Workspace can embed resources in Swift package targets.",
            "",
            "Workspace will find and embed any file located within a project’s “Resources” directory. The structure of the “Resources” directory reflects the targets and namespaces under which the resources will be available in Swift code. Immediate subdirectories must correspond to targets; optional deeper nested directories produce namespaces. For example, a project with the following file...",
            "",
            "Resources/MyLibrary/Templates/Basic Template.txt",
            "",
            "...can use the file from within the “MyLibrary” target like this...",
            "",
            "let template: String = Resoures.Templates.basicTemplate",
            "print(template)",
            "",
            "By default, files are embedded as “Data”, but some file extensions will be recognized and given a more specific Swift type (such as “.txt” embedded as “String”).",
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Arbeitsbereich kann Ressourcen in Ziele eines Swift‐Pakets einbauen.",
            "",
            "Arbeitsbereich findet Dateien in „Ressourcen“‐Verzeichnis des Projekts, und baut sie ein. Die Gestalltung des „Ressourcen“‐Verzeichnis bestimmt die Ziele und Namensräume unter denen die Ressourcen in Swift‐Quelltext bereitgestellt werden. Direkte Unterverzeichnisse müssen mit Ziele übereinstimmen; beliebige weitere geschachtelte Verzeichnisse erstellen Namensräume. Zum Beispiel, ein Projekt mit der folgenen Datei ...",
            "",
            "Ressourcen/MeineBibliotek/Vorlagen/Einfache Vorlage.txt",
            "",
            "... kann die Datei in das „MeineBibliotek“‐Ziel so verwenden ...",
            "",
            "let vorlage: String = Ressouren.Vorlagen.einfacheVorlage",
            "print(vorlage)",
            "",
            "Die meisten Dateien werden als „Data“ eingebaut, aber manche Dateinamenserweiterungen sind erkannt und werden als genaueren Typen eingebaut (z. B. „.txt“ als „String“).",
          ].joinedAsLines()
        }
      })

    internal static let command = Command(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: [],
      options: Workspace.standardOptions,
      execution: { (_, options: Options, output: Command.Output) throws in

        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Refreshing resources..."
            case .deutschDeutschland:
              return "Ressourcen werden aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        // #workaround(Swift 5.2.4, Web lacks Foundation.)
        #if !os(WASI)
          try options.project.refreshResources(output: output)
        #endif
      }
    )
  }
}
