<!--
 Read‐Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Read‐Me

Workspace can manage the project’s read‐me.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Manage Read‐Me`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

A read‐me is a `README.md` file that GitHub and [documentation generation](Documentation%20Generation.md) use as the project’s main page.

## Customization

The default read‐me will automatically change to accommodate some configuration options, such as `Short Project Description`, `Quotation`, `Feature List`, etc.

The read‐me can be further customized by defining a template with the `Read‐Me` [configuration](Configuring%20Workspace.md) option.

The template for the read‐me works the same as the [template for file headers](File%20Headers.md#customization).

The available dynamic elements are:

- `Short Description`: The value of the configuration option `Short Project Description`.
- `Quotation`: A combination of the configuration options `Quotation`, `Quotation URL` and `Citation`. (`Quotation URL` and `Citation` are optional.)
- `Features`: The value of the configuration option `Feature List`.

Customization can be especially useful when it is combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).
