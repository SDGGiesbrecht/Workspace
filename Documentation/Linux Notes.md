<!--
 Linux Notes.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Linux Notes

## Double‐Clicking Scripts

Linux may require some additional set‐up before `Refresh (Linux).sh` works with a double‐click. This also applies to `Validate (Linux).sh`.

Solutions to common errors are found below.

If the necessary fix is undesirable, it is possible to [run these scripts from a terminal](#running-from-a-terminal) instead.

### Error: The Script Opens in a Text Editor

Linux needs to be set to run executable scripts when they are double‐clicked instead of opening them to edit.

On Ubuntu, the setting is found at:

Files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Edit<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Preferences<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Behavior<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↳ Run execuatable text files when they are opened

### Error: Swift Is Unavailable

Because the script opens a new terminal to display its output, brand‐new terminal sessions need to be able to find the `swift` command without additional set‐up.

To register the location of `swift` even for new terminal sessions, run the following command, substituting the real location of the Swift install.

`echo 'export PATH=`/path/to/swift-0.0.0-RELEASE-ubuntu00.00`/usr/bin:"${PATH}"' >>~/.profile`

(If Swift is not even istalled yet, see the [Swift website](https://swift.org/download/) for instructions.)

### Running from a Terminal

While double‐clicking is usually the most convenient, it can be bypassed by manually running the **macOS equivalent** from a terminal:

```shell
$ "./Refresh (macOS).command"
```

This is exactly what the Linux script does internally. It just opens a new terminal window first to display the output.
