#!/usr/bin/env python3
"""nixvim生成config(nvim-init.lua)を非NixOSのNeovim向けに変換する。

- paqヘッダ(プラグインを/nix/storeパスで読み込む部分)を除去
- 残った/nix/storeパス(主にlsp serversのcmd)を素のバイナリ名へ変換
- lazy.nvimのbootstrapとプラグインspec(nixpkgsのsrc.revでコミット固定)を生成
"""

import json
import re
import sys

BOOTSTRAP = """-- Generated from nixvim config (nix build .#packages.x86_64-linux.nixvim-export).
-- Do not edit init.lua directly; edit the nixvim module and regenerate.
-- Plugins are managed by lazy.nvim and fetched from GitHub on first startup.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("nixvim-plugins"))
"""


def strip_paq(text):
    """require('paq')からpaq.paq {...}呼び出し全体までを削除する。"""
    lines = text.splitlines(keepends=True)
    out = []
    i = 0
    removed = False
    while i < len(lines):
        line = lines[i]
        if not removed and re.search(r"""require\(['"]paq['"]\)""", line):
            j = i
            depth = 0
            started = False
            while j < len(lines):
                d = lines[j].count("{") - lines[j].count("}")
                if not started and d > 0:
                    started = True
                if started:
                    depth += d
                    if depth <= 0:
                        break
                j += 1
            i = j + 1
            removed = True
            continue
        out.append(line)
        i += 1
    return "".join(out), removed


def strip_store_paths(text):
    # "/nix/store/hash-name/bin/prog" (lsp cmd等) -> "prog"
    text = re.sub(
        r"/nix/store/[a-z0-9]{32}-[A-Za-z0-9._+-]+/bin/[A-Za-z0-9._+-]+",
        lambda m: m.group(0).rsplit("/bin/", 1)[1],
        text,
    )
    # 残ったプラグイン等のstoreプレフィックスは除去(あっても機能しないため)
    text = re.sub(r"/nix/store/[a-z0-9]{32}-[A-Za-z0-9._+-]+", "", text)
    return text


def lazy_specs(entries):
    seen = set()
    specs = []
    unresolved = []
    for p in entries:
        owner, repo, rev = p.get("owner"), p.get("repo"), p.get("rev")
        key = (owner, repo)
        if not owner or not repo:
            key = (p["pname"], p["version"])
            if key not in seen:
                seen.add(key)
                unresolved.append(p)
            continue
        if key in seen:
            continue
        seen.add(key)
        parts = [f'"{owner}/{repo}"']
        if rev and rev.startswith("refs/tags/"):
            parts.append('version = "%s"' % rev[len("refs/tags/"):])
        elif rev and re.fullmatch(r"[0-9a-f]{40}", rev):
            parts.append(f'commit = "{rev}"')
        elif rev:
            parts.append('version = "%s"' % rev)
        if p["pname"] == "nvim-treesitter":
            parts.append('build = ":TSUpdate"')
        specs.append("  { " + ", ".join(parts) + " },")
    return specs, unresolved

TERMUX_LSP = {
    "lua_ls": "pkg install lua-language-server",
    "nil_ls": "pkg install nil",
    "pyright": "pkg install nodejs-lts && npm install -g pyright",
    "ruff": "pkg install ruff",
    "gopls": "pkg install golang && go install golang.org/x/tools/gopls@latest",
}



def main():
    json_path, out_dir = sys.argv[1], sys.argv[2]
    target = sys.argv[3] if len(sys.argv) > 3 else "linux"
    with open(json_path) as f:
        data = json.load(f)
    with open(data["initLua"]) as f:
        init = f.read()

    body, removed = strip_paq(init)
    if not removed:
        print("warning: paq header not found in generated init.lua", file=sys.stderr)
    body = strip_store_paths(body)

    specs, unresolved = lazy_specs(data["plugins"] + data["extraPlugins"])

    plugins_lua = [
        "-- Plugin list exported from nixvim config; pinned to nixpkgs source revisions.",
        "-- Loaded at startup (no lazy = lazy-load).",
        "return {",
    ]
    plugins_lua.extend(specs)
    for p in unresolved:
        plugins_lua.append(f'  -- UNRESOLVED: {p["pname"]} (no GitHub source in nixpkgs)')
    plugins_lua.append("}")

    with open(f"{out_dir}/init.lua", "w") as f:
        f.write(BOOTSTRAP + body)
    with open(f"{out_dir}/lua/nixvim-plugins.lua", "w") as f:
        f.write("\n".join(plugins_lua) + "\n")

    readme = []
    if target == "termux":
        readme.append("# nixvim export (Termux)")
    else:
        readme.append("# nixvim export (non-NixOS)")
    readme.append("")
    readme.append("Install with:")
    readme.append("")
    readme.append("```sh")
    readme.append("cp -r init.lua lua ~/.config/nvim/   # 既存 ~/.config/nvim がある場合は退避")
    readme.append("```")
    readme.append("")
    readme.append("初回起動時にlazy.nvimがプラグインをGitHubから取得する(ネット必須)。")
    if target == "termux":
        readme.append("tree-sitterパーサは端末上でビルドされる(`:TSUpdate`済み、`pkg install clang tree-sitter`が必要)。")
    else:
        readme.append("tree-sitterパーサはターゲット上でビルドされる(`:TSUpdate`済み、cc/tree-sitter-cliが必要)。")
    readme.append("")
    if target == "termux":
        readme.append("gitはlazyのcloneに必須(Termuxでは`pkg install git`)。")
        readme.append("")
    readme.append("## 手動導入が必要なLSPサーバー(バイナリをPATH上に用意)")
    readme.append("")
    if target == "termux":
        readme.append("| server | 導入コマンド | 起動コマンド |")
        readme.append("|---|---|---|")
        for s in data["lspServers"]:
            cmd = " ".join(s["cmd"]) if s["cmd"] else s["package"]
            readme.append(f"| {s['name']} | {TERMUX_LSP.get(s['name'], 'pkg install ' + s['package'])} | `{cmd}` |")
    else:
        readme.append("| server | nixpkgs package | 起動コマンド |")
        readme.append("|---|---|---|")
        for s in data["lspServers"]:
            cmd = " ".join(s["cmd"]) if s["cmd"] else s["package"]
            readme.append(f"| {s['name']} | {s['package']} | `{cmd}` |")
    readme.append("")
    if data["luaPackages"]:
        readme.append("## luarocks依存(手動: `luarocks install ...`)")
        readme.append("")
        for p in data["luaPackages"]:
            readme.append(f"- {p['pname']} {p['version'] or ''}")
        readme.append("")
    if unresolved:
        readme.append("## 解決できなかったプラグイン(GitHub座標なし・手動導入)")
        readme.append("")
        for p in unresolved:
            readme.append(f"- {p['pname']} {p['version'] or ''}")
        readme.append("")
    if target == "termux":
        readme.append("クリップボードはTermux:API経由(`pkg install termux-api`とTermux:APIアプリが必要)。")
    else:
        readme.append(" clipboardのwl-copyプロバイダはwl-clipboardのインストールが前提。")
    readme.append("")

    with open(f"{out_dir}/README.md", "w") as f:
        f.write("\n".join(readme))


if __name__ == "__main__":
    main()
