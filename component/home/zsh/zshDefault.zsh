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

setopt completealiases
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
      if [[ "$2" == 'list' ]] && command -v fzf >/dev/null 2>&1; then
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
      if [[ "$#" == 1 ]] && command -v fzf >/dev/null 2>&1; then
        local branch
        branch=$(command git branch | fzf --prompt='branch > ' --preview='git log --graph --oneline --decorate $(echo {} | cut -c3-)')
        [[ "$branch" == '' ]] && return 1
        command git checkout "$branch"
      else
        command git "$@"
      fi
      ;;
    'history' )
      if ! command -v fzf >/dev/null 2>&1; then
        echo "git history: fzf not found" >&2
        return 1
      fi
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
# zsh内蔵のfd(find)aliasを関数で上書きする
unalias fd 2>/dev/null
fd() {
  if ! whence -p fd >/dev/null 2>&1 || ! command -v fzf >/dev/null 2>&1; then
    echo "fd: fd/fzf not found" >&2
    return 1
  fi
  local dir
  dir=$(command fd --type d --strip-cwd-prefix | fzf --prompt='cd > ' --preview='eza --color=always --git --icons -1F {}')
  [[ "$dir" == '' ]] && return 1
  cd "$dir"
}

fkill() {
  if ! command -v procs >/dev/null 2>&1 || ! command -v fzf >/dev/null 2>&1; then
    echo "fkill: procs/fzf not found" >&2
    return 1
  fi
  procs --tree | fzf --prompt='kill > ' --bind='enter:become(kill $(echo {} | grep -oE "[0-9]+" | head -n 1))'
}

if [[ $TERM = 'xterm-kitty' ]]; then
  alias ssh='kitty +kitten ssh'
fi
command -v kitty >/dev/null 2>&1 && alias icat='kitty +kitten icat'
command -v direnv 1>/dev/null && eval "$(direnv hook zsh)" 

# 外部コマンド不在時にaliasを定義しない(未定義なら素のls/rm/diff等がそのまま使える)
command -v eza >/dev/null 2>&1 && {
  alias ls='eza -F'
  alias la='eza -aF'
  alias ll='eza -aahlF'
  alias lt="eza -aT -L 3 -I '.git|.cache'"
}
command -v delta >/dev/null 2>&1 && {
  alias diff=delta
  alias diffs='DELTA_FEATURES=+side-by-side delta'
}
command -v trash >/dev/null 2>&1 && alias rm=trash
command -v vim >/dev/null 2>&1 && alias v=vim
command -v python3 >/dev/null 2>&1 && {
  alias python=python3
  alias py=python
}
command -v procs >/dev/null 2>&1 && alias pc='procs --tree'
command -v tea >/dev/null 2>&1 && alias te=tea
command -v systemd-manager-tui >/dev/null 2>&1 && alias sys=systemd-manager-tui
command -v docker >/dev/null 2>&1 && alias compose='docker compose'
command -v tmux >/dev/null 2>&1 && alias tmux='tmux new -A'
command -v lsblk >/dev/null 2>&1 && alias lsblk='lsblk -ipo +UUID'
# vim: et
