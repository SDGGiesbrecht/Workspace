<!--
 Linux Notes.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Linux Notes

## Enabling Double‐Click for “Refresh Workspace (Linux).sh”

Linux may require some additional set‐up before `Refresh Workspace (Linux).sh` works with a double‐click. This also applies to `Validate Changes (Linux).sh`.

If double‐clicking does not work, look for the particular error below.

If the fix for the error is undesirable, see [Running from a Terminal](#running-from-a-terminal)

### The Script Opens in a Text Editor

Linux needs to be set to run executable scripts when they are double‐clicked instead of opening them to edit.

On Ubuntu, the setting is found at:
Files
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Edit
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Preferences
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Behavior
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Run execuatable text files when they are opened

### Swift Is Unavailable

Because the script opens a new terminal to display its output, brand‐new terminal sessions need to be able to find the `swift` command without additional set‐up.

To register the location of `swift` even for new terminal sessions, run the following command, substituting the real location of the Swift install.

`echo 'export PATH=`/path/to/swift-0.0.0-RELEASE-ubuntu00.00`/usr/bin:"${PATH}"' >>~/.bashrc`

(If Swift is not even istalled yet, see the [Swift website](https://swift.org/download/) for instructions.)

### Running from a Terminal

While double‐clicking is usually the most convenient, it can be bypassed by manually running the macOS equivalent from a terminal:

```
./Refresh\ Workspace\ \(macOS\).command
```

This is exactly what the Linux script does internally. It merely opens a new terminal window to display the output, and then runs the macOS script.
