<!--
 Proofreading.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Proofreading

Workspace proofreads the project source during validation.

## In Xcode

Proofreading will also automatically work within Xcode if Workspace has been put [in charge of Xcode](Xcode.md).

If Workspace is not in charge of Xcode, proofreading can still be activated by manually adding the following “run script” build phase:

// [_Warning: This will no longer work._]
```shell
~/.Workspace/Workspace/.build/release/workspace proofread
```

## Disabling Rules

When Workspace triggers a warning, the name of the particular rule is always given in parentheses.

A rule can be disabled by adding the name of the rule to the [configuration](Configuring%20Workspace.md) option `Disable Proofreading Rules`.

`Disable Proofreading Rules` is a list separated by line breaks.

## SwiftLint

Workspace’s proofreading includes [SwiftLint](https://github.com/realm/SwiftLint).

By default, Workspace provides SwiftLint with a configuration that corresponds to its own. In this mode, SwiftLint rules can be treated as though they were Workspace rules. For example, they can be disabled the by listing them under `Disable Proofreading Rules`.

However, SwiftLint can instead be configured manually by placing a `.swiftlint.yml` file in the project root. In this mode, Workspace will no longer apply its own configuration to SwiftLint. That means, for example, that disabling SwiftLint rules by listing them under `Disable Proofreading Rules` will no longer work. For more information about `.swiftlint.yml`, see [SwiftLint’s own documentation](https://github.com/realm/SwiftLint).

## Special Thanks

- Realm and [SwiftLint](https://github.com/realm/SwiftLint)
