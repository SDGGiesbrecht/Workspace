#!/bin/bash

#

set -e
REPOSITORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${REPOSITORY}"
if workspace version > /dev/null 2>&1 ; then
    echo "Systeminstallation von Arbeitsbereich wird verwendet ..."
    workspace validate $1 $2 $3 $4 •use‐version [Current Version]
elif ~/Library/Caches/ca.solideogloria.Workspace/Versions/[Current Version]/workspace version > /dev/null 2>&1 ; then
    echo "Systemzwischenspeicher von Arbeitsbereich wird verwendet ..."
    ~/Library/Caches/ca.solideogloria.Workspace/Versions/[Current Version]/workspace validate $1 $2 $3 $4 •use‐version [Current Version]
elif ~/.cache/ca.solideogloria.Workspace/Versions/[Current Version]/workspace version > /dev/null 2>&1 ; then
    echo "Systemzwischenspeicher von Arbeitsbereich wird verwendet ..."
    ~/.cache/ca.solideogloria.Workspace/Versions/[Current Version]/workspace validate $1 $2 $3 $4 •use‐version [Current Version]
elif .build/SDG/Workspace/workspace version > /dev/null 2>&1 ; then
    echo "Lagerzwischenspeicher von Arbeitsbereich wird verwendet ..."
    .build/SDG/Workspace/workspace validate $1 $2 $3 $4 •use‐version [Current Version]
else
    echo "Keinen Zwischenspeicher gefunden; Arbeitsbereich wird geholt ..."
    export OVERRIDE_INSTALLATION_DIRECTORY=.build/SDG
    curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace "https://github.com/SDGGiesbrecht/Workspace" [Current Version] "" workspace
    .build/SDG/Workspace/workspace validate $1 $2 $3 $4 •use‐version [Current Version]
fi
