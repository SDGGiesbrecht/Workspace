// swift-tools-version:5.4

/*
 Package.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// @localization(🇩🇪DE)
/// Arbeitsbereich automatisiert die Verwaltung von Swift‐Projekten.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;SCH2000)
/// >
/// > [Was auch immer ihr macht, arbeitet vom Herzen, als für den Herrn und nicht für Menschen.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;SCH2000)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Merkmale
///
/// - Stellt gründliche Prüfungen bereit:
///     - [Testabdeckung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Testeinstellungen/Eigenschaften/abdeckungErzwingen.html)
///     - [Übersetzerwarnungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Testeinstellungen/Eigenschaften/übersetzerwarnungenVerbieten.html)
///     - [Dokumentationsabdeckung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Programmierschnittstellendokumentationseinstellungen/Eigenschaften/abdeckungErzwingen.html)
///     - [Beispielprüfung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/beispiele.html)
///     - [Stilkorrekturlesen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Korrektureinstellungen.html)
///     - [Erinnerungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Korrekturregel/Typ%E2%80%90Eigenschaften/warnungenVonHand.html)
///     - [Einrichtung von fortlaufeden Einbindung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/EinstellungenFortlaufenderEinbindung/Eigenschaften/verwalten.html) ([GitHub Vorgänge](https://github.com/features/actions))
/// - Erstellt  [Dokumentation](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Programmierschnittstellendokumentationseinstellungen/Eigenschaften/erstellen.html) von Programierschnittstellen.
/// - Automatisiert Quellinstandhaltung:
///     - [Einbau von Ressourcen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/ressourcen.html)
///     - [Geerbte Dokumentation](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/geerbte%E2%80%90dokumentation.html)
///     - [Erstellung von Xcode‐Projekte](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/XcodeEinstellungen/Eigenschaften/verwalten.html)
/// - Automatisiert quelloffene Nebensachen:
///     - [Dateivorspänne](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Dateivorspannseinstellungen.html)
///     - [Lies‐mich‐Dateien](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/LiesMichEinstellungen.html)
///     - [Lizenzhinweise](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Lizenzeinstellungen.html)
///     - [Mitwirkungsanweisungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/GitHubConfiguration.html)
/// - Für Verwendung neben dem [Swift Package Manager](https://swift.org/package-manager/) vorgesehen.
/// - Verwaltet Projekte für macOS, Windows, Netz, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux und watchOS.
/// - [Konfigurierbar](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Biblioteken/WorkspaceConfiguration.html)
///
/// ### Der Arbeitsablauf von Arbeitsbereich
///
/// (Das folgende Beispielspaket ist ein echtes Git‐Lager mit dem man Arbeitsbereich ausprobieren kann.)
///
/// #### Wenn der Lager nachgebaut wird
///
/// Der Aufwand, nach Werkzeuge fürs Arbeitsablauf zu suchen, kann Mitwirkende abschrecken. Andererseits, Werkzeuge im Lager zu sammeln führt schnell zum Durcheinander. Um Beide zu verhindern, wenn ein von Arbeitsbereich verwaltetes Projekt abgezogen, gestoßen oder nachgebaut wird ...
///
/// ```shell
/// git clone https://github.com/SDGGiesbrecht/SDGCornerstone
/// ```
///
/// ... kommt nur ein kleiner Teil von Arbeitsbereich mit: Ein kürzes Skript namens `Auffrischen`, das ein paar Schichtnebenformen hat.
///
/// *Hmm ... Wenn ich nur bessere Werkzeuge vorhanden hätte ... Ach, vielleicht kann ich ...*
///
/// #### Das Projekt auffrischen
///
/// Um das Projekt aufzufrischen, doppelklickt man schichtgemäß auf das `Auffrischen`‐Skript. (Das Skript ist auch vom Befehlszeile ausführbar, falls das System so eingestellt ist, dass es Skripte beim Doppleklick nicht ausführt.)
///
/// `Auffrischen` öffnet ein Terminalfenster und bereichtet von seinem Ablauf, während es das Projekt für Entwicklung bereitet. (Es kann dauern das erste Mal, aber beim Wiederholen geht es viel schneller.)
///
/// *So sieht ’s besser aus. Zum Programmieren!*
///
/// *[Dies hinzufügen ... Das entfernen ... Noch was hier ändern ...]*
///
/// *... Und fertig. Aber wenn ich durch mein Arbeit was kaputtgemacht habe? Ach, Sieh mal! Ich kann ...*
///
/// #### Änderungen prüfen
///
/// Wenn das Projekt zum Stoßen, zum Zusammenführen oder für eine Abziehungsanforderung bereit scheint, kann das Projektzustand geprüft werden, in dem man auf das `Prüfen`‐Skript doppelklickt.
///
/// `Prüfen` öffnet ein Terminalfenster in dem Arbeitsbereich das Projekt auf verschiedene Arte prüft.
///
/// Wenn es fertig ist, zeigt es eine Zusammenfassung davon, welche Prüfungen bestanden wurden, und welche nicht.
///
/// *Hoppla! So eine Nebenwirkung habe ich nicht verhergesehen...*
///
/// #### Zusammenfassung
///
/// - `Auffrischen` vor der Arbeit.
/// - `Prüfen`, wenn es vollständig scheint.
///
/// *Toll! Das war so viel einfacher, als das ganze von Hand zu machen!*
///
/// #### Fortgeschrittene Verwendung
///
/// Obwohl das vorhergehende Arbeitsablauf am Leichtesten gelernt wird, ist Arbeitsbereich auch als Befehlszeilwerkzeug installierbar, um eine Vielfalt von Einsetzungen zu ermöglichen. Vor allem können einzelne Aufgaben ausgeführt werden, wodurch können erfahrener Benutzer schneller an erwünste Ergebnisse kommen können.
///
/// ### Arbeitsbereich an einem Projekt anwenden
///
/// Um Arbeitsbereich an einem Projekt anzuwenden, führt man den folgenden Befehl im Wurzel des Projektlagers aus. (Eine vollständige Installation wird benötigt.)
///
/// ```shell
/// $ arbeitsbereich auffrischen
/// ```
///
/// Arbeitsbereich hält sich erstmals von Aufgaben zurück, die darin bestehen, in Projektdateien zu schreiben. Solche Aufgaben müssen mit einem [Konfigurationsdatei](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/ArbeitsbereichKonfiguration.html) eingeschalltet werden. In der Konfigurationsdatei, kann man `alleAufgabenEinschalten()` verwenden, um leicht alles gleichzeitig einzuschalten, egal wie viel dadurch überschrieben wird.
// @localization(🇺🇸EN)
/// Workspace automates management of Swift projects.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Features
///
/// - Provides rigorous validation:
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/LicenseConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Libraries/WorkspaceConfiguration.html)
///
/// ### The Workspace Workflow
///
/// (The following demonstration package is a real repository. You can use it to follow along.)
///
/// #### When the Repository Is Cloned
///
/// The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...
///
/// ```shell
/// git clone https://github.com/SDGGiesbrecht/SDGCornerstone
/// ```
///
/// ...only one small piece of Workspace comes with it: A short script called `Refresh` that has several platform variants.
///
/// *Hmm... I wish I had more tools at my disposal... Hey! What if I...*
///
/// #### Refresh the Project
///
/// To refresh the project, double‐click the `Refresh` script for your platform. (You can also execute the script from the command line if your system is set up not to execute scripts when they are double‐clicked.)
///
/// `Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)
///
/// *This looks better. Let’s get coding!*
///
/// *[Add this... Remove that... Change something over here...]*
///
/// *...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*
///
/// #### Validate Changes
///
/// When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.
///
/// `Validate` opens a terminal window and in it Workspace runs the project through a series of checks.
///
/// When it finishes, it prints a summary of which tests passed and which tests failed.
///
/// *Oops! I never realized that would happen...*
///
/// #### Summary
///
/// - `Refresh` before working.
/// - `Validate` when it looks complete.
///
/// *Wow! That was so much easier than doing it all manually!*
///
/// #### Advanced
///
/// While the above workflow is the simplest to learn, Workspace can also be installed as a command line tool that can be used in a wider variety of ways. Most notably, any individual task can be executed in isolation, which can speed things up considerably for users who become familiar with it.
///
/// ### Applying Workspace to a Project
///
/// To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)
///
/// ```shell
/// $ workspace refresh
/// ```
///
/// By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Libraries/WorkspaceConfiguration.html) file. `optIntoAllTasks()` can be used in the configuration file to easily activate everything at once, no matter how much it might end up overwriting.
// @localization(🇨🇦EN)
/// Workspace automates management of Swift projects.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Features
///
/// - Provides rigorous validation:
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/LicenceConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html)
///
/// ### The Workspace Workflow
///
/// (The following demonstration package is a real repository. You can use it to follow along.)
///
/// #### When the Repository Is Cloned
///
/// The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...
///
/// ```shell
/// git clone https://github.com/SDGGiesbrecht/SDGCornerstone
/// ```
///
/// ...only one small piece of Workspace comes with it: A short script called `Refresh` that has several platform variants.
///
/// *Hmm... I wish I had more tools at my disposal... Hey! What if I...*
///
/// #### Refresh the Project
///
/// To refresh the project, double‐click the `Refresh` script for your platform. (You can also execute the script from the command line if your system is set up not to execute scripts when they are double‐clicked.)
///
/// `Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)
///
/// *This looks better. Let’s get coding!*
///
/// *[Add this... Remove that... Change something over here...]*
///
/// *...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*
///
/// #### Validate Changes
///
/// When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.
///
/// `Validate` opens a terminal window and in it Workspace runs the project through a series of checks.
///
/// When it finishes, it prints a summary of which tests passed and which tests failed.
///
/// *Oops! I never realized that would happen...*
///
/// #### Summary
///
/// - `Refresh` before working.
/// - `Validate` when it looks complete.
///
/// *Wow! That was so much easier than doing it all manually!*
///
/// #### Advanced
///
/// While the above workflow is the simplest to learn, Workspace can also be installed as a command line tool that can be used in a wider variety of ways. Most notably, any individual task can be executed in isolation, which can speed things up considerably for users who become familiar with it.
///
/// ### Applying Workspace to a Project
///
/// To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)
///
/// ```shell
/// $ workspace refresh
/// ```
///
/// By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html) file. `optIntoAllTasks()` can be used in the configuration file to easily activate everything at once, no matter how much it might end up overwriting.
// @localization(🇬🇧EN)
/// Workspace automates management of Swift projects.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
/// >
/// > [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Features
///
/// - Provides rigorous validation:
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/LicenceConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html)
///
/// ### The Workspace Workflow
///
/// (The following demonstration package is a real repository. You can use it to follow along.)
///
/// #### When the Repository Is Cloned
///
/// The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...
///
/// ```shell
/// git clone https://github.com/SDGGiesbrecht/SDGCornerstone
/// ```
///
/// ...only one small piece of Workspace comes with it: A short script called `Refresh` that has several platform variants.
///
/// *Hmm... I wish I had more tools at my disposal... Hey! What if I...*
///
/// #### Refresh the Project
///
/// To refresh the project, double‐click the `Refresh` script for your platform. (You can also execute the script from the command line if your system is set up not to execute scripts when they are double‐clicked.)
///
/// `Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)
///
/// *This looks better. Let’s get coding!*
///
/// *[Add this... Remove that... Change something over here...]*
///
/// *...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*
///
/// #### Validate Changes
///
/// When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.
///
/// `Validate` opens a terminal window and in it Workspace runs the project through a series of checks.
///
/// When it finishes, it prints a summary of which tests passed and which tests failed.
///
/// *Oops! I never realized that would happen...*
///
/// #### Summary
///
/// - `Refresh` before working.
/// - `Validate` when it looks complete.
///
/// *Wow! That was so much easier than doing it all manually!*
///
/// #### Advanced
///
/// While the above workflow is the simplest to learn, Workspace can also be installed as a command line tool that can be used in a wider variety of ways. Most notably, any individual task can be executed in isolation, which can speed things up considerably for users who become familiar with it.
///
/// ### Applying Workspace to a Project
///
/// To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)
///
/// ```shell
/// $ workspace refresh
/// ```
///
/// By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html) file. `optIntoAllTasks()` can be used in the configuration file to easily activate everything at once, no matter how much it might end up overwriting.
let package = Package(
  name: "Workspace",
  platforms: [
    // These must also be updated in Sources/WorkspaceImplementation/Shared/Project/PackageRepository.swift.
    .macOS(.v10_12)
  ],
  products: [
    // @localization(🇩🇪DE)
    // #documentation(ArbeitsbereichKonfiguration)
    /// Die Wurzel der Programmierschnittstelle für Konfigurationsdateien.
    ///
    /// Arbeitsbereich kann durch eine Swift‐Datei Namens `Arbeitsbereich.swift` im Projektwurzel konfiguriert werden.
    ///
    /// Der Inhalt einer Konfigurationsdatei könnte etwa so aussehen:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Externe Pakete sind mit dieser Syntax einführbar:
    ///  import [Modul] // [Paket], [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .ubuntu, .android]
    ///
    /// konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
    /// konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
    /// konfiguration.dokumentation
    ///   .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
    /// konfiguration.dokumentation
    ///   .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")
    ///
    /// konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017
    ///
    /// konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
    /// konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(
    ///     auswerten: { konfiguration in
    ///       return [
    ///         "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///         "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       ]
    ///     }
    ///   )
    ///
    /// konfiguration.dokumentation.hauptautor = "Max Mustermann"
    /// ```
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // #documentation(WorkspaceConfiguration)
    /// The root API used in configuration files.
    ///
    /// Workspace can be configured by placing a Swift file named `Workspace.swift` in the project root.
    ///
    /// The contents of a configuration file might look something like this:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Exernal packages can be imported with this syntax:
    ///  import [module] // [package], [url], [version], [product]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .ubuntu, .android]
    ///
    /// configuration.documentation.currentVersion = Version(1, 0, 0)
    /// configuration.documentation.projectWebsite = URL(string: "project.uk")
    /// configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
    /// configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")
    ///
    /// configuration.documentation.api.yearFirstPublished = 2017
    ///
    /// configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
    /// configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
    ///   resolve: { configuration in
    ///     return [
    ///       "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
    ///     ]
    ///   })
    ///
    /// configuration.documentation.primaryAuthor = "John Doe"
    /// ```
    .library(name: "WorkspaceConfiguration", targets: ["WorkspaceConfiguration"]),

    /// Workspace.
    .executable(name: "workspace", targets: ["WorkspaceTool"]),
    /// Arbeitsbereich.
    .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCornerstone",
      from: Version(7, 2, 4)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCommandLine",
      from: Version(1, 7, 4)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGSwift",
      from: Version(7, 0, 1)
    ),
    .package(
      name: "SwiftPM",
      url: "https://github.com/SDGGiesbrecht/swift\u{2D}package\u{2D}manager",
      .exact(Version(0, 50400, 0))
    ),
    .package(
      name: "SwiftSyntax",
      url: "https://github.com/apple/swift\u{2D}syntax",
      .exact(Version(0, 50400, 0))
    ),
    .package(
      url: "https://github.com/apple/swift\u{2D}format",
      // Must also be updated in the documentation link in Sources/WorkspaceImplementation/Interface/Normalize.swift.
      .exact(Version(0, 50400, 0))
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGWeb",
      from: Version(5, 5, 2)
    ),
  ],
  targets: [
    // The executable. (Multiple products duplicate this with localized names.)
    .executableTarget(
      name: "WorkspaceTool",
      dependencies: [.target(name: "WorkspaceImplementation")]
    ),
    // The umbrella library. (Shared by the various localized executables.)
    .target(
      name: "WorkspaceImplementation",
      dependencies: [
        "WorkspaceLocalizations",
        "WorkspaceConfiguration",
        "WorkspaceProjectConfiguration",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGMathematics", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGCommandLine", package: "SDGCommandLine"),
        .product(name: "SDGExportedCommandLineInterface", package: "SDGCommandLine"),
        .product(name: "SDGSwiftConfigurationLoading", package: "SDGSwift"),
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SDGXcode", package: "SDGSwift"),
        .product(
          // #workaround(SwiftPM 0.50400.0, Reduce to SwiftPMDataModel‐auto once available.)
          name: "SwiftPM\u{2D}auto",
          package: "SwiftPM",
          // #workaround(SwiftPM 0.50400.0, Does not support Windows yet.)
          condition: .when(platforms: [.macOS, .wasi, .linux, .android])
        ),
        .product(
          name: "SwiftSyntax",
          package: "SwiftSyntax",
          condition: .when(platforms: [.macOS, .windows, .linux, .android])
        ),
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
        .product(
          name: "SwiftFormat",
          package: "swift\u{2D}format",
          condition: .when(platforms: [.macOS, .windows, .wasi, .linux, .android])
        ),
        .product(name: "SDGHTML", package: "SDGWeb"),
        .product(name: "SDGCSS", package: "SDGWeb"),
      ]
    ),

    // @localization(🇩🇪DE)
    // #documentation(ArbeitsbereichKonfiguration)
    /// Die Wurzel der Programmierschnittstelle für Konfigurationsdateien.
    ///
    /// Arbeitsbereich kann durch eine Swift‐Datei Namens `Arbeitsbereich.swift` im Projektwurzel konfiguriert werden.
    ///
    /// Der Inhalt einer Konfigurationsdatei könnte etwa so aussehen:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Externe Pakete sind mit dieser Syntax einführbar:
    ///  import [Modul] // [Paket], [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .ubuntu, .android]
    ///
    /// konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
    /// konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
    /// konfiguration.dokumentation
    ///   .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
    /// konfiguration.dokumentation
    ///   .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")
    ///
    /// konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017
    ///
    /// konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
    /// konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(
    ///     auswerten: { konfiguration in
    ///       return [
    ///         "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///         "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       ]
    ///     }
    ///   )
    ///
    /// konfiguration.dokumentation.hauptautor = "Max Mustermann"
    /// ```
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // #documentation(WorkspaceConfiguration)
    /// The root API used in configuration files.
    ///
    /// Workspace can be configured by placing a Swift file named `Workspace.swift` in the project root.
    ///
    /// The contents of a configuration file might look something like this:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Exernal packages can be imported with this syntax:
    ///  import [module] // [package], [url], [version], [product]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .ubuntu, .android]
    ///
    /// configuration.documentation.currentVersion = Version(1, 0, 0)
    /// configuration.documentation.projectWebsite = URL(string: "project.uk")
    /// configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
    /// configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")
    ///
    /// configuration.documentation.api.yearFirstPublished = 2017
    ///
    /// configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
    /// configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
    ///   resolve: { configuration in
    ///     return [
    ///       "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
    ///     ]
    ///   })
    ///
    /// configuration.documentation.primaryAuthor = "John Doe"
    /// ```
    .target(
      name: "WorkspaceConfiguration",
      dependencies: [
        "WorkspaceLocalizations",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftConfiguration", package: "SDGSwift"),
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
      ]
    ),

    // Defines the lists of supported localizations.
    .target(
      name: "WorkspaceLocalizations",
      dependencies: [
        .product(name: "SDGLocalization", package: "SDGCornerstone")
      ]
    ),

    // Tests

    .testTarget(
      name: "WorkspaceConfigurationTests",
      dependencies: [
        "WorkspaceConfiguration",
        "WorkspaceProjectConfiguration",
        "WorkspaceLocalizations",
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
      ]
    ),
    .testTarget(
      name: "WorkspaceTests",
      dependencies: [
        "WorkspaceLocalizations",
        "WorkspaceConfiguration",
        "WorkspaceProjectConfiguration",
        "WorkspaceImplementation",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGCommandLine", package: "SDGCommandLine"),
        .product(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine"),
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGHTML", package: "SDGWeb"),
        .product(name: "SDGWeb", package: "SDGWeb"),
      ]
    ),
    .target(
      name: "CrossPlatform",
      dependencies: [
        "CrossPlatformC",
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
      ],
      path: "Tests/CrossPlatform"
    ),
    .executableTarget(
      name: "cross‐platform‐tool",
      dependencies: ["CrossPlatform"],
      path: "Tests/cross‐platform‐tool"
    ),
    .testTarget(
      name: "CrossPlatformTests",
      dependencies: [
        "CrossPlatform",
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
      ]
    ),
    .target(
      name: "CrossPlatformC",
      path: "Tests/CrossPlatformC"
    ),

    .executableTarget(
      name: "WorkspaceConfigurationExample",
      dependencies: [
        "WorkspaceConfiguration",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
      ],
      path: "Tests/WorkspaceConfigurationExample"
    ),

    // Other

    // This allows Workspace to load and use a configuration from its own development state, instead of an externally available stable version.
    .target(
      name: "WorkspaceProjectConfiguration",
      dependencies: [
        "WorkspaceConfiguration"
      ],
      path: "",
      exclude: [
        "LICENSE.md",
        "README.md",
        "Refresh (Linux).sh",
        "Refresh (macOS).command",
        "Resources",
        "Sources",
        "Tests",
        "Validate (Linux).sh",
        "Validate (macOS).command",
      ],
      sources: ["Workspace.swift"]
    ),
  ]
)

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  defer { target.swiftSettings = swiftSettings }
  swiftSettings.append(contentsOf: [

    // Internal‐only:
    // #workaround(Swift 5.4.2, Web lacks Dispatch.)
    .define("PLATFORM_LACKS_DISPATCH", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, Web lacks Foundation.FileManager.)
    .define("PLATFORM_LACKS_FOUNDATION_FILE_MANAGER", .when(platforms: [.wasi])),
    // #warning(Swift 5.4.2, Web lacks Foundation.Process.)
    .define("PLATFORM_LACKS_FOUNDATION_PROCESS_INFO", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, FoundationXML is broken on Windows.)
    // #workaround(Swift 5.4.2, FoundationXML is broken on web.)
    .define(
      "PLATFORM_LACKS_FOUNDATION_XML",
      .when(platforms: [.windows, .wasi, .tvOS, .iOS, .watchOS])
    ),
    .define("PLATFORM_LACKS_GIT", .when(platforms: [.wasi, .tvOS, .iOS, .android, .watchOS])),
    // #workaround(SwiftSyntax 0.50400.0, SwiftSyntax manifest does not compile on Windows.)
    // #workaround(Swift 5.3.3, SwiftFormatConfiguration does not compile for web.)
    .define(
      "PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION",
      .when(platforms: [.windows, .wasi])
    ),
    // #workaround(Swift 5.4.2, SwiftPM lacks conditional targets.
    .define(
      "PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE",
      .when(platforms: [.windows, .wasi, .tvOS, .iOS, .android, .watchOS])
    ),
  ])
}

import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WINDOWS"] == "true" {
  let impossibleDependencies: [String] = [
    // #workaround(SwiftSyntax 0.50400.0, Manifest does not compile.)
    "SwiftSyntax",
    "swift\u{2D}format",
  ]
  package.dependencies.removeAll(where: { dependency in
    return impossibleDependencies.contains(where: { impossible in
      return (dependency.name ?? dependency.url).contains(impossible)
    })
  })
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        return "\(dependency)".contains(impossible)
      })
    })
  }

  // #workaround(Swift 5.4.0, Unable to build from Windows.)
  package.targets.removeAll(where: { $0.name.hasSuffix("tool") })
}

if ProcessInfo.processInfo.environment["TARGETING_WEB"] == "true" {
  let impossibleDependencies: [String] = [
    // #workaround(Swift 5.4.2, Web toolchain rejects manifest due to dynamic library.)
    "SwiftPM",

    // #workaround(Swift 5.3.2, Conditional dependencies fail to skip for web.)

    // #warning(SwiftSyntax 0.50300.0, Does not support web yet.)
    //"SwiftSyntax",
    "SwiftFormat\u{22}",
    // #workaround(Swift 5.3.2, Excluding only web causes manifest to crash.)
    "SwiftFormatConfiguration",
  ]
  package.dependencies.removeAll(where: { dependency in
    return impossibleDependencies.contains(where: { impossible in
      return (dependency.name ?? dependency.url).contains(impossible)
    })
  })
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        return "\(dependency)".contains(impossible)
      })
    })
  }
}

if ProcessInfo.processInfo.environment["TARGETING_TVOS"] == "true" {
  // #workaround(xcodebuild -version 12.5, Tool targets don’t work on tvOS.) @exempt(from: unicode)
  package.products.removeAll(where: { $0.name == "arbeitsbereich" })
  package.products.removeAll(where: { $0.name == "workspace" })
  package.targets.removeAll(where: { $0.name == "WorkspaceTool" })
  package.targets.removeAll(where: { $0.name == "cross‐platform‐tool" })
  package.targets.removeAll(where: { $0.name == "WorkspaceConfigurationExample" })
}

if ProcessInfo.processInfo.environment["TARGETING_IOS"] == "true" {
  // #workaround(xcodebuild -version 12.5, Tool targets don’t work on iOS.) @exempt(from: unicode)
  package.products.removeAll(where: { $0.name == "arbeitsbereich" })
  package.products.removeAll(where: { $0.name == "workspace" })
  package.targets.removeAll(where: { $0.name == "WorkspaceTool" })
  package.targets.removeAll(where: { $0.name == "cross‐platform‐tool" })
  package.targets.removeAll(where: { $0.name == "WorkspaceConfigurationExample" })
}

if ProcessInfo.processInfo.environment["TARGETING_ANDROID"] == "true" {
  // #workaround(Swift 5.4, Conditional dependencies fail to skip for Android.)
  let impossibleDependencies = [
    // #workaround(SwiftPM 0.50400.0, Does not support Andriod yet.)
    "SwiftPM",
    // #workaround(SwiftSyntax 0.50400.0, Does not support Android yet.)
    "SwiftSyntax",
    "SwiftFormat\u{22}",
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        "\(dependency)".contains(impossible)
      })
    })
  }
}

if ProcessInfo.processInfo.environment["TARGETING_WATCHOS"] == "true" {
  // #workaround(xcodebuild -version 12.5, Tool targets don’t work on watchOS.) @exempt(from: unicode)
  package.products.removeAll(where: { $0.name == "arbeitsbereich" })
  package.products.removeAll(where: { $0.name == "workspace" })
  package.targets.removeAll(where: { $0.name == "WorkspaceTool" })
  package.targets.removeAll(where: { $0.name == "cross‐platform‐tool" })
  package.targets.removeAll(where: { $0.name == "WorkspaceConfigurationExample" })
}

// #workaround(swift-tools-support-core 0.2.2, Version 0.2.3 is broken.) @exempt(from: unicode)
if ProcessInfo.processInfo.environment["TARGETING_WEB"] == "true" {
} else {
  package.dependencies.append(
    .package(
      url: "https://github.com/apple/swift\u{2D}tools\u{2D}support\u{2D}core.git",
      .exact(Version(0, 2, 2))
    )
  )
  let lastTests = package.targets.lastIndex(where: { $0.name == "WorkspaceImplementation" })!
  package.targets[lastTests].dependencies.append(
    .product(
      name: "SwiftToolsSupport\u{2D}auto",
      package: "swift\u{2D}tools\u{2D}support\u{2D}core",
      condition: .when(platforms: [.macOS])
    )
  )
}
