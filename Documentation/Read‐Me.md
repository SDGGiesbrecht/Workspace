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

The default read‐me will automatically change to accommodate some [configuration](Configuring%20Workspace.md) options:

- `Documentation URL`: The root URL for API documentation. (As long as the last path component is `macOS`, `Linux`, `iOS`, `watchOS` or `tvOS`, Workspace will link to each individually by swapping out the last path component.)
- `Short Project Description` (Markdown)
- `Quotation`, `Quotation URL` & `Citation` (Text)
- `Feature List` (Markdown)
- `Related Projects`: A list separated by line breaks. Each entry is one of two forms:
    - `Name: https://url.of/repository`
    - `# Section Heading`
- `Installation Instructions` (Markdown. Default instructions exist for library projects that have `Repository URL` and `Current Version` defined.)

The default read‐me will also automatically include [usage examples](Examples#readme) if available.

The read‐me can be further customized by defining a template with the `Read‐Me` [configuration](Configuring%20Workspace.md) option.

The template for the read‐me works the same as the [template for file headers](File%20Headers.md#customization).

The available dynamic elements are:

- `API Links`: The result of the configuration option `Documentation URL`.
- `Short Description`: The value of the configuration option `Short Project Description`.
- `Quotation`: The combined result of the configuration options `Quotation`, `Quotation URL` and `Citation`.
- `Features`: The value of the configuration option `Feature List`.
- `Related Projects`: A link to the results of the configuration option `Related Projects`.
- `Installation Instructions`: The value of the configuration option `Installation Instructions`.
- `Repository URL`: The value of the configuration option `Repository URL`.
- `Current Version`: The value of the configuration option `Current Version`.
- `Next Major Version`: The major version following the value of `Current Version`.
- `Example Usage`: See [Examples](examples#readme).

Customization can be especially useful when it is combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).
