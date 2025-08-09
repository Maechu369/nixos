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

-- modeline {{{1
-- vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
