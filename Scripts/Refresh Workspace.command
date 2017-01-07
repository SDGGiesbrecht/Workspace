#!/bin/bash

# Refresh Workspace.command
#
# This source file is part of the Workspace open source project.
#
# Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
#
# Soli Deo gloria
#
# Licensed under the Apache License, Version 2.0
# See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

# !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!
# This file is managed by Workspace.
# Manual changes will not persist.
# For more information, see:
# https://github.com/SDGGiesbrecht/Workspace
# !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!

ls

# Find and enter repository.
cd "${0%/*}"

ls

exit 1

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Update Workspace
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

# Get Workspace if necessary.
WORKSPACE=".Workspace"
if [ ! -d "${WORKSPACE}" ]; then
    git clone https://github.com/SDGGiesbrecht/Workspace "${WORKSPACE}"
fi

# Update Workspace.
if cd "${WORKSPACE}"; then
    git pull
    swift build --configuration release
    cd ..
fi

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Run Workspace command
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

.Workspace/.build/release/workspace refresh
