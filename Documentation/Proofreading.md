<!--
 Proofreading.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

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

```shell
~/.Workspace/Workspace/.build/release/workspace proofread
```

## Manual Warnings

Workspace provides several kinds of manual warnings.

Warnings can be used in any kind of text file—Swift, Markdown, Git Ignore, YAML, Shell, etc. They will be detected anywhere, but in most cases it is wise to nest them inside comments.

### Generic Warning

Generic warnings are for times when you want to prevent the project from passing validation until you come back to fix something, but you still need the project to build while you are working on it.

The text `[_Warning: `Some description here.`_]` will always trigger a warning during proofreading and cause validation to fail. It will not interrupt Xcode builds or `swift build`.

### Workaround Reminder

Workaround reminders are for times when you need to implement a temporary workaround because of a problem in a dependency, and you would like to remind yourself to go back and remove the workaround once the dependency is fixed.

The text `[_Workaround: `Some description here.`_]` will trigger a warning during proofreading, but will still pass validation.

## Disabling Rules

When Workspace triggers a warning, the name of the particular rule is always given in parentheses.

A rule can be disabled by adding the name of the rule to the [configuration](Configuring Workspace.md) option `Disable Proofreading Rules`.

`Disable Proofreading Rules` is a list separated by line breaks.

## SwiftLint

Workspace’s proofreading includes [SwiftLint](https://github.com/realm/SwiftLint).

By default, Workspace provides SwiftLint with a configuration that corresponds to its own. In this mode, SwiftLint rules can be treated as though they were Workspace rules. For example, they can be disabled the by listing them under `Disable Proofreading Rules`.

However, SwiftLint can instead be configured manually by placing a `.swiftlint.yml` file in the project root. In this mode, Workspace will no longer apply its own configuration to SwiftLint. That means, for example, that disabling SwiftLint rules by listing them under `Disable Proofreading Rules` will no longer work. For more information about `.swiftlint.yml`, see [SwiftLint’s own documentation](https://github.com/realm/SwiftLint).

## Special Thanks

- Realm and [SwiftLint](https://github.com/realm/SwiftLint)
