#!/bin/bash

set -e

cd "$(dirname "$0")"

readonly LAB_NAME="$1"

kind delete cluster --name "$LAB_NAME"

rm -f cert.pem key.pem
