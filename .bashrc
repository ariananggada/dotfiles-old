# System default
# --------------------------------------------------------------------

[ -f ~/.profile ] && . ~/.profile 

[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

# BASE=$(dirname $(readlink $BASH_SOURCE))

# Options
# --------------------------------------------------------------------
### set vi mode keybinding in bash
set -o vi
### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

# Prompt
# --------------------------------------------------------------------

if [ "$PLATFORM" = Linux ]; then
  PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
else
  export TERM=xterm-256color
  PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
fi

# universal UNIX clipboard and open command
if  [[ "${OS}" == "Linux" ]] ||
    [[ "${OS}" == "OpenBSD" ]] ||
    [[ "${OS}" == "FreeBSD" ]] ; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
  alias open='xdg-open'

elif [[ "${OS}" == "MINGW*" ]]; then
  alias pbcopy='clip'
  alias open='cmd /c start'

elif [[ "${OS}" == "CYGWIN*" ]]; then
  alias pbcopy='clip'
fi

# nvm
alias nvmup='nvm install node --reinstall-packages-from=node'

# personal env variable 
if [[ ! -z "${VIMCONFIG}" ]]
then
  export VIMCONFIG=$HOME/.vim
fi

# alias
alias c='clear;reset'
alias e=$EDITOR
alias ll='ls -lah'
alias llt='ls -laht'
alias l='ls -aF'
alias grep='GREP_COLOR="1;33;40" LANG=C grep --exclude-dir=node_modules --color=auto'
alias gst='git status'
alias gba='git branch -a'
alias gco='git checkout'
alias ga='git add'
alias gcm='git commit'
alias gpl='git pull'
alias mgpl='find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;'
alias gps='git push'
alias gfe='git fetch'
alias clr='reset;tmux clear-history'
alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

# tmux alias
alias tat='tmux new -s `basename $PWD`'
# Force tmux to assume the terminal supports 256 colours.
alias tmux='tmux -2'

## productivity alias
# print all files and size in current directory and sort them by size
if command -v fd > /dev/null; then
  alias sortbigfile='fd . -x du -h {} \; | sort -r'
else
  alias sortbigfile='find . -type f -exec du -h {} \; | sort -r'
fi

# docker machine
if command -v docker-machine > /dev/null; then
  eval $(docker-machine env docker-machine)
fi

# note taking zettel
export NOTE_PATH="$HOME/wiki/note"

# if [[ -L "$NOTE_PATH" && -d "$NOTE_PATH" ]]; then
#   # # moved to vimrc func
#   # export NOTE_PATH_SYMLINK=$(readlink $NOTE_PATH)
# fi

# scratch file
if [ -d "$HOME/tmp" ]; then
  SCRATCH_FILE="$HOME"/tmp/scratch.md
  if [ -e "$HOME/tmp/scratch.md" ]; then
    alias scratch='$EDITOR "$SCRATCH_FILE"'
  else
    touch "$SCRATCH_FILE"
  fi
fi

# # docker
if command -v "docker" > /dev/null 2>&1; then
  alias dps='docker ps -a'
  alias di='docker images -a'
  alias dv='docker volume ls'
  alias dn='docker network ls'
  alias sprune='docker system prune'
  alias vprune='docker volume prune'

  # # using docker-machine start default first
  # # disabled for now
  # if command -v "docker-machine" > /dev/null 2>&1; then
  #   eval "$(docker-machine env default)"
  # fi
fi

# skim
export PATH="$PATH:$HOME/.skim/bin"
alias xl="exa --group-directories-first --classify --git"
alias xll="xl -lah"
alias skvim='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview="preview.sh -v {}" --preview-window=up:50%:hidden)"; [[ $? -eq 0 ]] && nvim "$x" || true }; f'
export SKIM_DEFAULT_OPTS='--color "preview-bg:237"'

# fzf
# export FZF_DEFAULT_OPTS='--color "preview-bg:237"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git --exclude node_modules'
fi

command -v bat > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# ssh serveraliveinterval
alias ssh='ssh -o "ServerAliveInterval 60"'

# nomachine bin setup
# this detection script are for linux platform
if [[ -d "/usr/NX" ]]; then
  export PATH="$PATH:/usr/NX/bin"
fi

## Function

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
    # tmp="$(mktemp)"
    # cross compatibility for mac os x (Darwin) and Linux
    tmp=$(mktemp 2>/dev/null || mktemp -t 'lfcd')
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# ctrl-o lfcd
# ctrl-o are map to \017 in macos
if [[ -t 0 && $- = *i* ]]; then
  if  [[ "${OS}" == "Darwin" ]]; then
    stty discard undef
    bind '"\017":"lfcd\n"'
  else
    bind '"\C-o":"lfcd\n"'
  fi
fi

notify() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 [bin_name] [message]"
  elif [[ -z "$2" ]]; then
    echo "usage: $0 [bin_name] [message]"
  else
    # result=$( { $@ } 2>&1 )
    # ding && osascript -e "display notification \"$result\" with title \"$1\""
    if [[ "$OS" == 'Darwin' ]]; then
      ding && osascript -e "display notification \"$2\" with title \"$1\""
    else
      ding && notify-send "$2 $1"
    fi
  fi
}

countdown() {
  if [[ -z "$1" ]]; then
    echo "usage: countdown [time] (2500 are 25 minutes, 300 are 5 minutes)"
    echo "example: countdown 2500 300"
  elif [[ -z "$2" ]]; then
    echo "usage: countdown [time] (2500 are 25 minutes, 300 are 5 minutes)"
    echo "example: countdown 2500 300"
  else
    while [ true ]
    do

      # notify "countdown" "countdown start" && termdown.py $1 && reset;
      # notify "countdown" "rest for five minutes" && reset && echo "rest for 5 minutes" && sleep $2;

      termdown.py --title "work" $1 && reset && clear;
      termdown.py --title "rest" $2 && reset && clear;
    done
  fi
}

ext() {
  ext-all --exclude .git --exclude target --exclude "*.log"
}

ext-all() {
  local name=$(basename $(pwd))
  cd ..
  tar -cvzf "$name.tgz" $* --exclude "$name.tgz" "$name"
  cd -
  mv ../"$name".tgz .
}

if [[ "$PLATFORM" = 'Darwin' ]]; then
  alias tac='tail -r'
  o() {
    open --reveal "${1:-.}"
  }
fi

rg_vim() {
  $EDITOR $(rg "$1" | sk | cut -d':' -f1)
}

rg_less() {
  $EDITOR $(rg "$1" | sk | cut -d':' -f1)
}

# fh - repeat history
fh() {
  echo $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

vf() { 
  $EDITOR $(sk)
}

# search file inside code dir and open on $EDITOR(vim)
vfc() { 
  $EDITOR $(fd . code | sk) 
}

vd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d \
      -print 2> /dev/null | sk --no-multi) &&
  cd "$dir"
}

cdf() {
   local file
   local dir
   file=$(sk -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | sk | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fzf <3 tmux:)
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | sk --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

[ -f ~/z/z.sh ] && source ~/z/z.sh
[ -f /opt/local/share/fzf/shell/key-bindings.bash ] && source /opt/local/share/fzf/shell/key-bindings.bash


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
