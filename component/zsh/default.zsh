#!/usr/bin/env zsh

# Mainly to go
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# When Nixos: programs.zsh.enable=true and use home.programs.zsh.enable=true
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

git() {
  if [[ $1 == 'diffs' ]]; then
    if [[ $(command -v delta) ]]; then
      DELTA_FEATURES=+side-by-side
      command git diff "${@:2}"
      DELTA_FEATURES=+
    else
      command git "$@"
    fi
  elif [[ $1 == 'stash' ]]; then
    if [[ $2 == 'list' ]]; then
      if [[ $(command -v fzf) ]]; then
        local stash
        DELTA_FEATURES=+side-by-side
        stash=$(command git stash list | awk -F'[: ]' '{print $1}' | fzf --prompt='git stash > ' --preview='command git stash list | grep {}; command git stash show -p {}')
        if [[ $stash == '' ]]; then
          DELTA_FEATURES=+
          return
        fi
        git stash show -p "$stash" >&2
        echo "$stash"
        DELTA_FEATURES=+
      else
        command git "$@"
      fi
    else
      command git "$@"
    fi
  else
    command git "$@"
  fi
}

