#!/usr/bin/env zsh
export TTY_SHELL=$(echo $TTY | cut -d '/' -f 3-)

if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

