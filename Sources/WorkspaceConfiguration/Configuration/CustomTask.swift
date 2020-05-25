/*
 CustomTask.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(CustomTask)
/// Eine Sonderaufgabe.
///
/// Eine sonderaufgabe ist eine ausführbare Datei, die als Swift‐Paket ausgegeben ist. Rückgabewert 0 muss andeuten, dass das Projekt die Prüfung bestanden hat oder dass die Auffrischung erfolgreich war. Alle andere Rückgabewerte mussen andeuten, dass das Projekt nicht bestanden hat oder dass die Auffrischung unerfolgreich war. Die Ausgabe wird in dem Protokoll weitergegeben.
public typealias Sonderaufgabe = CustomTask
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(CustomTask)
/// A custom task.
///
/// A custom task can be any executable vended as a Swift package. Exit code 0 must indicate that the project passes validation or that refreshment was successful. Any other exit code must indicate that the project fails validation or that the task itself failed. Output will be included in the log.
public struct CustomTask: Decodable, Encodable {

  // MARK: - Initialization

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    // @localization(🇩🇪DE) @crossReference(CustomTask.init(url:version:executable:arguments:))
    /// Erstellt eine Sonderaufgabe.
    ///
    /// - Parameters:
    ///     - ressourcenzeiger: Der Ressourcenzeiger des Swift‐Pakets, das die Aufgabe bestimmt.
    ///     - ausgabe: Die Version des Swift‐Pakets, das die Aufgabe bestimmt.
    ///     - ausführbareDatei: Der Name der ausführbaren Datei.
    ///     - argumente: Argumente für die ausführbare Datei.
    public init(
      ressourcenzeiger: EinheitlicherRessourcenzeiger,
      version ausgabe: Version,
      ausführbareDatei: StrengeZeichenkette,
      argumente: [Zeichenkette] = []
    ) {
      self.init(
        url: ressourcenzeiger,
        version: ausgabe,
        executable: ausführbareDatei,
        arguments: argumente
      )
    }
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(CustomTask.init(url:version:executable:arguments:))
    /// Creates a custom task.
    ///
    /// - Parameters:
    ///     - url: The URL of the Swift package defining the task.
    ///     - release: The version of the Swift package defining the task.
    ///     - executable: The name of the executable for the task.
    ///     - arguments: Any arguments for the executable.
    public init(
      url: URL,
      version release: Version,
      executable: StrictString,
      arguments: [String] = []
    ) {
      self.url = url
      self.version = release
      self.executable = executable
      self.arguments = arguments
    }
  #endif

  // MARK: - Properties

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(CustomTask.url)
    /// The URL of the Swift package defining the task.
    public var url: URL
    // @localization(🇩🇪DE) @crossReference(CustomTask.url)
    /// Der Ressourcenzeiger des Swift‐Pakets, das die Aufgabe bestimmt.
    public var ressourcenzeiger: EinheitlicherRessourcenzeiger {
      get { return url }
      set { url = newValue }
    }
  #endif

  // @localization(🇩🇪DE)
  // Die Version des Swift‐Pakets, das die Aufgabe bestimmt.
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  /// The version of the Swift package defining the task.
  public var version: Version

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(CustomTask.executable)
  /// The name of the executable for the task.
  public var executable: StrictString
  // @localization(🇩🇪DE) @crossReference(CustomTask.executable)
  /// Der Name der ausführbaren Datei.
  public var ausführbareDatei: StrengeZeichenkette {
    get { return executable }
    set { executable = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(CustomTask.arguments)
  /// Any arguments for the executable.
  public var arguments: [String]
  // @localization(🇩🇪DE) @crossReference(CustomTask.arguments)
  /// Argumente für die ausführbare Datei.
  public var argumente: [Zeichenkette] {
    get { return arguments }
    set { arguments = newValue }
  }
}
