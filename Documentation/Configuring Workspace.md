<!--
 Configuring Workspace.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Configuring Workspace

Workspace can be configured by placing a text file called `.Workspace Configuration.txt` in the project root.

The basic syntax is as follows:

```text
Option A: Simple Value

[_Begin Option B_]
Multiline
Value
[_End_]

(Comment)

((
    Multiline
    Comment
    ))
```

An option may be specified more than once, in which case the last instance overrides any previous instances.

## Sharing Configurations between Projects

A configuration file can import options from another repository:

```text
[_Import https://github.com/user/repository_]
```

The referenced repository can be a real project or an otherwise empty repository, as long as it contains a `.Workspace Configuration.txt` file at its root.

Precedence rules still apply. The imported options can override any options before the import statement, and options that follow the import statement can override the imported options.

## Requiring Options

A configuration file can require itself and any other configuration file that imports it to define a particular option. This can be useful to make sure that default templates are consistently filled out with options, like `Project Website` or `Short Project Description`, that have to differ between projects.

A requirement can be confined to projects of a certain type.

`Require Options` is a list separated by line breaks. Each entry is one of two forms:

- `Option Name`
- `Project Type: Option Name`

For example:

```text
[_Begin Require Options_]
Short Project Description
Project Website
Library: Repository URL
Library: Current Version
[_End_]
```

## Available Options

For information on the various available options, see the documentation for the particular feature:

- [Project Types](Project%20Types.md)
- [Operating Systems](Operating%20Systems.md)
- [Simulator](Simulator.md)
- [Read‐Me](Read‐Me.md)
- [Licence](Licence.md)
- [Contributing Instructions](Contributing%20Instructions.md)
- [Xcode](Xcode.md)
- [File Headers](File%20Headers.md)
- [Proofreading](Proofreading.md)
- [Compiler Warnings](Compiler%20Warnings.md)
- [Test Coverage](Test%20Coverage.md)
- [Documentation Generation](Documentation%20Generation.md)
- [Continuous Integration](Continuous%20Integration.md)
- [Ignoring File Types](Ignoring%20File%20Types.md)
