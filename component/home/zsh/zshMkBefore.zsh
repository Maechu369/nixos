#!/usr/bin/env zsh
export TTY_SHELL=$(echo $TTY | cut -d '/' -f 3-)

if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

export GPG_TTY=$(tty)
command -v gpgconf >/dev/null 2>&1 && export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

PATH=$HOME/bin:$PATH
export PATH
