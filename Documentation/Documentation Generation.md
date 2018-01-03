<!--
 Documentation Generation.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Documentation Generation

Workspace can automatically generate API documentation using [Jazzy](https://github.com/realm/jazzy).

This is controlled by the [configuration](Configuring%20Workspace.md) option `Generate Documentation`. The default value is `False`.

```shell
$ workspace document
```

By default, the generated documentation will be placed in a `docs` folder at the project root. [These GitHub settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch) can be adjusted to automatically host the documentation directly from the repository. (If you wish to avoid checking generated files into `master`, see [Deployment](#deployment) for a more advanced method.)

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

## Deployment

Projects with [continuous integration](Continuous%20Integration.md) management active can avoid checking generated files into `master`.

With the following set‐up, Workspace will only generate documentation in continuous integration and stop generating it locally. (If needed for coverage checks, Workspace may still do so in a temporary directory.) The generated documentation will be automatically published to GitHub Pages via the `gh-pages` branch, making the `docs` directory unnecessary.

Requirements:

1. A GitHub [access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
2. The Travis gem. `$ gem install travis`

Set‐Up:

1. Navigate to a local clone of the repository. `$ cd `[path]` `.
2. Encrypt the access token: `$ travis encrypt "GITHUB_TOKEN=`[token]`"`
3. [Configure](Configuring%20Workspace.md) `Encrypted Travis Deployment Key: `[the encrypted key]` `
4. [Configure](Configuring%20Workspace.md) `Original Documentation Copyright Year: `[year]` ` (because this way it cannot be retrieved from older documentation).
5. Set GitHub Pages to [serve from the `gh-pages` branch](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#enabling-github-pages-to-publish-your-site-from-master-or-gh-pages).

## Linux

Documentation generation is not supported *from* Linux because Jazzy does not run on Linux.

However, documentation can still be generated *for* Linux from macOS, provided the project can also be built on macOS.

If necessary, even a project that does not really support macOS can use `#if os(Linux)` to enable a successful build.

## Special Thanks

- Realm and [Jazzy](https://github.com/realm/jazzy)
