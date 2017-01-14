<!--
 Responsibilities.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Responsibilities

Workspace can automatically take on new responsibilities as new features become available.

This setting is controlled in the [configuration](Configuring Workspace.md) file:

```
Automatically Take On New Responsibilities: True
```

or

```
Automatically Take On New Responsibilities: False
```

`True` means Workspace will automatically add any configuration options that are not specified yet.<br>
`False` means Workspace’s responsibilities will need to be configured manually.

This option is inferred to be `False` if it is not specified in the configuration file.

## At Set‐Up

When Workspace is used to [create a new project](../README.md#new-projects), it generates a configuration file with this option set to `True`.

When Workspace is [added to an existing project](../README.md#existing-projects), it does not create a configuration file, so this option will default to `False`.

## Default vs Automatic

- A “default” value refers to the value which is inferred if the option is not specified in the configuration file and `Automatically Take On New Responsibilities` is `False`.
- An “automatic” value refers to the value which Workspace will add to the configuration file if the option is not yet specified and `Automatically Take On New Responsibilities` is `True`.

Default values favour non‐interference, and automatic values represent standard behaviour. Not all options have an automatic value.
