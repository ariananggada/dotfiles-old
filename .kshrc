# use vim if it's installed, vi otherwise
case "$(command -v vim)" in
  */vim) VIM=vim ;;
  *)     VIM=vi  ;;
esac

export ZK_PATH=$HOME/notes

export EDITOR=$VIM
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export CLICOLOR=1
HISTFILE=$HOME/.ksh_history
HISTSIZE=20000

# emacs mode gives you the familiar Ctrl-A, Ctrl-E, etc
set -o emacs

# use colorls if it's installed, plain old ls otherwise
if command -v colorls > /dev/null ; then
  LS='colorls'
else
  LS='ls'
fi
alias ls="$LS -FHh"
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ...'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -ch'
command -v neomutt > /dev/null && alias mutt='neomutt'
alias e="$EDITOR"
alias svim="doas vim"
alias svi="doas vi"

# tricky alias
alias gst="git status"
alias ga="git add"
alias gcm="git commit"
alias gpl="git pull"
alias gps="git push"
alias gco="git checkout"
alias gba="git branch -a"

# nice colored prompt that also sets xterm title
_XTERM_TITLE='\[\033]0;\u@\h:\w\007\]'
_PS1_CLEAR='\[\033[0m\]'
_PS1_BLUE='\[\033[34m\]'
case "$(id -u)" in
  0) _PS1_COLOR='\[\033[1;31m\]' ;;
  *) _PS1_COLOR='\[\033[32m\]'   ;;
esac
PS1='$_XTERM_TITLE\A $_PS1_COLOR\u@\h$_PS1_CLEAR:$_PS1_BLUE\w$_PS1_COLOR
\$$_PS1_CLEAR '

# function
# nnn
export NNN_TMPFILE=~/.config/nnn/.lastd
alias n='nnn -fis:; . "$NNN_TMPFILE"; rm -f "$NNN_TMPFILE"'
