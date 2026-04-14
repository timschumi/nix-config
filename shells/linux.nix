{ pkgs, ... }:
(pkgs.mkShell {
  packages = with pkgs; [
    # basic
    bison
    flex
    gcc
    gnumake

    # menuconfig
    ncurses.dev
    pkg-config
  ];
})
