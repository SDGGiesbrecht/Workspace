<!--
 Simulator.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Simulator

By default, Workspace launches each Apple simulator as necessary.

Because booting and switching the simulator often takes longer than all the other tasks combined, Workspace provides a [configuration](Configuring Workspace.md) option, `Skip Simulator`, to skip actions that require the simulator. This can save a lot of time for projects where there are very few differences between the macOS tests and those of the other Apple platforms.

**`Skip Simulator` only takes effect when running locally. Workspace still performs all tasks during continuous integration.**

If `Skip Simulator` is set to `True`:

- Unit tests will only be run on macOS. For the other Apple platforms, Workspace will only verify that the build succeeds. (The tests for a particular platform can still be run manually from Xcode.)
