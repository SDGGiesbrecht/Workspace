<!--
 Proofreading.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

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

The text `[_Warning: `Some description here.`_]` will always trigger a warning during proofreading and cause validation to fail. It will not interrupt Swift or Xcode builds.

### Workaround Reminder

Workaround reminders are for times when you need to implement a temporary workaround because of a problem in a dependency, and you would like to remind yourself to go back and remove the workaround once the dependency is fixed.

The text `[_Workaround: `Some description here.`_]` will trigger a warning during proofreading, but will still pass validation.
