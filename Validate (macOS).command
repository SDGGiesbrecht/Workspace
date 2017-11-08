#!/bin/bash

# Validate (macOS).command
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
if workspace version > /dev/null ; then
    echo "Using system install of Workspace..."
    workspace validate •use‐version 0.1.0
elif ~/Library/Caches/ca.solideogloria.Workspace/Versions/0.1.0/workspace version > /dev/null ; then
    "Using cached build of Workspace..."
    ~/Library/Caches/ca.solideogloria.Workspace/Versions/0.1.0/workspace validate •use‐version 0.1.0
elif ~/.cache/ca.solideogloria.Workspace/Versions/0.1.0/workspace version > /dev/null ; then
    "Using cached build of Workspace..."
    ~/.cache/ca.solideogloria.Workspace/Versions/0.1.0/workspace validate •use‐version 0.1.0
else
    echo "No cached build detected, fetching Workspace..."
    rm -rf /tmp/Workspace
    git clone https://github.com/SDGGiesbrecht/Workspace /tmp/Workspace
    cd /tmp/Workspace
    swift build --configuration release
    cd "${REPOSITORY}"
    /tmp/Workspace/.build/release/workspace validate •use‐version 0.1.0
    rm -rf /tmp/Workspace
fi
