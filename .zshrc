# ian's zshrc config
# zmodload zsh/zprof
autoload -U colors && colors

########################################################################
# # disabling it for now
# # fancy stuff
# EMOJI=(💩 🐦 🚀 🐞 🎨 🍕 🐭 👽 ☕️ 🔬 💀 🐷 🐼 🐶 🐸 🐧 🐳 🍔 🍣 🍻 🔮 💰 💎 💾 💜 🍪 🌞 🌍 🐌 🐓 🍄 )

# RANDOM_EMOJI() {
#   SELECTED_EMOJI=${EMOJI[$RANDOM%${#EMOJI[@]}]};
#   echo -ne "$SELECTED_EMOJI";
# }

# NOW_TIME="%{$fg[red]%}[%D{%f/%m/%y} %{$fg[yellow]%}%D{%L:%M:%S}]%{$reset_color%}"

# PS1="${NOW_TIME} %{$fg[green]%}[%c] $(RANDOM_EMOJI) %{$fg[blue]%}
# $ %{$reset_color%}"
########################################################################

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}
$%b "

stty stop undef

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload -i zsh/complist

# # for mac
# if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
#     compinit
# else
#     compinit -C
# fi

# for linux
compinit


# Options {{{1
# History {{{2
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history
setopt auto_cd

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=10
bindkey -M viins 'jk' vi-cmd-mode

# use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'
# bindkey -s '^a' 'bc -l\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# dumb terminal
if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
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
alias l='ls -aF'
alias grep='GREP_COLOR="1;33;40" LANG=C grep --exclude-dir=node_modules --color=auto'
alias gst='git status'
alias gba='git branch -a'
alias gco='git checkout'
alias ga='git add'
alias gcm='git commit'
alias gpl='git pull'
alias gps='git push'
alias gfe='git fetch'
alias tmux='tmux -2'
alias tat='tmux new -s `basename $PWD`'
alias clr='clear;tmux clear-history'
alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

## productivity alias
# print all files and size in current directory and sort them by size
if command -v fd > /dev/null; then
  alias sortbigfile='fd . -x du -h {} \; | sort -r'
else
  alias sortbigfile='find . -type f -exec du -h {} \; | sort -r'
fi

# personal wiki, zettelkasten note-taking alias
alias wiki='nvim ~/wiki/'
alias wikis='fd -ap . ~/wiki/ | sk | xargs $EDITOR'

# note taking zettel
export NOTES_PATH="$HOME/notes"
if [[ -L "$NOTES_PATH" && -d "$NOTES_PATH" ]]; then
  # # moved to vimrc func
  # export NOTES_PATH_SYMLINK=$(readlink $NOTES_PATH)
fi

# # docker
# eval "$(docker-machine env default)"
# alias dps='docker ps -a'
# alias di='docker images -a'
# alias dv='docker volume ls'
# alias dn='docker network ls'
# alias sprune='docker system prune'
# alias vprune='docker volume prune'

# skim
export PATH="$PATH:$HOME/.skim/bin"
alias xl="exa --group-directories-first --classify --git"
alias xll="xl -lah"
alias skvim='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview="preview.sh -v {}" --preview-window=up:50%:hidden)"; [[ $? -eq 0 ]] && nvim "$x" || true }; f'
export SKIM_DEFAULT_OPTS='--color "preview-bg:237"'

# fzf
export FZF_DEFAULT_OPTS='--color "preview-bg:237"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
fi

command -v bat  > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
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

# note taking
note() {
    if [[ -z $1 ]]; then
        notes
    else
        args="$@"
        createfile "$args-note" md
    fi
}

# list notes
notes() {
  fd -e md -ap . ./ | sk | xargs $EDITOR
}

notify() {
  if [ -z "$1" ]
  then
    echo "usage: $0 [bin_name]"
  else
    result=$( { $@ } 2>&1 )
    ding && osascript -e "display notification \"$result\" with title \"$1\""
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

      termdown.py --title "work" $1 && reset;
      reset && termdown.py --title "rest" $2 && reset;
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

if [ "$PLATFORM" = 'Darwin' ]; then
  alias tac='tail -r'
  o() {
    open --reveal "${1:-.}"
  }
fi

rg_vim() {
  $EDITOR $(rg $1 | sk | cut -d':' -f1)
}

rg_less() {
  $EDITOR $(rg $1 | sk | cut -d':' -f1)
}

# fh - repeat history
fh() {
  echo $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

vf() { $EDITOR $(sk)}

# search file inside code dir and open on $EDITOR(vim)
vfc() { $EDITOR $(fd . code | sk) }

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/zsh-z/zsh-z.plugin.zsh ] && source ~/zsh-z/zsh-z.plugin.zsh

# my audio related stuff
# [ -f ~/.sox_tricks ] && source ~/.sox_tricks

# zprof
