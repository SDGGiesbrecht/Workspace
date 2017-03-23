<!--
 Licence.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Licence

Workspace can automatically manage a project’s licence, making sure the main licence file (`LICENSE.md`) and the short notices in each [file header](File%20Headers.md) remain uniform.

Management of the main licence file is controlled by the [configuration](Configuring%20Workspace.md) option `Manage Licence`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

For the short notices in [file headers](File%20Headers.md), `Manage Licence` is not necessary. As long as a license has been [selected](#selecting-a-licence), the default header will display a licence notice, and a `Licence` dynamic element will be available for [custom headers](File%20Headers.md#customization).

Licence management can be especially useful when they are combined with [configuration sharing](Configuring%20Workspace.md#sharing-configurations-between-projects).

## Selecting a Licence

A particular licence can be selected with the [configuration](Configuring%20Workspace.md) option `Licence`. Possible values are:

- `Apache 2.0` ([text](../Resources/Licences/Apache%202.0.md)) (Swift itself is under this licence.)
- `MIT` ([text](../Resources/Licences/MIT.md))
- `GNU General Public 3.0` ([text](../Resources/Licences/GNU%20General%20Public%203.0.md))
- `Unlicense` ([text](../Resources/Licences/Unlicense.md)) (Public Domain)
- `Copyright` ([text](../Resources/Licences/Copyright.md)) (No Permissions)

For information about the various licences, see [choosealicense.com](https://choosealicense.com).

Know of a common licence that is not yet supported? [Request it.](https://github.com/SDGGiesbrecht/Workspace/issues)
