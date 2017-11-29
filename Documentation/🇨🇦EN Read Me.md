<!--
 🇨🇦EN Read Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.<br>Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎שאול/Shaʼul

## Features

- Provides rigorous validation:
  - [Test coverage](Documentation/Code%20Coverage.md)
  - [Compiler warnings](Documentation/Compiler%20Warnings.md)
  - [Documentation coverage](Documentation/Documentation%20Generation.md#enforcement)
  - [Example validation](Documentation/Examples.md)
  - [Style proofreading](Documentation/Proofreading.md) (including [SwiftLint](https://github.com/realm/SwiftLint))
  - [Reminders](Documentation/Manual%20Warnings.md)
  - [Continuous integration set‐up](Documentation/Continuous%20Integration.md) ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))
- Generates API [documentation](Documentation/Documentation%20Generation.md) (except from Linux). (Using [Jazzy](https://github.com/realm/jazzy))
- Automates code maintenance:
  - [Embedded resources](Documentation/Resources.md)
  - [Inherited documentation](Documentation/Documentation%20Inheritance.md)
  - [Xcode project generation](Documentation/Xcode.md)
- Automates open source details:
  - [file headers](Documentation/File%20Headers.md)
  - [read‐me files](Documentation/Read‐Me.md)
  - [licence notices](Documentation/Licence.md)
  - [contributing instructions](Documentation/Contributing%20Instructions.md)
- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
- Manages projects for macOS, Linux, iOS, watchOS and tvOS.
- [Configurable](Documentation/Configuring%20Workspace.md)
  -  Configurations can be [shared](Documentation/Configuring%20Workspace.md#sharing-configurations-between-projects) between projects.
