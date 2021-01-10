#!/bin/bash
set -euxo pipefail

PROJECT_DIR=/tmp

if compgen -G "${PROJECT_DIR}/*.pdf" > /dev/null ; then
    echo "pattern exists!"
else
    echo "pattern does NOT extists!"
    ls 
fi


