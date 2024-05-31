#!/bin/bash

set -e
set -u
set -v
set -x

readonly LAB_NAME="$1"

kind delete cluster --name "$LAB_NAME"
