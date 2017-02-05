#!/bin/bash

# Refresh Workspace (Linux).sh
#
# This source file is part of the Workspace open source project.
# https://github.com/SDGGiesbrecht/Workspace
#
# Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
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

# Find and enter repository.
cd "${0%/*}"

# Run refresh in terminal.
gnome-terminal -e "bash --login -c \"source ~/.bashrc; ./Refresh\ Workspace\ \(macOS\).command; exec bash\""
