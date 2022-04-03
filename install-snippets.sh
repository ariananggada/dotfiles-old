#!/usr/bin/env sh

BASEDIR="$(cd "$(dirname "$0")"; pwd)";

# for debug
echo "$BASEDIR"

if [ ! -d "$HOME/.vim" ]
then
  echo "ERROR: vim config doesnt exists, start or install vim first"

elif [ ! -d "$HOME/.config/nvim" ]
then
    echo "ERROR: neovim config doesnt exist, start or install neovim first"

else
    ln -sf $BASEDIR/.vim/UltiSnips $HOME/.vim
    ln -sf $HOME/.vim/UltiSnips $HOME/.config/nvim

fi
