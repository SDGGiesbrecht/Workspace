<!--
 README.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Workspace

Workspace automates management of Swift projects.

## What Workspace Can Do

## Set‐Up

### New Projects

To have Workspace create a new Swift project from scratch, run this script in an empty folder:

git clone https://github.com/SDGGiesbrecht/Workspace .Workspace
cd .Workspace
swift build --configuration release
cd ..
.Workspace/.build/release/workspace initialize

### Existing Projects

To have Workspace take responsibility for an existing project, run this script the root of its repository:

git clone https://github.com/SDGGiesbrecht/Workspace .Workspace
cd .Workspace
swift build --configuration release
cd ..
.Workspace/.build/release/workspace refresh
