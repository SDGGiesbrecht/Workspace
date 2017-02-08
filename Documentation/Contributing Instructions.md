<!--
 File Headers.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Contributing Instructions

Workspace can manage the project’s contributing instructions.

This is controlled by the [configuration](Configuring Workspace.md) option `Manage Contributing Instructions`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

Contributing instructions are instructions in a `CONTRIBUTING.md` file that GitHub directs contributors to read.

## Customization

The contributing instructions can be customized by defining a template with the `Contributing Instructions` [configuration](Configuring Workspace.md) option.

The template for contributing instructions works the same as the [template for file headers](File Headers.md#Customization).

The available dynamic elements are:

- `Project`: The name of the particular project. (e.g. `MyLibrary`)
- `Administrators`: The value of the configuration option `Administrators`, which is a list of GitHub user names separated by line breaks.

Customization can be especially useful when it is combined with [configuration sharing](Configuring Workspace.md#sharing-configurations-between-projects).
