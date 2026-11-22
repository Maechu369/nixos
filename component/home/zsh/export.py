#!/usr/bin/env python3
"""Convert home-manager generated zsh dotfiles into portable (non-NixOS) dotfiles.

Usage: export.py PATHS_FILE OUT_DIR TARGET   (TARGET = linux | termux)

PATHS_FILE lists, one per line: .zshrc .zshenv .zprofile ~/.zshenv homeDirectory.
Store paths are rewritten so the files work with the target platform's packages.
"""

import os
import re
import sys

AUTOSUGGEST_PATHS = {
    "linux": "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh",
    "termux": "$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh",
}


def transform(text, home_dir, target):
    out = []
    skip = False
    for line in text.splitlines():
        s = line.strip()
        # NIX_PROFILES由来のfpathループ(非NixOSでは不要)
        if "NIX_PROFILES" in s:
            skip = True
            continue
        if skip:
            if s == "done":
                skip = False
            continue
        # Nix固有のhelpディレクトリ/セッション変数ファイル参照
        if s.startswith("HELPDIR=") or "hm-session-vars" in s:
            continue
        if re.match(r"^source\s+.*zsh-autosuggestions/zsh-autosuggestions\.zsh\s*$", s):
            path = AUTOSUGGEST_PATHS[target]
            out.append(f"[[ -f {path} ]] && source {path}")
            continue
        if s == 'eval "$(gh completion -s zsh)"':
            out.append('command -v gh >/dev/null 2>&1 && eval "$(gh completion -s zsh)"')
            continue
        if "/nix/store" in line:
            print(f"warning: dropped store path line: {line}", file=sys.stderr)
            continue
        out.append(line.replace(f'"{home_dir}"', '"$HOME"').replace(home_dir, "$HOME"))
    return "\n".join(out) + "\n"


def main():
    paths_file, out_dir, target = sys.argv[1], sys.argv[2], sys.argv[3]
    with open(paths_file) as f:
        paths = f.read().splitlines()
    zshrc_src, zshenv_src, zprofile_src, zshenv_home_src, home_dir = paths

    if target not in AUTOSUGGEST_PATHS:
        sys.exit(f"unknown target: {target}")

    os.makedirs(f"{out_dir}/zsh", exist_ok=True)
    with open(f"{out_dir}/zsh/.zshrc", "w") as f:
        f.write(transform(open(zshrc_src).read(), home_dir, target))
    with open(f"{out_dir}/zsh/.zshenv", "w") as f:
        f.write(transform(open(zshenv_src).read(), home_dir, target))
    with open(f"{out_dir}/zsh/.zprofile", "w") as f:
        f.write(transform(open(zprofile_src).read(), home_dir, target))
    with open(f"{out_dir}/zshenv", "w") as f:
        f.write(transform(open(zshenv_home_src).read(), home_dir, target))

    readme = []
    if target == "termux":
        readme.append("# zsh export (Termux)")
    else:
        readme.append("# zsh export (non-NixOS)")
    readme.append("")
    readme.append("Install with:")
    readme.append("")
    readme.append("```sh")
    readme.append("cp -r zsh ~/.config/")
    readme.append("cp zshenv ~/.zshenv   # ZDOTDIR=$HOME/.config/zsh へのshim")
    readme.append("```")
    readme.append("")
    readme.append("## 前提パッケージ(alias/function用。無くてもzshは起動する)")
    readme.append("")
    if target == "termux":
        readme.append("```sh")
        readme.append("pkg install zsh git gh fzf fd eza delta procs direnv tmux zsh-autosuggestions")
        readme.append("```")
        readme.append("")
        readme.append("- `rm` alias は trash-cli 前提(`pip install trash-cli`)。`remove` で本来のrm。")
        readme.append("- `sys` alias (systemd-manager-tui) はTermuxでは動作しない。")
        readme.append("- `te` alias (tea) は任意(`pkg install tea` があれば導入)。")
    else:
        readme.append("パッケージ名はディストリビューションに依存する(Debian/Ubuntu例):")
        readme.append("")
        readme.append("```sh")
        readme.append("apt install zsh git gh fzf fd-find eza direnv tmux zsh-autosuggestions")
        readme.append("```")
        readme.append("")
        readme.append("- `delta` / `procs` はaptに無い(cargo等別途)。`diff`/`diffs`/`pc` alias用。")
        readme.append("- `rm` alias は trash-cli 前提(`apt install trash-cli` 等)。`remove` で本来のrm。")
    readme.append("")

    with open(f"{out_dir}/README.md", "w") as f:
        f.write("\n".join(readme))


if __name__ == "__main__":
    main()
