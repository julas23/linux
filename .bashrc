# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups
export original_user=${SUDO_USER:-$(pstree -Alsu "$$" | sed -n "s/.*(\([^)]*\)).*($USER)[^(]*$/\1/p")}
export HISTTIMEFORMAT="<%F %T> (${original_user:-$USER}) "

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
Linha1="\n\[\033[38;5;6m\]\d\[\033[38;5;6m\] \t\[\033[38;5;1m\] [\[\033[38;5;11m\]\s\[\033[38;5;1m\]] \[\033[38;5;1m\]{\[\033[38;5;11m\]\$?\[\033[38;5;1m\]}"
Linha2="\[$(tput sgr0)\] \$(parse_git_branch)"
Linha3="\n\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;9m\]@\[$(tput sgr0)\]\[\033[38;5;27m\]\h\[\033[38;5;11m\]:\[\033[38;5;39m\]\w"
Linha4="\n\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
PROMPT=`echo $Linha1 $Linha2 $Linha3 $Linha4`

if [ "$color_prompt" = yes ]; then
    PS1=$PROMPT
else
    PS1=$PROMPT
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1=$PROMPT
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=always --group-directories-first -1plArths |awk '{print $4,$5,$2,$6,$7,$8,$9,$10}' |column -t'
    alias dir='ls'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls'

    alias grep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias vgrep='egrep -v --color=auto'

    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgn='kubectl get nodes'

    alias gp='git push'
    alias gc='git clone'
    alias gk='git checkout'
    alias gb='git branch -a'

    alias tfp='terraform plan'
    alias tfv='terraform validate'
    alias tfa='terraform apply'
    alias tfi='terraform import'

    alias tsp='terraspace plan'
    alias tsv='terraspace validate'
    alias tsa='terraspace apply'
    alias tsi='terraspace import'

    alias go2scout='ssh -i /home/juliano/.ssh/google_compute_engine juliano@35.205.133.55'

fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
