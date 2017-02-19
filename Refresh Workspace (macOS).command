#!/bin/bash

# Refresh Workspace (macOS).command
#
# This source file is part of the Workspace open source project.
# https://github.com/SDGGiesbrecht/Workspace
#
# Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.
#
# Soli Deo gloria.
#
# Licensed under the Apache Licence, Version 2.0.
# See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

# !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!
# This file is managed by Workspace.
# Manual changes will not persist.
# For more information, see:
# https://github.com/SDGGiesbrecht/Workspace
# !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!! !!!!!!!

# Stop if a command fails.
set -e

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Update Workspace
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

# Get Workspace if necessary.
WORKSPACE="~/.Workspace/Workspace"
if [ ! -d "${WORKSPACE}/Sources" ]; then

    # The following changes for testing continuous integration behaviour must be made after Validate Changes, but before committing.
    # Travis CI’s cache must also be deleted. (The cache must be deleted again afterward in order to revert to normal behaviour.)

    # To test a fork of Workspace, replace the URL on the next line with that of the fork.
    git clone https://github.com/SDGGiesbrecht/Workspace "${WORKSPACE}"

    # To test a development branch of Workspace, uncomment the following four lines and use the real branch name.
    # BRANCH="branch-name"
    # cd "${WORKSPACE}"
    # git checkout -b "${BRANCH}" "origin/${BRANCH}"
    # cd ..
fi

# Update Workspace.
cd "${WORKSPACE}"
git pull
if swift build --configuration release; then
    :
else
    swift package update
    swift build --configuration release
fi
cd ..

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Run Workspace command
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

# Find and enter repository.
cd "${0%/*}"

# Run
~/.Workspace/Workspace/.build/release/workspace refresh
