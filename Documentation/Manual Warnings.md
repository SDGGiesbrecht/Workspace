<!--
 Manual Warnings.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Manual Warnings

Workspace provides several kinds of manual warnings.

Warnings can be used in any kind of text file—Swift, Markdown, Git Ignore, YAML, Shell, etc. They will be detected anywhere, but in most cases it is wise to nest them inside comments.

### Generic Warning

Generic warnings are for times when you want to prevent the project from passing validation until you come back to fix something, but you still need the project to build while you are working on it.

The text...

`[_Warning: `Some description here.`_]`

...will always trigger a warning during [proofreading](Proofreading.md) and cause validation to fail. It will not interrupt Swift or Xcode builds.

### Workaround Reminder

Workaround reminders are for times when you need to implement a temporary workaround because of a problem in a dependency, and you would like to remind yourself to go back and remove the workaround once the dependency is fixed.

The text...

`[_Workaround: `Some description here.`_]`

...will trigger a warning during [proofreading](Proofreading.md), but will still pass validation.

### Version Detection

Optionally, a workaround reminder can specify the dependency and version were the problem exists. Then Workspace will ignore it until the problematic version is out of date.

`[_Workaround: `Some description here.` (`Dependency` `0.0.0`)_]`

The dependency can be specified three different ways.

- Package dependencies can be specified using the exact name of the package.
```swift
// [_Workaround: There is a problem in MyLibrary. (MyLibrary 1.0.0)_]
```

- Swift itself can be specified with the string “Swift”.
```swift
// [_Workaround: There is a problem with Swift. (Swift 3.0.2)_]
```

- Arbitrary dependencies can be specified by bash commands that output a version number. Workspace will look for the first group of the characters `0`–`9` and `.` in the command output. Only simple commands are supported; commands cannot contain quotation marks.
```swift
// [_Workaround: There is a problem with Git. (git --version 2.10.1)_]
```
