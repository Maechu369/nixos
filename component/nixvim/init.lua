-- Vim :set {{{1
-- Alias of Vim settings {{{2
local set = vim.opt
local map = vim.keymap.set
local nmap = function(lhs, rhs, opts)
  map("n", lhs, rhs, opts)
end
local Key_v = function(lhs, rhs)
  return function()
    if vim.fn.visualmode() ~= "v" then
      return lhs
    end
    return rhs
  end
end
local vmap = function(lhs, rhs, opts)
  local opts_ = opts
  if opts_ == nil then
    opts_ = {}
  end
  opts_.expr = true
  map("x", lhs, Key_v(lhs, rhs), opts_)
end


-- Key mapping & commands {{{1


-- Disable Key {{{2

nmap("<Space>", "")
nmap("S", "")
nmap("s", "")
nmap("<C-Q>", "")
nmap("U", "")
map({"n", "i"}, "<C-S>", "")


-- Terminal {{{2


nmap("<C-S>", "<C-W>", {remap=true})
nmap("s", "<C-W>", {remap = true})
nmap("SS", "<C-W>W")
nmap("<C-W><C-S>", "<C-W>w")
nmap("<C-W>s", "<C-W>w")
nmap("<C-W><C-N>", "")
nmap("<C-S>", "<C-\\><C-N><C-W>", {remap= true})
nmap("<C-S><C-N>", "<C-\\><C-N>")
nmap("<C-R>", function() return '<C-\\><C-N>"'..vim.fn.nr2char(vim.fn.getchar()).."pi" end, {expr=true})


-- Macro {{{2


nmap("Q", "q")
nmap("q", "")


-- Visual {{{2


nmap("<Esc><Esc>", "<Cmd>nohlsearch<CR>")
nmap("<Space><C-L>", "<C-L><Cmd>nohlsearch<CR>")

nmap("<Space>s", "<Cmd>echo synstack(line('.'), col('.'))->map({index, syntaxID -> synIDattr(syntaxID, 'name')})<CR>")
nmap("<Space>S", "<Cmd>execute('syntax list '..synID(line('.'), col('.'), 0)->synIDattr('name'))<CR>")

nmap("<Space>h", "<Cmd>echo synID(line('.'), col('.'), 0)->synIDtrans()->synIDattr('name')<CR>")
nmap("<Space>H", "<Cmd>source $VIMRUNTIME/syntax/hitest.vim<CR><C-W>H", { desc = 'Highlight test' })


-- Folding {{{2


nmap("zg", "za")
nmap("zG", "zA")


-- Inter-mode key command {{{2


map({ "n", "x", "c" }, ";", ":")
map({ "n", "c" }, ":", ";")

map({ "", "t", "l" }, "<BS>", "<C-H>", { remap = true })

map({ "", "t", "l" }, "<C-M>", "<CR>", { remap = true })


-- Normal-mode commands {{{2


-- Registers {{{3

nmap("x", '"_x', { desc = 'x with Blackhole register' })

-- 貼り付け先のインデントに合わせてペーストする@483rd
nmap("p", "]p")
nmap("P", "]P")
nmap("]p", "p")
nmap("]p", "p")

map("x", "p", '"0p')

nmap("Y", "y$")


-- Display {{{3

-- Show Buf No @551st
nmap("<C-G>", "2<C-G>")

nmap("<Space>r", "<Cmd>registers<CR>")

nmap("<Space>m", "<Cmd>marks<CR>")

-- Make {{{3

nmap("<F5>", "<Cmd>make<CR>")

-- Redo {{{3

nmap("U", "<C-R>")


-- Motion {{{2


nmap("<Up>", "gk")
nmap("<Down>", "gj")
map("x", "<Up>", "gk")
map("x", "<Down>", "gj")

nmap("0", "^")
nmap("^", "0")


-- EX commands {{{2


nmap("!", ":<C-U>!")

-- @541st
vim.cmd([[command! -bar RTP echo substitute(&runtimepath, ",", "\\n", "g")]])


-- Jump {{{2


nmap("<Space>J", "<Cmd>jumps<CR>")


-- Buffer {{{2


nmap("<Space>t", "<Cmd>vnew term://zsh<CR>", { desc = 'Open terminal with this window' })
nmap("<Space>T", "<Cmd>edit term://zsh<CR>", { desc = 'Open terminal with new window' })

-- @540th
vim.api.nvim_create_autocmd("VimResized", {
  group = "init",
  command = "wincmd ="
})


-- ファイルを開いたとき、カーソル位置を復元 {{{2
-- :h restore-cursor
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = "init",
  callback = function()
    if vim.fn.line("'\"") <= vim.fn.line("$") then
      -- if (mark ") <= (lines in this buffer), so it means is (mark ") there?
      -- jump to (mark "), the cursor position when last exiting the current buffer; see :h `quote
      -- But it works without init.lua
      vim.cmd('normal! g`"')
      return 1
    end
  end
})


-- NVIM Plugins {{{1


require("lualine").setup({
  options = {
    theme = "powerline"
  }
})
-- modeline {{{1
-- vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
