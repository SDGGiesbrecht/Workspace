<!--
 Documentation Generation.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Documentation Generation

Workspace can automatically generate API documentation using [Jazzy](https://github.com/realm/jazzy).

This is controlled by the [configuration](Configuring Workspace.md) option `Generate Documentation`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

The generated documentation will be placed in a `docs` folder at the project root. [These GitHub settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch) can be adjusted to automatically host the documentation directly from the repository.

Each operating system receives its own subfolder. Link to the documentation like this:<br>
`https://`username`.github.io/`repository`/macOS`<br>
or<br>
`https://`username`.github.io/`repository`/Linux`<br>
etc.

## Customization

### Copyright

The default copyright notice will automatically change to accommodate the configuration option `Author`.

The copyright notice can be further customized by defining a template with the `Documentation Copyright` [configuration](Configuring Workspace.md) option.

There are several dynamic elements available for the file header template. Dynamic elements can be used by placing the element’s key inside `[_` and `_]` at the desired location.

For example:

```
Documentation Copyright: Copyright [_Copyright_] [_Author_].

```

becomes:

```swift
Copyright ©2016–2017 John Doe.
```

The available dynamic elements are:

- `Project`: The name of the particular project. (e.g. `MyLibrary`)
- `Copyright`: The file’s copyright date(s). (e.g. `©2016–2017`) More information [below](#copyright).
- `Author`: The value of the configuration option `Author`. (e.g. `John Doe`)

Dynamic elements can be especially useful when they are combined with [configuration sharing](Configuring Workspace.md#sharing-configurations-between-projects).

### Advanced

Jazzy can be further configured by placing a `.jazzy.yaml` file in the project root. For more information see [Jazzy’s own documentation](https://github.com/realm/jazzy).

## Linux

Documentation generation is not supported *from* Linux because Jazzy does not run on Linux.

However, documentation can still be generated *for* Linux from macOS, albeit with a little extra preparation.

To do so, Workspace activates the conditional build flag `LinuxDocs` when it builds on macOS for the sake of Linux documentation.

Conditional compilation involving public symbols must be done like this:

```swift
// For Linux:

#if os(macOS) && LinuxDocs
    /// Does penguin stuff.
    public func doPenguinStuff() {
        preconditionFailure()
    }
#elseif os(Linux)
    /// Does penguin stuff.
    public func doPenguinStuff() {
        goForSwim()
        slideOnIce()
        watchAirplane()
        fallOver()
    }
#endif

// For macOS:

#if os(macOS) && !LinuxDocs
    /// Does apple stuff.
    public func doAppleStuff() {
        grow()
        turnRed()
        demonstrateGravity()
        landOnNewton()
    }
#endif
```

Where there are no public symbols involved, conditional compilation can be done normally:
```swift
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

/// Makes the operating system say, “hi”.
func sayHi() {
    let name: String
    #if os(Linux)
        name = "Linux"
    #else
        name = "macOS"
    #endif

    print("Hi! My name is \(name).")
}
```

## Special Thanks

- Realm and [Jazzy](https://github.com/realm/jazzy)
