{ pkgs, ... }:
with pkgs; [
  procs
  fd
  libgcc
  libinput
  usbutils
  pciutils
  nil
  nixfmt-classic
  ripgrep
  nmon
  pinentry-qt
  unixtools.xxd
  qrrs
  nmap
  graphviz
]
