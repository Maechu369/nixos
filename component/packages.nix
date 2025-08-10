{ pkgs, ... }:
with pkgs; [
  procs
  fd
  libgcc
  nil
  nixfmt-classic
  ripgrep
  nmon
  pinentry-qt
  unixtools.xxd
]
