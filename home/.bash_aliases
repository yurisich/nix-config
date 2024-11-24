#!/bin/bash

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

bind '"\C-l": "history -r; clear\n"'

alias ?="echo $?"
alias less='less -R'

alias ~='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias cp='cp -i'
alias docker=podman
alias dc=podman-compose
alias emacs='emacs --no-splash'
alias kub=kubectl
alias ll='ls -lAh'
alias pbc='fc -ln -1 | awk '\''{$1=$1}1'\'' ORS='\'''\'' | xsel -b'
alias sudo='sudo '
alias tf=terraform
