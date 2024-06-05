#!/bin/bash
set -e
set -v
set -u

readonly LAB_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

sudo clab destroy --topo clab.yaml --cleanup

find ./startup-config -type d -exec sudo chmod 755 {} \;
find ./startup-config -type f -exec sudo chmod 644 {} \;

sudo chown -R "$USER":"$USER" ./startup-config/
