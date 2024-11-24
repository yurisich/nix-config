#!/bin/bash
export SHELL="/bin/bash"
export EDITOR="emacsclient"
export XDG_CONFIG_HOME="$HOME"

gpgconf --launch gpg-agent

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye > /dev/null

shopt -s histappend
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL=ignoreboth
export HISTSIZE=16348
export HISTFILESIZE=16348
export HISTIGNORE='ls:bg:fg:history:pbc'
export HISTTIMEFORMAT='%F %T '

export STARSHIP_CONFIG="$HOME/.starship.toml"
eval "$(starship init bash)"

source "$HOME"/.bash_aliases
