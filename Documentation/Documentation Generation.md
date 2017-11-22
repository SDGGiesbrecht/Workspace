<!--
 Documentation Generation.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Documentation Generation

Workspace can automatically generate API documentation using [Jazzy](https://github.com/realm/jazzy).

This is controlled by the [configuration](Configuring%20Workspace.md) option `Generate Documentation`. The default value is `True`.

```shell
$ workspace document
```

The generated documentation will be placed in a `docs` folder at the project root. [These GitHub settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch) can be adjusted to automatically host the documentation directly from the repository.

Each library product receives its own subfolder. Link to the documentation like this:<br>
`https://`username`.github.io/`repository`/`Module<br>

## Enforcement

Workspace can enforce documentation coverage.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Enforce Documentation Coverage`. The default value is `True`.

```shell
$ workspace validate documentation‐coverage
```

## Customization

### Copyright

The default copyright notice will automatically change to accommodate the configuration option `Author`.

The copyright notice can be further customized by defining a template with the `Documentation Copyright` [configuration](Configuring%20Workspace.md) option.

There are several dynamic elements available for the file header template. Dynamic elements can be used by placing the element’s key inside `[_` and `_]` at the desired location.

For example:
```text
Documentation Copyright: Copyright [_Copyright_] [_Author_].
```
becomes:
```text
Copyright ©2016–2017 John Doe.
```

The available dynamic elements are:

- `Project`: The name of the particular project. (e.g. `MyLibrary`)
- `Copyright`: The copyright date(s). (e.g. `©2016–2017`)
- `Author`: The value of the configuration option `Author`. (e.g. `John Doe`)

Dynamic elements can be especially useful when they are combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).

Copyright dates are determined by searching the contents of `index.html` at the target location the [same way](File%20Headers.md#determination-of-the-dates) as for file headers.

### Advanced

Jazzy can be further configured by placing a `.jazzy.yaml` file in the project root. For more information see [Jazzy’s own documentation](https://github.com/realm/jazzy).

## Linux

Documentation generation is not supported *from* Linux because Jazzy does not run on Linux.

However, documentation can still be generated *for* Linux from macOS, provided the project can also be built on macOS.

If necessary, even a project that does not really support macOS can use `#if os(Linux)` to enable a successful build.

## Special Thanks

- Realm and [Jazzy](https://github.com/realm/jazzy)
