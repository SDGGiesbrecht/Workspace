#!/bin/bash

# Refresh (macOS).command
#
# This source file is part of the Workspace open source project.
# https://github.com/SDGGiesbrecht/Workspace#workspace
#
# Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.
#
# Soli Deo gloria.
#
# Licensed under the Apache Licence, Version 2.0.
# See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

set -e
REPOSITORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${REPOSITORY}"
swift run workspace refresh $1 $2 $3 $4
