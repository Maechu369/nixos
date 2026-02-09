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
          return 1
        fi
        git stash show -p "$stash" >&2
        echo "$stash"
        DELTA_FEATURES=+
      else
        command git "$@"
      fi
      ;;
    'branch' )
      if [[ "$#" == 1 ]]; then
        local branch
        branch=$(command git branch | fzf --prompt='branch > ' --preview='git log --graph --oneline --decorate $(echo {} | cut -c3-)')
        [[ "$branch" == '' ]] && return 1
        command git checkout "$branch"
      else
        command git "$@"
      fi
      ;;
    'history' )
      local commit
      commit=$(command git log --graph --oneline --decorate | fzf --prompt='commit > ' --preview='echo {} | grep -o -E \[0-9a-f\]+ | head -n 1 | if read -r line; then; git log -n 1 -p --stat "$line"; else; echo Select commit; fi' | grep -o -E \[0-9a-f\]+ | head -n 1)
      [[ "$commit" == '' ]] && return 1
      command git log -n 1 -p --stat "$commit"
      ;;
    *)
      command git "$@"
      ;;
  esac
}

fd() {
  local dir
  dir=$(command fd --type d --strip-cwd-prefix | fzf --prompt='cd > ' --preview='eza --color=always --git --icons -1F {}')
  [[ "$dir" == '' ]] && return 1
  cd "$dir"
}

fkill() {
  procs --tree | fzf --prompt='kill > ' --bind='enter:become(kill $(echo {} | grep -oE "[0-9]+" | head -n 1))'
}

sys() {
  local unit
  unit=$(systemctl list-units | tail -n +2 | awk '{print $1}' | fzf --prompt='system unit > ' --preview='systemctl status -- {}')
  [[ "$unit" == '' ]] && return 1
  systemctl status -- "$unit" >&2
  echo "$unit"
}
# vim: et
