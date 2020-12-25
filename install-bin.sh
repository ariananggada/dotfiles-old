#!/usr/bin/env sh

BASEDIR="$(cd "$(dirname "$0")"; pwd)";

# # for debug
# echo "$BASEDIR"

mkdir -p ~/.local/bin

ln -sf $BASEDIR/.local/bin/*  ~/.local/bin/
