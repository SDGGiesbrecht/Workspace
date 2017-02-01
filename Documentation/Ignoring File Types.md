<!--
 Ignoring File Types.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Ignoring File Types

Workspace automatically skips files it does not understand, but it prints a warning first.

For standard file types, please [request that support be added](https://github.com/SDGGiesbrecht/Workspace/issues).

For non‐standard file types, the warning can be silenced using the [configuration](Configuring Workspace.md) option `Ignore File Types`. Each line is a separate entry:

```
[_Begin Ignore File Types_]
jpg
mp3
[_End_]
```

**Note that file types entered in `Ignore File Types` will continue to be ignored even if Workspace adds support for them later.**
