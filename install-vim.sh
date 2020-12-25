#!/usr/bin/env sh

BASEDIR="$(cd "$(dirname "$0")"; pwd)";

# # for debug
# echo "$BASEDIR"

mkdir -p $HOME/.vim/after/ftplugin
mkdir -p $HOME/.vim/autoload
mkdir -p $HOME/.vim/indent

ln -sf $BASEDIR/.vim/after/ftplugin/*  $HOME/.vim/after/ftplugin/
ln -sf $BASEDIR/.vim/autoload/*  $HOME/.vim/autoload/
ln -sf $BASEDIR/.vim/indent/* $HOME/.vim/indent/
