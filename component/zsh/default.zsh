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

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars ' /=;@:{}[]()<>,|.'
zstyle ':zle:*' word-style unspecified

eval "$(gh completion -s zsh)"

git() {
  case "$1" in
    'diffs' )
      if [[ $(command -v delta) ]]; then
        DELTA_FEATURES=+side-by-side
        command git diff "${@:2}"
        DELTA_FEATURES=+
      else
        command git "$@"
      fi
      ;;
    'stash')
      if [[ "$2" == 'list' ]]; then
        local stash
        DELTA_FEATURES=+side-by-side
        stash=$(command git stash list | awk -F'[: ]' '{print "$1"}' | fzf --prompt='git stash > ' --preview='command git stash list | grep {}; command git stash show -p {}')
        if [[ "$stash" == '' ]]; then
          DELTA_FEATURES=+
          return
        fi
        git stash show -p "$stash" >&2
        echo "$stash"
        DELTA_FEATURES=+
      else
        command git "$@"
      fi
      ;;
    'create' )
      command git branch "$2"
      command git checkout "$2"
      ;;
    'branch' )
      if [[ "$#" == 1 ]]; then
        local branch
        branch=$(command git branch | fzf --prompt='branch > ' --preview='git log --graph --oneline --decorate $(echo {} | cut -c3-)')
        [[ "$branch" == '' ]] && return
        command git checkout "$branch"
      else
        command git "$@"
      fi
      ;;
    'history' )
      local commit
      commit=$(command git log --graph --oneline --decorate | fzf --prompt='commit > ' --preview='git log -n 1 -p --stat $(echo {} | grep -o -E \[0-9a-f\]+ | head -n 1)' | grep -o -E '[0-9a-f]+' | head -n 1)
      [[ "$commit" == '' ]] && return
      command git log -n 1 -p --stat "$commit"
      ;;
    *)
      command git "$@"
      ;;
  esac
}

vf() {
  local file
  file=$(fzf --prompt='vim > ' --preview='fzf-preview.sh {}')
  [[ "$file" == '' ]] && return
  vim "$file"
}

fd() {
  local dir
  dir=$(command fd --type d --strip-cwd-prefix | fzf --prompt='cd > ' --preview='eza --git --icons -1F {}')
  [[ "$dir" == '' ]] && return
  cd "$dir"
}

fkill() {
  local process
  local pid
  process=$(procs --tree | fzf --prompt='kill > ')
  [[ "$process" == '' ]] && return
  pid=$(echo "$process" | grep -oE '[0-9]+' | head -n 1)
  kill "$pid"
  echo "kill $pid" >&w
}

sys() {
  local unit
  unit=$(systemctl list-units | tail -n +2 | awk '{print "$1"}' | fzf --prompt='system unit > ' --preview='systemctl status -- {}')
  [[ "$unit" == '' ]] && return
  systemctl status -- "$unit" >&2
  echo "$unit"
}
# vim: et
