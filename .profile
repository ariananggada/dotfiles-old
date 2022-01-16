# $OpenBSD: dot.profile,v 1.7 2020/01/24 02:09:51 okan Exp $
#
# sh/ksh initialization

# # for openbsd
# PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games
# export PATH HOME TERM
# export ENV=$HOME/.kshrc


# detect os platform
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     export OS=Linux;;
    Darwin*)    export OS=Darwin;;
    CYGWIN*)    export OS=Cygwin;;
    MINGW*)     export OS=MinGw;;
    OpenBSD*)   export OS=OpenBSD;;
    FreeBSD*)   export OS=FreeBSD;;
    *)          export OS="UNKNOWN:${unameOut}"
esac
# end detect os platform


# general setup
if [[ "${OS}" == "Linux" ]] || 
   [[ "${OS}" == "Darwin" ]] || 
   [[ "${OS}" == "OpenBSD" ]] || 
   [[ "${OS}" == "FreeBSD" ]]; then

  export PATH=$HOME/bin:$HOME/.local/bin:$PATH

  if [[ "${OS}" != "Darwin" ]]; then
    export LC_ALL=en_US.UTF-8  
    export LANG=en_US.UTF-8
  fi

  if command -v nvim &> /dev/null; then
    export EDITOR="nvim"
  else
    export EDITOR="vim"
  fi

  export READER="zathura"

  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_CACHE_HOME="$HOME/.cache"


  if [[ "${OS}" != "Darwin" ]]; then
    # export TERMINAL=st
    export BROWSER=firefox
    if [[ "${OS}" == "Linux" ]]; then
      pidof -s dwm >/dev/null 2>&1 && export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
    fi

    # fix java apps in dwm
    export _JAVA_AWT_WM_NONREPARENTING=1    # Fix for Java applications in dwm
    export _JAVA_OPTIONS='-Dswing.aatext=TRUE -Dawt.useSystemAAFontSettings=on'
  fi

  # # zsh
  # export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

  # zsh
  export ZDOTDIR="$HOME"

  # cvs
  export CVSROOT=$HOME/cvsroot

  if command -v nvim &> /dev/null; then
    export CVSEDITOR=nvim
  else
    export CVSEDITOR=vim
  fi

  # nodejs
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  export NODE_PATH="$(which node)"

  # vim
  export VIMCONFIG=$HOME/.vim

  # macports
  if ! command -v port &> /dev/null; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  fi

  # rust
  if ! command -v cargo &> /dev/null; then
    . "$HOME/.cargo/env"
  fi
  
  # golang
  if [[ "${OS}" != "Darwin" ]]; then
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH="$(go env GOPATH)"
    export PATH="$PATH:$(go env GOPATH)/bin"
  fi


  if [[ "${OS}" == "Darwin" ]]; then
    export PATH="$PATH:$(go env GOPATH)/bin"
    export GOPATH="$(go env GOPATH)"
  fi

  # java openjdk11
  if [[ "${OS}" == "Darwin" ]]; then
    # JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk11/Contents/Home
    JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk11-temurin/Contents/Home
  fi

  # doom emacs
  if [[ -d "$HOME/.emacs.d/bin" ]]; then
    export PATH="$PATH:$HOME/.emacs.d/bin"
  fi

  # show hidden dir
  if [[ "${OS}" == "Darwin" ]]; then
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
  fi


fi

# my note path
export NOTE_PATH="$HOME/wiki/notes"

export PATH="/usr/local/sbin:$PATH"
