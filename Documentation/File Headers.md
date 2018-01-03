<!--
 File Headers.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# File Headers

Workspace can keep all the file headers in a project uniform and up to date.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Manage File Headers`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

A file header is a commented section at the top of each file in a project. Typical uses for file headers include:

- Identifing which project the file belongs to.
- Indicating copyright.
- Providing licence reminders.

## Customization

The default file header will automatically change to accommodate some configuration options, such as `Project Website`, `Author` and `Licence`.

The file header can be further customized by defining a template with the `File Header` [configuration](Configuring%20Workspace.md) option.

There are several dynamic elements available for the file header template. Dynamic elements can be used by placing the element’s key inside `[_` and `_]` at the desired location.

For example:

```text
[_Begin File Header_]
[_Filename_]

Copyright [_Copyright_] John Doe.
[_End_]

```

becomes:

```swift
/*
 Package.swift

 Copyright ©2017 John Doe.
 */
```

The available dynamic elements are:

- `Filename`: The name of the particular file. (e.g. `Package.swift`)
- `Project`: The name of the particular project. (e.g. `MyLibrary`)
- `Website`: The value of the configuration option `Project Website`. (e.g. `github.com/JohnDoe/MyLibrary`)
- `Copyright`: The file’s copyright date(s). (e.g. `©2016–2017`) More information [below](#copyright).
- `Author`: The value of the configuration option `Author`. (e.g. `John Doe`)
- `Licence`: The notice for the project’s [licence](Licence.md#selecting-a-licence).

Dynamic elements can be especially useful when they are combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).

## Precise Definition of a File Header

Because Workspace overwrites existing file headers, it is important to know how Workspace identifies them.

Workspace considers any comment that starts a file to be a file header, with the following constraints:

A file header may be a single block comment:

```swift
/*
 This is a header.
 This is more of the same header.
 */
/* This is not part of the header. */
```

Alternatively, a file header may be a continous sequence of line comments:

```swift
// This is a header.
// This is more of the same header.

// This is not part of the header.
```

Documentation comments are never headers.

```swift
/**
 This is not a header.
 */
```

In shell scripts, the shebang line precedes the header and is not part of it.

```shell
#!/bin/bash ← This is not part of the header.

# This is a header
```

## Copyright

With the dynamic element `Copyright`, Workspace can keep the copyright notices in file headers up to date.

### Determination of the Dates

Workspace uses any pre‐existing start date if it can detect one already in the file header. Workspace searches for `©`, `(C)`, or `(c)` followed by an optional space and four digits. If none is found, Workspace will use the current date as the start date.

Workspace always uses the current date as the end date.
