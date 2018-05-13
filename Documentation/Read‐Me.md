<!--
 Read‐Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Read‐Me

Workspace can manage the project’s read‐me.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Manage Read‐Me`. The default value is `False`.

```shell
$ workspace refresh read‐me
```

A read‐me is a `README.md` file that GitHub and [documentation generation](Documentation%20Generation.md) use as the project’s main page.

## Customization

The default read‐me will automatically change to accommodate some [configuration](Configuring%20Workspace.md) options:

- `Support macOS`, `Support Linux`, etc.
- `Documentation URL`: The root URL for API documentation. (The directory for the package, not for an individual module. Workspace will link to each module individually.)
- `Short Project Description` (Markdown)
- `Quotation`, `Quotation Translation`, `Quotation URL` & `Citation` (Text)
- `Feature List` (Markdown)
- `Related Projects`: A list separated by line breaks. Each entry is one of two forms:
    - `Name: https://url.of/repository`
    - `# Section Heading`
- `Installation Instructions` (Markdown. Default instructions exist for executable and library products if `Repository URL` and `Current Version` defined.)
- `Other Read‐Me Content` (Markdown)

The default read‐me will also automatically include [usage examples](Examples.md#readme) if available.

The read‐me can be further customized by defining a template with the `Read‐Me` [configuration](Configuring%20Workspace.md) option.

The template for the read‐me works the same as the [template for file headers](File%20Headers.md#customization).

The available dynamic elements are:

- `Localization Links`: Links to the read‐me in other languages.
- `Operating System List`: Icons for the supported operating systems.
- `API Links`: The result of the configuration option `Documentation URL`.
- `Short Description`: The value of the configuration option `Short Project Description`.
- `Quotation`: The combined result of the configuration options `Quotation`, `Quotation Translation`, `Quotation URL` and `Citation`.
- `Features`: The value of the configuration option `Feature List`.
- `Related Projects`: A link to the results of the configuration option `Related Projects`.
- `Installation Instructions`: The value of the configuration option `Installation Instructions`.
- `Repository URL`: The value of the configuration option `Repository URL`.
- `Current Version`: The value of the configuration option `Current Version`.
- `Example Usage`: The value of the configuration option `Example Usage`.
- `[_Example: `Identifier`_]`: A particular [example](Examples.md).
- `Other`: The value of the configuration option `Other Read‐Me Content`
- `About`: The value of the configuration option `Read‐Me About Section`

Customization can be especially useful when it is combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).

## Localization

The read‐me can be localized by listing localizations in the [configuration](Configuring%20Workspace.md) option `Localizations`:

```workspace
[_Begin Localizations_]
en
de
[_End_]
```

Then some configuration options related to read‐me generation can be localized. The syntax is as follows:

```workspace
[_Begin Short Project Description_]
[_en_]
A project.
[_de_]
Ein Projekt.
[_End_]
```

While any identifier can be used as a localization, Workspace currently only understands and adapts its templates for the following localizations:

- `🇬🇧EN`/`en-GB`/`en`
    - `🇺🇸EN`/`en-US`
    - `🇨🇦EN`/`en-CA`

If you speak a language not already on the list and you might be willing to help add it, you can mention it in an [issue](https://github.com/SDGGiesbrecht/Workspace/issues).
