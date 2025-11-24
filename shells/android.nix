{ pkgs, ... }:
(pkgs.buildFHSEnv {
  name = "android";
  targetPkgs =
    pkgs:
    (with pkgs; [
      ccache
      fontconfig
      gcc-unwrapped
      git-lfs
      git-repo
      m4
      pkgconf
      python3
      qemu-utils
      unzip
      zip
    ]);
  multiPkgs =
    pkgs:
    (with pkgs; [
      freetype
      glibc
      glibc.dev
      libgcc
      libxcrypt-legacy
      ncurses5
      openssl
      openssl.dev
      zlib
    ]);
  multiArch = true;
  profile = ''
    export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
    export ALLOW_NINJA_ENV=true

    export USE_CCACHE=1
    export CCACHE_COMPRESS=1
    export CCACHE_DIR=~/.cache/ccache
    export CCACHE_EXEC="$(which ccache)"
  '';
  runScript = "bash";
}).env
