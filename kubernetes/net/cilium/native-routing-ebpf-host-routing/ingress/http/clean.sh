#!/bin/bash

readonly LAB_NAME="$1"

kind delete cluster --name "$LAB_NAME"
