{ pkgs, ... }:
with pkgs; [
  procs
  fd
  libgcc
  pciutils
  nil
  nixfmt-classic
  ripgrep
  nmon
  pinentry-qt
  unixtools.xxd
  qrrs
  qrencode
  python313Packages.qrcode
  paperkey
]
