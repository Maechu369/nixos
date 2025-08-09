#!/usr/bin/env zsh
export TTY_SHELL=$(echo $TTY | cut -d '/' -f 3-)

if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi
