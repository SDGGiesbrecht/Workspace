<!--
 Continuous Integration.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Continuous Integration

Workspace can automatically configure projects for continuous integration with [Travis CI](https://travis-ci.org).

This is controlled by the [configuration](Configuring%20Workspace.md) option `Manage Continuous Integration`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

Workspace will create and maintain a `.travis.yml` file at the project root, which configures Travis CI to run all the tests from `Validate Changes` (and several additional ones) on every [operating system](Operating%20Systems.md) supported by the project. (watchOS does not support unit tests.)

**Note**: Workspace cannot turn Travis CI on. It is still necessary to log into [Travis CI](https://travis-ci.org) and activate it for the project’s repository.

## Special Thanks

- [Travis CI](https://travis-ci.org)
- Kyle Fuller and [Swift Version Manager](https://github.com/kylef/swiftenv), which makes continuous integration possible on Linux.
