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

# Find repository.

# REPOSITORY="$(pwd)"
# Does not work for double‐click on macOS, or as a command on macOS or Linux from a different directory.

# REPOSITORY="${0%/*}"
# Does not work for double‐click on Linux or as a command on macOS or Linux from a different directory.

REPOSITORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Update Workspace
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

# Get Workspace if necessary.
WORKSPACE="$HOME/.Workspace/Workspace"
if [ ! -d "${WORKSPACE}/Sources" ]; then

    # The following changes for testing continuous integration behaviour must be made after Validate Changes, but before committing.
    # Travis CI’s cache must also be deleted. (The cache must be deleted again afterward in order to revert to normal behaviour.)

    # To test a fork of Workspace, replace the URL on the next line with that of the fork.
    git clone https://github.com/SDGGiesbrecht/Workspace "${WORKSPACE}"

    # To test a development branch of Workspace, change this to a real branch name.
    BRANCH="branch-name"

    if [ "$BRANCH" != "branch-name" ]; then
        cd "${WORKSPACE}"
        git checkout -b "${BRANCH}" "origin/${BRANCH}"
    fi
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

# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
# Run Workspace command
# ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

# Enter repository.
cd "${REPOSITORY}"

# Run.
~/.Workspace/Workspace/.build/release/workspace refresh
